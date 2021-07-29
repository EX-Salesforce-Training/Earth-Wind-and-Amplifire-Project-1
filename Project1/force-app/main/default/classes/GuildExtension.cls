// extension to query for the related objects
public with sharing class GuildExtension {
    public static integer PageSize{get;set;}
    ApexPages.StandardSetController setCon;
    public List<Quest__c> questBoard = new List<Quest__c>();
    public List<facility__c> facilityName = new List<Facility__c>();
    public List<Party__c> partyName = new List<Party__c>();
    public String currentRecordId {get;set;}
    public String pageBlockTitle {get;set;}
    public List<Guild_Hall__c> title = new List<Guild_Hall__c>();
    
    // constructor
    public GuildExtension(ApexPages.StandardSetController controller){
        PageSize = 10;
        setCon = controller;
        setCon.setPageSize(PageSize);
        currentRecordId  = ApexPages.CurrentPage().getparameters().get('id');
        title = [SELECT Id, Name FROM Guild_Hall__c where id =:currentRecordID];
        if(title.isEmpty()){
            pageBlockTitle = 'None';
        } else {
            pageBlockTitle = title[0].name;
        }
    }
    	

    
    // get method for facility
    public List<Facility__c> getFacilities(){
        facilityName = [SELECT ID, Name, Guild_Hall__c FROM Facility__c where Guild_Hall__c = :title];
        return facilityName;
    }
    
    // get method for guild list
    public List<Guild_Hall__c> getGuildList(){
        return [SELECT Id, Name FROM Guild_Hall__c];
    }
    
    
   
    // get method for quests
    public List<Quest__c> getQuest(){
        questBoard = [SELECT Id, Name, Danger_Level__c, Date_Opened__c, Location__c, 
                      Required_Professions__c, Reward__c, Status__c, Requires_Party__c, Quest_Details__c, Guild_Hall__c, Party__c FROM Quest__c where Guild_Hall__c = :title];
        return questBoard;
    }
    
    // get method for parties
   
}