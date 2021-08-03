@isTest
public class UserPageTest {
	@testSetup
    public static void setup(){
        Guild_Hall__c th = new Guild_Hall__c();
        th.Name = 'Test Hall';
        th.Location__c = 'The city of Testville';
        
        Guild_Hall__c th2 = new Guild_Hall__c();
        th2.Name = 'Test Hall 2';
        th2.Location__c = 'The city of Testville 2';
        
        insert th;
        insert th2;
        
        Guild_Hall__c gh = [SELECT ID
                           FROM Guild_Hall__c
                           WHERE Guild_Hall__c.ID =: th.Id];
               
        Guild_Member__c tm = new Guild_Member__c();
        tm.Name = 'testy';
        tm.Member_Email__c = 'testy@test.com';
        tm.Guild_Hall__c = gh.Id;
        tm.Artificer_Level__c = 1;
        tm.User__c = userInfo.getUserId();
        
        insert tm;
        
        Guild_Member__c gm = [SELECT ID 
                              FROM Guild_Member__c
                              WHERE Guild_Member__c.ID =: tm.ID];
        
        Party__c tp = new Party__c();
        tp.Name = 'TestParty';
        
        insert tp;
        
        Party__c party = [SELECT ID
                          FROM Party__c
                          WHERE ID =: tp.ID];
        
        item__c ti = new Item__c();
        ti.name = 'TestItem';
        ti.Guild_Member__c = gm.ID;
        
        insert ti;
        
        Member_Assignment__c ma = new Member_Assignment__c();
		ma.Guild_Member__c = gm.Id;
        ma.Party__c = party.Id;
        
        insert ma;
    }
    
    @isTest
    public static void levelUpTest(){
        Guild_Member__c gm = [SELECT ID, Artificer_Level__c, Bard_Level__c 
                              FROM Guild_Member__c 
                              WHERE Guild_Member__c.Member_Email__c = 'testy@test.com'];
        gm.Artificer_Level__c = 2;
        gm.Bard_Level__c =1 ;
        update gm;
        
        Guild_Member__c lvl = [SELECT ID, Total_Level__c 
                               FROM Guild_Member__c 
                               WHERE Guild_Member__c.ID =: gm.Id];
        
        system.assertEquals(3, lvl.Total_Level__c);
    }
    
    @isTest
    public static void levelFailureTest(){
        Guild_Member__c gm = [SELECT ID, Artificer_Level__c, Total_Level__c 
                              FROM Guild_Member__c 
                              WHERE Guild_Member__c.Member_Email__c = 'testy@test.com'];
        gm.Artificer_Level__c = -1;
        
        Database.SaveResult sr = Database.update(gm, false);
       	System.assert(!sr.isSuccess());
        
        gm.Artificer_Level__c = 0;
        
        Database.SaveResult sr2 = Database.update(gm, false);
       	System.assert(!sr2.isSuccess());
    }
    
    @isTest
    public static void guildHallChangeTest(){
        Guild_Member__c gm = [SELECT ID, Guild_Hall__c
                             FROM Guild_Member__c
                             WHERE Guild_Member__c.Member_Email__c = 'testy@test.com'];
        
        Guild_Hall__c gh2 = [SELECT ID, name
                           FROM Guild_Hall__c
                           WHERE Guild_Hall__c.Location__c =: 'The city of Testville 2'];
        
        gm.Guild_Hall__c = gh2.Id;
        update gm;
        
        Guild_Member__c hall = [SELECT ID, Guild_Hall__c
                               FROM Guild_Member__c
                               WHERE Guild_Member__c.ID =: gm.Id];
        
        system.assertEquals(gh2.id, hall.Guild_Hall__c);
    }
    
    @isTest
    public static void testUserPageController(){
        UserPageController uCon = new UserPageController();
        Guild_Member__c gm = [SELECT ID 
                              FROM Guild_Member__c 
                              WHERE Guild_Member__c.Member_Email__c = 'testy@test.com'];
        uCon.Member.id = gm.Id;
        system.assertEquals('testy' ,uCon.member.Name);
    }
    
    @isTest
    public static void testControllerSave(){
        UserPageController uCon = new UserPageController();
        Guild_Member__c gm = [SELECT ID 
                              FROM Guild_Member__c 
                              WHERE Guild_Member__c.Member_Email__c = 'testy@test.com'];
        uCon.Member.id = gm.Id;
        uCon.Member.Artificer_Level__c = 3;
        uCon.save();
        
        Guild_Member__c gm2 = [SELECT ID, Total_Level__c
                              FROM Guild_Member__c 
                              WHERE Guild_Member__c.Member_Email__c = 'testy@test.com'];
        
        system.assertEquals(3 ,gm2.Total_Level__c);
    }
    
    @isTest
    public static void testControllerSaveFailure(){
        UserPageController uCon = new UserPageController();
        Guild_Member__c gm = [SELECT ID 
                              FROM Guild_Member__c 
                              WHERE Guild_Member__c.Member_Email__c = 'testy@test.com'];
        uCon.Member.id = gm.Id;
        uCon.Member.Artificer_Level__c = -3;
        try{
            uCon.save();
            system.assert(False);
        }catch(DMLException e){
            system.assert(True);
        } 
    }
}