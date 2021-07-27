public class QuestPageController {
    public List<Quest__c> quests { get; set; }
    
    public QuestPageController() {
        quests = [SELECT 
                  Name, Danger_Level__c, Date_Opened__C, Duration__c, Location__c,  Quest_Details__c, Requires_Party__c, Status__c
                  FROM Quest__c];
    }
}