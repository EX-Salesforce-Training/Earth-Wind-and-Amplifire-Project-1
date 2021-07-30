// 92% test coverage for GuildExtension
@isTest
public class GuildExtensionTest {
    
    // guild hall negative test
    @isTest 
    static void testGuildHallNoLocation(){    
        Guild_Hall__c gh = new Guild_Hall__c(Name = 'Test Guild Hall');   
        Database.SaveResult sr = database.insert(gh, false);   
        
        List<Guild_Hall__c> guilds = [SELECT Id, name FROM Guild_Hall__c];
        
        PageReference testPage = Page.GuildHallListPage; 
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(gh.Id));
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(guilds);
        GuildExtension ext = new GuildExtension(ssc);         
        
        System.debug(ext.getGuildList()); 
        List<Guild_Hall__c> al = [Select Name from Guild_Hall__c where Name LIKE '%Test%' LIMIT 1];
        System.assert(!sr.isSuccess());
    } 
    // guild hall one
    @isTest 
    static void testGuildHallInsertOne(){    
        Guild_Hall__c gh = new Guild_Hall__c(Name = 'Test Guild Hall', Location__c = 'Realm');   
        database.insert(gh, true);   
        
        List<Guild_Hall__c> guilds = [SELECT Id, name FROM Guild_Hall__c];
        
        PageReference testPage = Page.GuildHallListPage; 
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(gh.Id));
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(guilds);
        GuildExtension ext = new GuildExtension(ssc);         
        
        System.debug(ext.getGuildList()); 
        List<Guild_Hall__c> al = [Select Name from Guild_Hall__c where Name LIKE '%Test%' LIMIT 1];
        System.assertEquals(1, al.size());
    } 
    // guild hall bulk
    @isTest 
    static void testGuildHallInsertBulk(){    
        Guild_Hall__c gh = new Guild_Hall__c(Name = 'Test Guild Hall', Location__c = 'Realm');  
        Guild_Hall__c gh2 = new Guild_Hall__c(Name = 'Test Guild Hall2', Location__c = 'Realm2');  
        database.insert(gh, true);
        database.insert(gh2, true);
        
        List<Guild_Hall__c> guilds = [SELECT Id, name FROM Guild_Hall__c];
        
        PageReference testPage = Page.GuildHallListPage; 
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(gh.Id));
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(guilds);
        GuildExtension ext = new GuildExtension(ssc);         
        
        System.debug(ext.getGuildList()); 
        List<Guild_Hall__c> al = [Select Name from Guild_Hall__c where Name LIKE '%Test%' LIMIT 2];
        System.assertEquals(2, al.size());
    } 
    
    
    
    
    // facility negative test
        @isTest 
    	static void testFacilitiesNoLocation(){    
        Facility__c f = new Facility__c(Name = 'Test Guild Hall');   
        Database.SaveResult sr = database.insert(f, false);   
        
        List<Facility__c> facs = [SELECT Id, name FROM Facility__c];
        
        PageReference testPage = Page.GuildHallPage; 
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(f.Id));
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(facs);
        GuildExtension ext = new GuildExtension(ssc);         
        
        System.debug(ext.getFacilities()); 
        List<Facility__c> al = [Select Name from Facility__c where Name LIKE '%Test%' LIMIT 1];
        System.assert(!sr.isSuccess());
    } 
    // facility insert one test
    @isTest 
    static void testFacilityInsertOne(){  
        Guild_Hall__c testHall = new Guild_Hall__c(Name = 'Test Guild Hall', Location__c = 'testRealm');
        database.insert(testHall, true);
        
        Facility__c f = new Facility__c(Name = 'Test Facility',Guild_Hall__c=testHall.Id, Supported_Skills__c='Cartography');   
        database.insert(f, true);   
        
        List<Facility__c> facilities = [SELECT Id, name FROM Facility__c];
        
        PageReference testPage = Page.GuildHallPage; 
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(f.Id));
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(facilities);
        GuildExtension ext = new GuildExtension(ssc);         
        
        System.debug(ext.getFacilities()); 
        List<Facility__c> al = [Select Name from Facility__c where Name LIKE '%Test%' LIMIT 1];
        System.assertEquals(1, al.size());
    } 
    // facility insert bulk test
    @isTest 
    static void testFacilitiesInsertBulk(){ 
        Guild_Hall__c testHall = new Guild_Hall__c(Name = 'Test Guild Hall', Location__c = 'testRealm');
        database.insert(testHall, true);
        Facility__c f = new Facility__c(Name = 'Test Guild Hall', Guild_Hall__c=testHall.Id, Supported_Skills__c='Sleight of Hand');  
        Facility__c f2 = new Facility__c(Name = 'Test Guild Hall2', Guild_Hall__c=testHall.Id, Supported_Skills__c='Cartography');  
        database.insert(f, true);
        database.insert(f2, true);
        
        List<Facility__c> guilds = [SELECT Id, name FROM Facility__c];
        
        PageReference testPage = Page.GuildHallPage; 
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(f.Id));
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(guilds);
        GuildExtension ext = new GuildExtension(ssc);         
        
        System.debug(ext.getFacilities()); 
        List<Facility__c> al = [Select Name from Facility__c where Name LIKE '%Test%' LIMIT 2];
        System.assertEquals(2, al.size());
    } 
    
    
    
    
    // quest insert one test
    @isTest 
    static void testQuestInsertOne(){   
        
        Contact c = new Contact(FirstName = 'test', LastName = 'LastTest');
        database.insert(c,true);
        
        date testDate = date.newInstance(2021, 05, 12);
        Quest__c q = new Quest__c(Name = 'Test Quest', Quest_Details__c = 'Go kill something now fool', Date_Opened__c=testDate, Location__c='Realm', Quest_City__c='Place',
                                 Danger_Level__c='Hard', Quest_Country__c='HerePlace', Quest_Postal_Code__c='46218', Quest_State__c='state', Quest_Street__c='123 herestreet',
                                 Required_Professions__c='Adventurer', Reward__c=100, Status__c='New', Sub_Status__c='Pending',Contact__c=c.id);   
        database.insert(q, true);   
        
        
        List<Quest__c> quests = [SELECT Id, name FROM Quest__c];
        
        PageReference testPage = Page.GuildHallPage; 
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(q.Id));
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(quests);
        GuildExtension ext = new GuildExtension(ssc);         
        
        System.debug(ext.getQuest()); 
        List<Quest__c> al = [Select Name from Quest__c where Name LIKE '%Test%' LIMIT 1];
        System.assertEquals(1, al.size());
    } 
    // quest insert bulk test
    @isTest 
    static void testQuestInsertBulk(){   
        
        Contact c = new Contact(FirstName = 'test', LastName = 'LastTest');
        database.insert(c,true);
        
        date testDate = date.newInstance(2021, 05, 12);
        Quest__c q = new Quest__c(Name = 'Test Quest', Quest_Details__c = 'Go kill something now fool', Date_Opened__c=testDate, Location__c='Realm', Quest_City__c='Place',
                                 Danger_Level__c='Hard', Quest_Country__c='HerePlace', Quest_Postal_Code__c='46218', Quest_State__c='state', Quest_Street__c='123 herestreet',
                                 Required_Professions__c='Adventurer', Reward__c=100, Status__c='New', Sub_Status__c='Pending',Contact__c=c.id);   
         Quest__c q2 = new Quest__c(Name = 'Test2 Quest', Quest_Details__c = 'Go2 kill something now fool', Date_Opened__c=testDate, Location__c='Realm2', Quest_City__c='Place2',
                                 Danger_Level__c='Hard', Quest_Country__c='HerePl2ace', Quest_Postal_Code__c='45218', Quest_State__c='stat2e', Quest_Street__c='123 herestree2t',
                                 Required_Professions__c='Adventurer', Reward__c=1020, Status__c='New', Sub_Status__c='Pending',Contact__c=c.id); 
        database.insert(q, true);
        database.insert(q2, true);
        
        
        List<Quest__c> quests = [SELECT Id, name FROM Quest__c];
        
        PageReference testPage = Page.GuildHallPage; 
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(q.Id));
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(quests);
        GuildExtension ext = new GuildExtension(ssc);         
        
        System.debug(ext.getQuest()); 
        List<Quest__c> al = [Select Name from Quest__c where Name LIKE '%Test%' LIMIT 2];
        System.assertEquals(2, al.size());
    }
    // quest negative test
    @isTest 
    static void testQuestNoRequired(){    
        Quest__c q = new Quest__c(Name = 'Test Guild Hall');   
        Database.SaveResult sr = database.insert(q, false);   
        
        List<Quest__c> quests = [SELECT Id, name FROM Quest__c];
        
        PageReference testPage = Page.GuildHallPage; 
        Test.setCurrentPage(testPage);
        ApexPages.currentPage().getParameters().put('Id', String.valueOf(q.Id));
        
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(quests);
        GuildExtension ext = new GuildExtension(ssc);         
        
        System.debug(ext.getQuest()); 
        List<Quest__c> al = [Select Name from Quest__c where Name LIKE '%Test%' LIMIT 1];
        System.assert(!sr.isSuccess());
    } 
}