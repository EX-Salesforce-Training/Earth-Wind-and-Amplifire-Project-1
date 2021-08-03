/* 
 * Name: PartyListPageController
 * Authors: Gregory Mannerberg (gregory.mannerberg@revature.net)
 * Last Modified Date: 8/3/2021
 * Description: Controller for the PartyListPage, PartyPage, PartyWizardPage
 */
public with sharing class PartyListPageController {
    
    // Pagination variables
    private integer numRecords;
    private integer pageSize;
    private integer offset;
    public integer pageNumber {get{return offset/pageSize + 1;}}
    // Sorting variables
    @testVisible private string orderBy;
    @testVisible private boolean ascending;
    // Filter variables
    public string filterByName {get;set;}
    public string filterByAcceptingNewMembers {get;set;}
    public integer filterByPartySize {
        get;
        set {
            if (value < 0) {
                filterByPartySize = null;
            }
            else {
                filterByPartySize = value;
            }}}
    public string filterByMaxPartySizeComparisonOp {get;set;}
    public integer filterByMaxPartySize {
        get;
        set {
            if (value < 0) {
                filterByMaxPartySize = null;
            }
            else {
                filterByMaxPartySize = value;
            }}}
    public string filterByPartySizeComparisonOp {get;set;}
    public integer filterByMinimumLevelRequired {
        get;
        set {
            if (value>20){
                filterByMinimumLevelRequired = 20;
            } else if (value <= 0) {
                filterByMinimumLevelRequired = null;
            } else {
                filterByMinimumLevelRequired = value;
            }}}
    public string filterByMinLvlReqComparisonOp {get;set;}
    public List<string> filterByClassRequirements {get;set;}   
    // Party record creation variables
    public boolean confirmation {get;set;}
    public boolean failure {get;set;}
    // Controller state variables    
    public string partyid {get;set;}							// id of currentParty
    public Party__c currentParty {get;set;}						// Party to display on PartyPage
    public List<Guild_Member__c> currentPartyMembers{get;set;}	// currentParty's guild members
    public Party__c newParty {get;set;}							// Party to insert on PartyWizardPage
    
    public PartyListPageController() {
        setNumRecords();
        pageSize = 5;
        offset = 0;
		newParty = new Party__c();
        orderBy = 'Name';
        ascending = true;
        confirmation = false;
        failure = false;
    }
    
    /*
     * Returns a Party__c list to be displayed on the PartyListPage.
     * Dynamically builds a SOQL query using the page size, sorting, filtering options
     * selected by a user on the PartyListPage.
     */
    public List<Party__c> getParties() {
        string query = 'SELECT Name, Party_Size__c, Max_Party_Size__c, Accepting_New_Members__c, Minimum_Level_Required__c, Class_Requirements__c ' +
            'FROM Party__c ';
        if (filterByName != null || filterByAcceptingNewMembers != null || (filterByPartySize != null && filterByPartySizeComparisonOp != null) || (filterByMaxPartySize != null && filterByMaxPartySizeComparisonOp != null) || (filterByMinimumLevelRequired != null && filterByMinLvlReqComparisonOp != null) || (filterByClassRequirements != null && !filterByClassRequirements.isEmpty())) {
            query += 'WHERE ';
        }
        boolean whereAnd = false;
        if (filterByName != null) {
            query += 'Name LIKE \'%' + string.escapeSingleQuotes(filterByName) + '%\' ';
            whereAnd = true;
        }
        if (filterByAcceptingNewMembers == 'true') {
            if (whereAnd) {
                query += ' AND ';
            }
            query += 'Accepting_New_Members__c = true ';
            whereAnd = true;
        }
        else if (filterByAcceptingNewMembers == 'false') {
            if (whereAnd) {
                query += ' AND ';
            }
            query += 'Accepting_New_Members__c = false ';
            whereAnd = true;
        }
        if (filterByPartySize != null && filterByPartySizeComparisonOp != null) {
            if (whereAnd) {
                query += ' AND ';
            }
            query += 'Party_Size__c ' + filterByPartySizeComparisonOp + ' ' + filterByPartySize + ' ';
            whereAnd = true;
        }
        if (filterByMaxPartySize != null && filterByMaxPartySizeComparisonOp != null) {
            if (whereAnd) {
                query += ' AND ';
            }
            query += 'Max_Party_Size__c ' + filterByMaxPartySizeComparisonOp + ' ' + filterByMaxPartySize + ' ';
            whereAnd = true;
        }
        if (filterByMinimumLevelRequired != null && filterByMinLvlReqComparisonOp != null) {
            if (whereAnd) {
                query += ' AND ';
            }
            query += 'Minimum_Level_Required__c ' + filterByMinLvlReqComparisonOp + ' ' + filterByMinimumLevelRequired + ' ';
            whereAnd = true;
        }
        if (filterByClassRequirements != null && !filterByClassRequirements.isEmpty()) {
            if (whereAnd) {
            	query += ' AND ';
            }
            whereAnd = true;
            boolean whereOr = false;
            query += '(';
            for (string clss : filterByClassRequirements) {
                if (whereOr) {
                    query += ' OR ';
                }
                whereOr = true;
                query += 'Class_Requirements__c INCLUDES (\'' + clss + '\')';
            }
            query += ') ';
        }
        query += 'ORDER BY ' + orderBy;
        if (ascending) {
            query += ' ASC ';
        }
        else {
            query += ' DESC ';
        }
        query += ' NULLS LAST ';
        query += 'LIMIT :pageSize OFFSET :offset';
        return database.query(query);
    }
    
    public integer getNumRecords() {
        return numRecords;
    }
    
    public void setNumRecords() {
        numRecords = numRecords = [SELECT count() FROM Party__c];
    }
    
    public integer getPageSize() {
        return pageSize;
    }
    
    public void setPageSize(integer newPageSize) {
        pageSize = newPageSize;
        offset = (offset/pageSize)*pageSize;
    }
    
    public integer getOffset() {
        return offset;
    }
    
    // Set the offset for getting the next page.
    public void next() {
        offset += pageSize;
    }
    
    // Set the offset for getting the previous page.
    public void prev() {
        offset -= pageSize;
    }
    
    // Set the offset for getting the first page.
    public void first() {
        offset = 0;
    }
    
    // Set the offset for getting the last page.
    public void last() {
        if (Math.mod(numRecords, pageSize) == 0) {
            offset = (numRecords/pageSize - 1)*pageSize;
        }
        else {
        	offset = (numRecords/pageSize)*pageSize;
        }
    }
    
    /* Returns true if there is a next page. */
    public boolean getNxt() {
        return offset + pageSize < numRecords;
    }
    
    /* Returns true is there is a previous page. */
    public boolean getPrv() {
        return offset > 0;
    }
    
    public void orderByPartyName() {
        if (orderBy == 'Name') {
            ascending = !ascending;
        }
        else {
            orderBy = 'Name';
            ascending = true;
        }
        offset = 0;
    }
    
    public void orderByPartySize() {
        if (orderBy == 'Party_Size__c') {
            ascending = !ascending;
        }
        else {
            orderBy = 'Party_Size__c';
            ascending = true;
        }
        offset = 0;
    }
    
    public void orderByMaxPartySize() {
        if (orderBy == 'Max_Party_Size__c') {
            ascending = !ascending;
        }
        else {
            orderBy = 'Max_Party_Size__c';
            ascending = true;
        }
        offset = 0;
    }
    
    public void orderByMinimumLevelRequired() {
        if (orderBy == 'Minimum_Level_Required__c') {
            ascending = !ascending;
        }
        else {
            orderBy = 'Minimum_Level_Required__c';
            ascending = true;
        }
        offset = 0;
    }
    
    /* 
     * Dynamically grabs the current set of classes from the Party object's schema
     * and generates a list of select options from it.
     */
    public List<SelectOption> getClassList() {
        List<SelectOption> classes = new List<SelectOption>();
        Schema.DescribeFieldResult describeResult = Party__c.Class_Requirements__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = describeResult.getPickListValues();
        for (Schema.PicklistEntry pe : picklistEntries) {
            classes.add(new SelectOption(pe.getValue(), pe.getLabel()));
        }
        return classes;
    }
    
    // For switching to the PartyWizardPage
    public PageReference Wizard() {
        stopConfirmation();
        stopFailure();
        newParty = new Party__c();
        return Page.PartyWizardPage;
    }    
    
    // Insert a new party from the PartyWizardPage
    public void createParty() {
        try {
            insert newParty;
            numRecords++;
            partyid = newParty.id;
            showConfirmation();
        }
        catch (DMLException e) {
            showFailure();
        }
    }
    
    // For switching to the PartyListPage
    public PageReference listPage() {
        return Page.PartyListPage;
    }
    
    public void showConfirmation() {
        confirmation = true;
    }
    
    public void stopConfirmation() {
        confirmation = false;
    }
    
    public void showFailure() {
        failure = true;
    }
    
    public void stopFailure() {
        failure = false;
    }
    
    // Gets the most recent version of current party and its members
    public void updateCurrentParty() {
        currentParty = [SELECT Name, Party_Size__c, Max_Party_Size__c, Accepting_New_Members__c, Minimum_Level_Required__c, Class_Requirements__c, (SELECT Guild_Member__c FROM Member_Assignments__r) FROM Party__c WHERE id = :partyid];
        Set<string> ids = new Set<string>();
        for (Member_Assignment__c ma : currentParty.Member_Assignments__r) {
            ids.add(ma.Guild_Member__c);
        }
        currentPartyMembers = [SELECT Name, Class__c, Race__c, Active__c FROM Guild_Member__c WHERE id IN :ids];
    }
    
    // For switching to the PartyPage
    public PageReference partyPage() {
        updateCurrentParty();
        return Page.PartyPage;
    }
    
    // For switching to the User Page
    // Not tested.
    /*
    public PageReference userPage() {
        return Page.UserPage;
    }
	*/
    
    /*
     * If the current user has an associated guild member record,
     * add that guild member to the current party.
     */
    public void joinParty() {
        string userid = UserInfo.getUserId();
        List<Guild_Member__c> gm = [SELECT Name, Class__c, Race__c, Active__c FROM Guild_Member__c WHERE User__c = :userid LIMIT 1];
        if (gm.isEmpty()) {
            return;
        }
        Member_Assignment__c ma = new Member_Assignment__c();
        ma.Guild_Member__c = gm[0].id;
        ma.Party__c = currentParty.id;
        try {
            insert ma;
            updateCurrentParty();
        }
        catch (DMLException e) {
            ApexPages.addMessage(new ApexPages.message(ApexPages.SEVERITY.FATAL, e.getMessage()));
        }
    }

}