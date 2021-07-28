// extension to query for the related objects
public with sharing class GuildExtension {
    public static integer PageSize{get;set;}
    ApexPages.StandardSetController setCon;
    public List<Guild_hall__c> theList{get; set;}
    public List<Quest__c> questBoard = new List<Quest__c>();
	public List<facility__c> facilityName = new List<Facility__c>();
    public List<Party__c> partyName = new List<Party__c>();
    
    // constructor
    public GuildExtension(ApexPages.StandardSetController controller){
        PageSize = 10;
        setCon = controller;
        theList = [SELECT Id, Name, (SELECT id, Name FROM Quests__r ), (SELECT Id, Name FROM Facilities__r) FROM Guild_Hall__c];
        setCon.setSelected(theList);
        setCon.setPageSize(PageSize);
    }
    
    // get method for facility
    public List<Facility__c> getFacilities(){
        facilityName = [SELECT Id, Name FROM Facility__c LIMIT 10];
        return facilityName;
    }
    
    // get method for quests
     public List<Quest__c> getQuest(){
        questBoard = [SELECT Id, Name, Danger_Level__c, Date_Opened__c, Location__c, Quest_City__c, Quest_Country__c,Quest_Postal_Code__c, Quest_State__c,Quest_Street__c,
                     Required_Professions__c, Reward__c, Status__c, Requires_Party__c, Quest_Details__c FROM Quest__c LIMIT 10];
         return questBoard;
        }
    
    	// get method for parties
       public List<Party__c> getParty(){
        partyName = [SELECT Id, Name FROM Party__c LIMIT 10];
           return partyName;
        }
}