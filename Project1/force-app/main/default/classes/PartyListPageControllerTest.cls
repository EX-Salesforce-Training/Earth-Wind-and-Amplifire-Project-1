@isTest
public class PartyListPageControllerTest {
    
    private static string partyid;
    
    private static void singleSetup() {
        Party__c testParty = new Party__c();
        testParty.Name = 'test';
        testParty.Accepting_New_Members__c = true;
        testParty.Max_Party_Size__c = 4;
        testParty.Minimum_Level_Required__c = 5;
        testParty.Class_Requirements__c = 'Cleric;Fighter';
        insert testParty;
        Guild_Member__c testMember = new Guild_Member__c();
        testMember.Name = 'bob';
        testMember.Member_Email__c = 'bob@bob.bob';
        testMember.class__c = 'Fighter';
        testMember.Artificer_Level__c = 1;
        insert testMember;
        testParty = [SELECT id FROM Party__c LIMIT 1];
        partyid = testParty.id;
        testMember = [SELECT id FROM Guild_Member__c LIMIT 1];
        Member_Assignment__c ma = new Member_Assignment__c();
        ma.Guild_Member__c = testMember.id;
        ma.Party__c = testParty.id;
        insert ma;
    }

    @isTest
    public static void testGetPartiesName() {
        singleSetup();
        PartyListPageController plpc = new PartyListPageController();
        plpc.filterByName = 'es';
        List<Party__c> parties = plpc.getParties();
        for (Party__c p : parties) {
            system.assertEquals(p.Name, 'test');
        }
    }
    
    @isTest
    public static void testGetPartiesNameNegative() {
        singleSetup();
        PartyListPageController plpc = new PartyListPageController();
        plpc.filterByName = 'bob';
        List<Party__c> parties = plpc.getParties();
        system.assert(parties.isEmpty());
    }
    
    @isTest
    public static void testGetPartiesAccept() {
        singleSetup();
        PartyListPageController plpc = new PartyListPageController();
        plpc.filterByAcceptingNewMembers = 'true';
        List<Party__c> parties = plpc.getParties();
        for (Party__c p : parties) {
            system.assertEquals(p.Name, 'test');
        }
    }
    
    @isTest
    public static void testGetPartiesAcceptNegative() {
        singleSetup();
        PartyListPageController plpc = new PartyListPageController();
        plpc.filterByAcceptingNewMembers = 'false';
        List<Party__c> parties = plpc.getParties();
        system.assert(parties.isEmpty());
    }
    
    @isTest
    public static void testGetPartiesSize() {
        singleSetup();
        PartyListPageController plpc = new PartyListPageController();
        plpc.filterByPartySize = 1;
        plpc.filterByPartySizeComparisonOp = '=';
        List<Party__c> parties = plpc.getParties();
        for (Party__c p : parties) {
            system.assertEquals(p.Name, 'test');
            system.assertEquals(1, p.Party_Size__c);
        }
    }
    
    @isTest
    public static void testGetPartiesSizeNegative() {
        singleSetup();
        PartyListPageController plpc = new PartyListPageController();
        plpc.filterByPartySize = 1;
        plpc.filterByPartySizeComparisonOp = '>';
        List<Party__c> parties = plpc.getParties();
        system.assert(parties.isEmpty());
    }
    
    @isTest
    public static void testGetPartiesMaxSize() {
        singleSetup();
        PartyListPageController plpc = new PartyListPageController();
        plpc.filterByMaxPartySize = 4;
        plpc.filterByMaxPartySizeComparisonOp = '=';
        List<Party__c> parties = plpc.getParties();
        for (Party__c p : parties) {
            system.assertEquals(p.Name, 'test');
        }
    }
    
    @isTest
    public static void testGetPartiesMaxSizeNegative() {
        singleSetup();
        PartyListPageController plpc = new PartyListPageController();
        plpc.filterByMaxPartySize = 4;
        plpc.filterByMaxPartySizeComparisonOp = '<';
        List<Party__c> parties = plpc.getParties();
        system.assert(parties.isEmpty());
    }
    
