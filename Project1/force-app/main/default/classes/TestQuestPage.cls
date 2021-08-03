@isTest
public class TestQuestPage {
	@testSetup
    public static void setup() {
        Contact con = new Contact();
        con.LastName = 'Flay';
        con.Email = 'dummy@contact.com';
        insert con;
        
        Guild_Member__c guildMem = new Guild_Member__c();
        guildMem.Name = 'Steve';
        guildMem.Member_Email__c = 'dummy@guildMember.com';
        guildMem.Artificer_Level__c = 1;
        insert guildMem;
    }
    
    // positive single test
    @isTest
    public static void testSingleCreateQuest01() {
        Contact con = [SELECT LastName, Email FROM Contact WHERE Email = 'dummy@contact.com'];
        Quest__c q = new Quest__c();
        q.Contact__c = con.Id;
        
        q.Name = 'Kill the Chicken!';
        q.Danger_Level__c = 'Easy';
        q.Location__c = 'Runescape';
        q.Requires_Party__c = true;
        q.Quest_Details__c = 'There\'s a chicken ravaging Edgeville!';
        q.Reward__c = 800;
        q.Required_Professions__c = 'Adventurer;Craftsman';
        
        // standard stuff
        q.Status__c = 'New';
        q.Sub_Status__c = 'Pending';
        q.Date_Opened__c = Date.today();
        
        // deprecated, but needed for now
        q.Quest_Country__c = 'USA';
        q.Quest_City__c = 'Baltimore';
        q.Quest_Postal_Code__c = '20740';
        q.Quest_Street__c = '123 main ave';
        q.Quest_State__c = 'Maryland';
        
        Database.SaveResult sr = Database.insert(q, false);
       	System.assert(sr.isSuccess());
    }
    
    // negative single test
    @isTest
    public static void testSingleCreateQuest02() {
        Quest__c q = new Quest__c();
        q.Contact__c = null;
        
        q.Name = 'Kill the Chicken!';
        q.Danger_Level__c = 'Easy';
        q.Location__c = 'Runescape';
        q.Requires_Party__c = true;
        q.Quest_Details__c = 'There\'s a chicken ravaging Edgeville!';
        q.Reward__c = 800;
        q.Required_Professions__c = 'Adventurer;Craftsman';
        
        
        
        // standard stuff
        q.Status__c = 'New';
        q.Sub_Status__c = 'Pending';
        q.Date_Opened__c = Date.today();
        
        // deprecated, but needed for now
        q.Quest_Country__c = 'USA';
        q.Quest_City__c = 'Baltimore';
        q.Quest_Postal_Code__c = '20740';
        q.Quest_Street__c = '123 main ave';
        q.Quest_State__c = 'Maryland';
        
        Database.SaveResult sr = Database.insert(q, false);
       	System.assert(!sr.isSuccess());
    }
    
    // positive bulk test
    @isTest
    public static void testMassCreateQuest01() {
        List<Quest__c> questList = new List<Quest__c>();
        Contact con = [SELECT LastName, Email FROM Contact WHERE Email = 'dummy@contact.com'];
        for(Integer i = 0; i < 50; i++) {
            Quest__c q = new Quest__c();
            q.Contact__c = con.Id;
            
            q.Name = 'Kill the Chicken!';
            q.Danger_Level__c = 'Easy';
            q.Location__c = 'Runescape';
            q.Requires_Party__c = true;
            q.Quest_Details__c = 'There\'s a chicken ravaging Edgeville!';
            q.Reward__c = 800;
            q.Required_Professions__c = 'Adventurer;Craftsman';
        
        
        
            // standard stuff
            q.Status__c = 'New';
            q.Sub_Status__c = 'Pending';
            q.Date_Opened__c = Date.today();
            
            // deprecated, but needed for now
            q.Quest_Country__c = 'USA';
            q.Quest_City__c = 'Baltimore';
            q.Quest_Postal_Code__c = '20740';
            q.Quest_Street__c = '123 main ave';
            q.Quest_State__c = 'Maryland';
            
            questList.add(q);
        }
        List<Database.SaveResult> srList = Database.insert(questList, false);
        for(Database.SaveResult sr: srList) {
        	System.assert(sr.isSuccess());
        }
    }
    
    // negative bulk test
    @isTest
    public static void testMassCreateQuest02() {
        List<Quest__c> questList = new List<Quest__c>();

        for(Integer i = 0; i < 50; i++) {
            Quest__c q = new Quest__c();
            
            // most likely mistake -- an email with no contact
            q.Contact__c = null;
            
            q.Name = 'Kill the Chicken!';
            q.Danger_Level__c = 'Easy';
            q.Location__c = 'Runescape';
            q.Requires_Party__c = true;
            q.Quest_Details__c = 'There\'s a chicken ravaging Edgeville!';
            q.Reward__c = 800;
            q.Required_Professions__c = 'Adventurer;Craftsman';
        
        
        
            // standard stuff
            q.Status__c = 'New';
            q.Sub_Status__c = 'Pending';
            q.Date_Opened__c = Date.today();
            
            // deprecated, but needed for now
            q.Quest_Country__c = 'USA';
            q.Quest_City__c = 'Baltimore';
            q.Quest_Postal_Code__c = '20740';
            q.Quest_Street__c = '123 main ave';
            q.Quest_State__c = 'Maryland';
            
            questList.add(q);
        }
        List<Database.SaveResult> srList = Database.insert(questList, false);
        for(Database.SaveResult sr: srList) {
        	System.assert(!sr.isSuccess());
        }
    }
    
