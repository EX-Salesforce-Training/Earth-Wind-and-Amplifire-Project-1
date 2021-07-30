public class PartyListPageController {
    
    private integer numRecords;
    private integer pageSize;
    private integer offset;
    public integer pageNumber {get{return offset/pageSize + 1;}}
    private string orderBy;
    private boolean ascending;
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
    
    
    
    
    public string partyid {get;set;}
    public Party__c currentParty {get;set;}
    public List<Guild_Member__c> currentPartyMembers{get;set;}
    public Party__c newParty {get;set;}
    
    public PartyListPageController() {
        setNumRecords();
        pageSize = 5;
        offset = 0;
		newParty = new Party__c();
        orderBy = 'Name';
        ascending = true;
    }
    
    public List<Party__c> getParties() {
        string query = 'SELECT Name, Party_Size__c, Max_Party_Size__c, Accepting_New_Members__c, Minimum_Level_Required__c, Class_Requirements__c ' +
            'FROM Party__c ';
        if (filterByName != null || filterByAcceptingNewMembers != null || (filterByPartySize != null && filterByPartySizeComparisonOp != null) || (filterByMaxPartySize != null && filterByMaxPartySizeComparisonOp != null) || (filterByMinimumLevelRequired != null && filterByMinLvlReqComparisonOp != null) || (filterByClassRequirements != null && !filterByClassRequirements.isEmpty())) {
            query += 'WHERE ';
        }
        boolean whereAnd = false;
        if (filterByName != null) {
            query += 'Name LIKE \'%' +filterByName + '%\' ';
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
        system.debug(query);
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
    
    public void next() {
        offset += pageSize;
    }
    
    public void prev() {
        offset -= pageSize;
    }
    
    public void first() {
        offset = 0;
    }
    
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
    
    public List<SelectOption> getClassList() {
        List<SelectOption> classes = new List<SelectOption>();
        classes.add(new SelectOption('Artificer', 'Artificer'));
        classes.add(new SelectOption('Barbarian', 'Barbarian'));
        classes.add(new SelectOption('Bard', 'Bard'));
        classes.add(new SelectOption('Cleric', 'Cleric'));
        classes.add(new SelectOption('Druid', 'Druid'));
        classes.add(new SelectOption('Fighter', 'Fighter'));
        classes.add(new SelectOption('Monk', 'Monk'));
        classes.add(new SelectOption('Paladin', 'Paladin'));
        classes.add(new SelectOption('Ranger', 'Ranger'));
        classes.add(new SelectOption('Rogue', 'Rogue'));
        classes.add(new SelectOption('Sorcerer', 'Sorcerer'));
        classes.add(new SelectOption('Warlock', 'Warlock'));
        classes.add(new SelectOption('Wizard', 'Wizard'));
        return classes;
    }
    
    public PageReference partyPage() {
        currentParty = [SELECT Name, Party_Size__c, Max_Party_Size__c, Accepting_New_Members__c, Minimum_Level_Required__c, Class_Requirements__c, (SELECT Guild_Member__c FROM Member_Assignments__r) FROM Party__c WHERE id = :partyid];
        Set<string> ids = new Set<string>();
        for (Member_Assignment__c ma : currentParty.Member_Assignments__r) {
            ids.add(ma.Guild_Member__c);
        }
        currentPartyMembers = [SELECT Name FROM Guild_Member__c WHERE id IN :ids];
        return Page.PartyPage;
    }
    
    public void createParty() {
        try {
            insert newParty;
        }
        catch (DMLException e) {
            
        }
        finally {
            newParty = new Party__c();
        }
        
    }

}