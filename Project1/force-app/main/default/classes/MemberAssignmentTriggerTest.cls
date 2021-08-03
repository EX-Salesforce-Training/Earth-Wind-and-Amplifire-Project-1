@isTest
public class MemberAssignmentTriggerTest {
    
    private static void singleNoClassSetup() {
        Party__c party = new Party__c();
        party.Name = 'adventurers';
        party.Accepting_New_Members__c = true;
        party.Max_Party_Size__c = 2;
        insert party;
        Guild_Member__c member = new Guild_Member__c();
        member.Name = 'Bob';
        member.Member_Email__c = 'bob@bob.bob';
        insert member;
    }
    
    private static void singleClassSetup() {
        Party__c party = new Party__c();
        party.Name = 'Drarluid';
        party.Accepting_New_Members__c = true;
        party.Max_Party_Size__c = 2;
        party.Class_Requirements__c = 'Druid;Warlock';
        insert party;
        Guild_Member__c member = new Guild_Member__c();
        member.Name = 'Tom';
        member.Member_Email__c = 'bob@bob.bob';
        member.Class__c = 'Druid';
        insert member;
    }
	
    @isTest
    public static void singleTest() {
        singleNoClassSetup();
        Party__c party = [SELECT id FROM Party__c LIMIT 1];
        Guild_Member__c member = [SELECT id FROM Guild_Member__c LIMIT 1];
        Member_Assignment__c ma = new Member_Assignment__c();
        ma.Guild_Member__c = member.id;
        ma.Party__c = party.id;
        insert ma;
        Member_Assignment__c newma = [SELECT Party__c, Guild_Member__c FROM Member_Assignment__c LIMIT 1];
        system.assertEquals(member.id, newma.guild_member__c);
        system.assertEquals(party.id, newma.party__c);
    }
    
    @isTest static void classTest() {
        singleClassSetup();
        Party__c party = [SELECT id FROM Party__c WHERE Name = 'Drarluid' LIMIT 1];
        Guild_Member__c member = [SELECT id FROM Guild_Member__c WHERE Name = 'Tom' LIMIT 1];
        Member_Assignment__c ma = new Member_Assignment__c();
        ma.Guild_Member__c = member.id;
        ma.Party__c = party.id;
        insert ma;
        Member_Assignment__c newma = [SELECT Party__c, Guild_Member__c FROM Member_Assignment__c LIMIT 1];
        system.assertEquals(member.id, newma.guild_member__c);
        system.assertEquals(party.id, newma.party__c);
    }
    
}