    // save quest positive single test
    @isTest
    public static void testQuestExt01() {
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Quest__c>());
        QuestExtension ext = new QuestExtension(ssc);
        
        final String dummyContactEmail = 'dummy@contact.com';
        
        ext.formData.questName = 'Kill the Chicken!';
        ext.formData.questDetails = 'There\'s a chicken ravaging Edgeville!';
        ext.formData.location = 'Runescape';
        ext.formData.requiresParty = false;
        ext.formData.dangerLevel = 'Easy';
        ext.formData.requiredProfessionAdventurer = false;
        ext.formData.requiredProfessionCraftsman = true;
        ext.formData.reward = 500;
        ext.formData.email = dummyContactEmail;
        
            
        System.assertNotEqualS(ext.saveQuest(), null);
    }
    
    // save quest negative single test
    @isTest
    public static void testQuestExt02() {
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Quest__c>());
        QuestExtension ext = new QuestExtension(ssc);
        
        final String dummyEmail = 'dummy1@contact.com';
        
        ext.formData.questName = 'Kill the Chicken!';
        ext.formData.questDetails = 'There\'s a chicken ravaging Edgeville!';
        ext.formData.location = 'Runescape';
        ext.formData.requiresParty = true;
        ext.formData.dangerLevel = 'Easy';
        ext.formData.requiredProfessionAdventurer = true;
        ext.formData.requiredProfessionCraftsman = false;
        ext.formData.reward = 500;
        ext.formData.email = dummyEmail;
        
            
        System.assertNotEqualS(ext.saveQuest(), Page.QuestPageSuccessfulSubmission);
    }
    
    // save quest positive bulk test
    @isTest
    public static void testQuestExt03() {
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Quest__c>());
        QuestExtension ext = new QuestExtension(ssc);
        
        for(Integer i = 0; i < 50; i++) {
            final String dummyEmail = 'dummy@contact.com';
            
            ext.formData.questName = 'Kill the Chicken!';
            ext.formData.questDetails = 'There\'s a chicken ravaging Edgeville!';
            ext.formData.location = 'Runescape';
            ext.formData.requiresParty = false;
            ext.formData.dangerLevel = 'Easy';
            ext.formData.requiredProfessionAdventurer = false;
            ext.formData.requiredProfessionCraftsman = true;
            ext.formData.reward = 500;
            ext.formData.email = dummyEmail;
            
                
            System.assertNotEqualS(ext.saveQuest(), null);
        }
    }
    
    // save quest negative bulk test
    @isTest
    public static void testQuestExt04() {
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Quest__c>());
        QuestExtension ext = new QuestExtension(ssc);
        
        for(Integer i = 0; i < 50; i++) {
            final String dummyEmail = 'dummy1@contact.com';
            
            ext.formData.questName = 'Kill the Chicken!';
            ext.formData.questDetails = 'There\'s a chicken ravaging Edgeville!';
            ext.formData.location = 'Runescape';
            ext.formData.requiresParty = true;
            ext.formData.dangerLevel = 'Easy';
            ext.formData.requiredProfessionAdventurer = true;
            ext.formData.requiredProfessionCraftsman = false;
            ext.formData.reward = 500;
            ext.formData.email = dummyEmail;
            
                
            System.assertNotEqualS(ext.saveQuest(), Page.QuestPageSuccessfulSubmission);
        }
    }
    
    // test extension basic getters
    @isTest
    public static void testQuestExt05() {
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Quest__c>());
        QuestExtension ext = new QuestExtension(ssc);
        
        // ensure it succeeds when it should
        System.assertEquals(ext.getDescription(), 'Select a quest from the left to see its information here');
        System.assertEquals(ext.getTitle(), 'Quest Panel');
        ext.questId = '1';
        
        // ensure it succeeds when id is invalid
        System.assertEquals(ext.getDescription(), 'Select a quest from the left to see its information here');
        System.assertEquals(ext.getTitle(), 'Quest Panel');
        
        // ensure it succeeds when it should
        final String dummyEmail = 'dummy@contact.com';
        
        ext.formData.questName = 'Kill the Chicken!';
        ext.formData.questDetails = 'There is a chicken ravaging Edgeville!';
        ext.formData.location = 'Runescape';
        ext.formData.requiresParty = true;
        ext.formData.dangerLevel = 'Easy';
        ext.formData.requiredProfessionAdventurer = true;
        ext.formData.requiredProfessionCraftsman = false;
        ext.formData.reward = 500;
        ext.formData.email = dummyEmail;
        
        ext.saveQuest();
        
        Quest__c q = [SELECT Id FROM Quest__c WHERE Contact__r.Email = :dummyEmail];
        ext.questId = q.id;
        System.assertEquals(ext.getDescription(), 'There is a chicken ravaging Edgeville!');
        System.assertEquals(ext.getTitle(), 'Kill the Chicken!');
    }
    
    // test extension submit for approval single positive
    @isTest
    public static void testQuestExt06() {
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Quest__c>());
        QuestExtension ext = new QuestExtension(ssc);
        System.assertEquals(ext.submitForApproval(), null);
        
        final String dummyContactEmail = 'dummy@contact.com';
        final String dummyGuildMemberEmail = 'dummy@guildmember.com';
        final String questName = 'Kill the Chicken!';
        
        ext.formData.questName = questName;
        ext.formData.questDetails = 'There is a chicken ravaging Edgeville!';
        ext.formData.location = 'Runescape';
        ext.formData.requiresParty = true;
        ext.formData.dangerLevel = 'Easy';
        ext.formData.requiredProfessionAdventurer = true;
        ext.formData.requiredProfessionCraftsman = true;
        ext.formData.reward = 500;
        ext.formData.email = dummyContactEmail;
        
        System.assertNotEquals(ext.saveQuest(), null);
        Quest__c q = [SELECT Id FROM Quest__c WHERE Name = :questName];
        ext.assigneeEmail = dummyGuildMemberEmail;
        System.assertEquals(ext.submitForApproval(), null);
        
        ext.questId = q.Id;
        System.assertNotEquals(ext.submitForApproval(), null);
    }
    
    // test extension submit for approval single negative
    @isTest
    public static void testQuestExt07() {
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController(new List<Quest__c>());
        QuestExtension ext = new QuestExtension(ssc);
        System.assertEquals(ext.submitForApproval(), null);
        
        final String dummyContactEmail = 'dummy@contact.com';
        final String dummyGuildMemEmail = 'dummy1@guildMember.com';
        final String questName = 'Kill the Chicken!';
        
        ext.formData.questName = questName;
        ext.formData.questDetails = 'There is a chicken ravaging Edgeville!';
        ext.formData.location = 'Runescape';
        ext.formData.requiresParty = true;
        ext.formData.dangerLevel = 'Easy';
        ext.formData.requiredProfessionAdventurer = true;
        ext.formData.requiredProfessionCraftsman = true;
        ext.formData.reward = 500;
        ext.formData.email = dummyContactEmail;
        
        System.assertNotEquals(ext.saveQuest(), null);
        Quest__c q = [SELECT Id FROM Quest__c WHERE Name = :questName];
        
        // email that DNE
        ext.assigneeEmail = dummyGuildMemEmail;
        System.assertEquals(ext.submitForApproval(), null);
        
        ext.questId = q.Id;
        System.assertEquals(ext.submitForApproval(), null);
    }
    
    // test contact trigger handler negative test concurrent add
    @isTest
    public static void testContactTriggerHandler01() {
        Contact c0 = new Contact(LastName = 'Bob', Email='bob@bob.com');
        Contact c1 = new Contact(LastName= 'bob', Email='bob@bob.com');
        List<Contact> conList = new List<Contact>{c0, c1};
        try {
            insert conList;
            System.assert(false);
        } catch(exception e) {
            System.assert(true);
        }
    }
    
    // test contact trigger handler positive test concurrent add
    @isTest
    public static void testContactTriggerHandler02() {
        Contact c0 = new Contact(LastName = 'Bob', Email='bob@bob.com');
        Contact c1 = new Contact(LastName= 'bob', Email='bob2@bob.com');
        List<Contact> conList = new List<Contact>{c0, c1};
        try {
            insert conList;
            System.assert(true);
        } catch(exception e) {
            System.assert(false);
        }
    }
    
    // test contact trigger handler negative test single add
    @isTest
    public static void testContactTriggerHandler03() {
        Contact c0 = new Contact(LastName = 'Bob', Email='bob@bob.com');
        Contact c1 = new Contact(LastName= 'bob', Email='bob@bob.com');
        
        try {
            insert c0;
        } catch(Exception e) {
            System.assert(false);
        }
        
        try {
            insert c1;
        } catch(Exception e) {
            System.assert(true);
        }
    }
    
    // test contact trigger handler positive test single add
    @isTest
    public static void testContactTriggerHandler04() {
        Contact c0 = new Contact(LastName = 'Bob', Email='bob@bob.com');
        Contact c1 = new Contact(LastName= 'bob', Email='bob2@bob.com');
        try {
            insert c0;
            insert c1;
            System.assert(true);
        } catch(Exception e) {
            System.assert(false);
        }
    }
}