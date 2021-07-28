public class UserPageController {
    public Guild_Member__c member{get;set;}
    public List<Item__c> items{get;set;}
    
    public UserPageController(){
        
        //maybe just make the class with sharing so we don't have to add that where clause
        member = [SELECT Age__c, Class__c, Guild_Hall__c, Name, Race__c, Skills__c, 
                  Artificer_Level__c, Barbarian_Level__c, Bard_Level__c, Cleric_Level__c, Druid_Level__c, Fighter_Level__c, Monk_Level__c, Paladin_Level__c, Ranger_Level__c, Rogue_Level__c, Sorcerer_Level__c, Warlock_Level__c, Wizard_Level__c, Total_Level__c,
                  (SELECT Item__c.Name, Item__c.Item_Type__c, Item__c.ID FROM Items__r) 
                  FROM Guild_Member__c
                  //WHERE Guild_Member__c.User__r.ID =: UserInfo.getUserId()
                  LIMIT 1];
        items = [SELECT ID, Name, Item_Type__c, Properties__c 
                FROM Item__c 
                WHERE ID IN: member.Items__r];
    }
    
    public void save(){
        update member;
    }
}