/* Name: Guild Member Page Controller
 * Author: Blake Prescott
 * Description: This is the page controller for the Guild Member Page/User Page
 * User Page is a misnomer
 */
public with sharing class UserPageController {
    public Guild_Member__c member{get;set;}
    public List<Item__c> items{get;set;}
    public List<Quest__c> quests{get;set;}
    public Member_Assignment__c party{get;set;}
    
    public UserPageController(){
        //if the user navigates to this page from another visualforce page it will get the guild member's id from that page
        //if they don't it will grab the guild member related to the user.
        if(ApexPages.currentPage().getParameters().get('id') != null){
            member = [SELECT Age__c, Class__c, Guild_Hall__c, Name, Race__c, Skills__c, Date_Hired__c,
                      Artificer_Level__c, Barbarian_Level__c, Bard_Level__c, Cleric_Level__c, Druid_Level__c, 
                      Fighter_Level__c, Monk_Level__c, Paladin_Level__c, Ranger_Level__c, Rogue_Level__c, 
                      Sorcerer_Level__c, Warlock_Level__c, Wizard_Level__c, Total_Level__c,
                      (SELECT Item__c.ID FROM Items__r),
                      (SELECT Quest__c.ID FROM Quests__r),
                      (SELECT Member_Assignment__c.ID FROM Member_Assignments__r)
                      FROM Guild_Member__c
                      WHERE Guild_Member__c.ID =: ApexPages.currentPage().getParameters().get('id')
                      LIMIT 1];
        }else{
            member = [SELECT Age__c, Class__c, Guild_Hall__c, Name, Race__c, Skills__c, Date_Hired__c,
                      Artificer_Level__c, Barbarian_Level__c, Bard_Level__c, Cleric_Level__c, Druid_Level__c, 
                      Fighter_Level__c, Monk_Level__c, Paladin_Level__c, Ranger_Level__c, Rogue_Level__c, 
                      Sorcerer_Level__c, Warlock_Level__c, Wizard_Level__c, Total_Level__c,
                      (SELECT Item__c.ID FROM Items__r),
                      (SELECT Quest__c.ID FROM Quests__r),
                      (SELECT Member_Assignment__c.ID FROM Member_Assignments__r)
                      FROM Guild_Member__c
                      WHERE Guild_Member__c.User__r.ID =: UserInfo.getUserId()
                      LIMIT 1];
        }
        
        //Query for the member's items
        items = [SELECT ID, Name, Item_Type__c, Properties__c, Value__c 
                FROM Item__c 
                WHERE ID IN: member.Items__r];
        
        //Query for the member's quests
        quests = [SELECT ID, Name 
                FROM Quest__c 
                WHERE ID IN: member.Quests__r];
        
        //if they have an assignment to a party, it will query for that party's name.
        try{
        	party = [SELECT ID, Party__r.Name
                	FROM Member_Assignment__c
                	WHERE ID IN: member.Member_Assignments__r
                	LIMIT 1];
        }catch(QueryException e){
            party = null;
        }
    }
    
    //updates the record in the database
    public void save(){
        update member;
    }
    

}