public class QuestExtension {
    
    public QuestExtension(ApexPages.StandardSetController ssc) {
        ssc.setPageSize(10);
    }
    
    public transient String questId {get; set;}
    
    // @desc: get the description of a quest
    public String getDescription() {
        if(questId == null) {
        	return 'Select a quest from the left to see its information here';
        }
        
        Quest__c q = [SELECT Quest_Details__c From Quest__c WHERE Id = :questId];
        return q.Quest_Details__c;
    }
    
    // @desc: get the title of a quest
    public String getTitle() {
        if(questId == null) {
            return 'Quest Panel';
        }
        
        Quest__c q = [SELECT Name From Quest__c WHERE Id = :questId];
        return q.Name;
    }
    
}