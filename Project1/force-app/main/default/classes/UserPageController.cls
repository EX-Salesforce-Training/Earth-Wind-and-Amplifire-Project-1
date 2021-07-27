public class UserPageController {
    public Guild_Member__c mem{get;set;}
    
    public UserPageController(){
        //WHERE Guild_Member__c.User__r.ID =: UserInfo.getUserId()
        mem = [SELECT Age__c, Class__c, Guild_Hall__c, Name, Level__c, Race__c, Skills__c, (SELECT Item__c.Name, Item__c.Item_Type__c FROM Items__r) FROM Guild_Member__c  LIMIT 1];
    }
}