    @isTest
    public static void testGetPartiesMinLvl() {
        singleSetup();
        PartyListPageController plpc = new PartyListPageController();
        plpc.filterByMinimumLevelRequired = 5;
        plpc.filterByMinLvlReqComparisonOp = '=';
        List<Party__c> parties = plpc.getParties();
        for (Party__c p : parties) {
            system.assertEquals(p.Name, 'test');
        }
    }
    
    @isTest
    public static void testGetPartiesMinLvlNegative() {
        singleSetup();
        PartyListPageController plpc = new PartyListPageController();
        plpc.filterByMinimumLevelRequired = 5;
        plpc.filterByMinLvlReqComparisonOp = '>';
        List<Party__c> parties = plpc.getParties();
        system.assert(parties.isEmpty());
    }
    
    @isTest
    public static void testGetPartiesClass() {
        singleSetup();
        PartyListPageController plpc = new PartyListPageController();
        plpc.filterByClassRequirements = new List<string>();
        plpc.filterByClassRequirements.add('Fighter');
        List<Party__c> parties = plpc.getParties();
        for (Party__c p : parties) {
            system.assertEquals(p.Name, 'test');
        }
    }
    
    @isTest
    public static void testGetPartiesClassNegative() {
        singleSetup();
        PartyListPageController plpc = new PartyListPageController();
        plpc.filterByClassRequirements = new List<string>();
        plpc.filterByClassRequirements.add('Warlock');
        plpc.filterByClassRequirements.add('Wizard');
        List<Party__c> parties = plpc.getParties();
        system.assert(parties.isEmpty());
    }
    
    @isTest
    public static void testGetPartiesManyFilters() {
        singleSetup();
        PartyListPageController plpc = new PartyListPageController();
        plpc.filterByName = 'es';
        plpc.filterByAcceptingNewMembers = 'true';
        plpc.filterByPartySize = 1;
        plpc.filterByPartySizeComparisonOp = '=';
        plpc.filterByMaxPartySize = 4;
        plpc.filterByMaxPartySizeComparisonOp = '=';
        plpc.filterByMinimumLevelRequired = 5;
        plpc.filterByMinLvlReqComparisonOp = '=';
        plpc.filterByClassRequirements = new List<string>();
        plpc.filterByClassRequirements.add('Fighter');
        List<Party__c> parties = plpc.getParties();
        for (Party__c p : parties) {
            system.assertEquals(p.Name, 'test');
        }
    }
    
    @isTest
    public static void testJoinParty() {
        singleSetup();
        PartyListPageController plpc = new PartyListPageController();
        plpc.partyid = partyid;
        plpc.currentParty = [SELECT id FROM Party__c WHERE id = :partyid];
        Guild_Member__c gm = new Guild_Member__c();
        gm.User__c = UserInfo.getUserId();
        gm.Name = 'Tom';
        gm.Member_Email__c = 'tom@tom.tom';
        gm.class__c = 'Cleric';
        gm.Artificer_Level__c = 1;
        insert gm;
        plpc.joinParty();
        Party__c party = [SELECT Party_Size__c, (SELECT Guild_Member__c FROM Member_Assignments__r) FROM Party__c LIMIT 1];
        system.assertEquals(2, party.Member_Assignments__r.size());
        system.assertEquals(party.Party_Size__c, 2);
        List<string> memberids = new List<string>();
        for (Member_Assignment__c ma : party.Member_Assignments__r) {
            memberids.add(ma.Guild_Member__c);
        }
        List<Guild_Member__c> members = [SELECT Name FROM Guild_Member__c WHERE id IN :memberids];
        Set<string> names = new Set<string>();
        for (Guild_Member__c member : members) {
            names.add(member.Name);
        }
        system.assert(names.contains('Tom'));
    }
    
}