public class PartyListPageController {
    
    private integer numRecords = 0;
    private integer pageIndex = 0;
    public integer pageSize {get;set;}
    private integer offset = 0;
    public boolean filterByAccept {get;set;}
    public string partyid {get;set;}
    public Party__c currentParty {get;set;}
    public List<Guild_Member__c> currentPartyMembers{get;set;}
    public Party__c newParty {get;set;}
    
    public PartyListPageController() {
        numRecords = [SELECT count() FROM Party__c];
		newParty = new Party__c();
		pageSize = 5;        
    }
    
    public List<Party__c> getParties() {
        return [SELECT Name, Party_Size__c, Max_Party_Size__c, Accepting_New_Members__c, Minimum_Level_Required__c, Class_Requirements__c FROM Party__c ORDER BY Name LIMIT :pageSize OFFSET :offset]; 
    }
    
    public void next() {
        pageIndex++;
        offset = pageSize * pageIndex;
    }
    
    public void prev() {
        pageIndex--;
        offset = pageSize * pageIndex;
    }
    
    public void first() {
        pageIndex = 0;
        offset = pageSize * pageIndex;
    }
    
    public void last() {
        if (Math.mod(numRecords, pageSize) == 0) {
            pageIndex = numRecords / pageSize - 1;
            offset = pageSize * pageIndex;
        }
        else {
        	pageIndex = (numRecords - Math.mod(numRecords, pageSize)) / pageSize;
            offset = pageSize * pageIndex;
        }
    }
    
    public boolean getNxt() {
        return (pageIndex+1)*pageSize >= numRecords;
    }
    
    public boolean getPrv() {
        return pageIndex == 0;
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