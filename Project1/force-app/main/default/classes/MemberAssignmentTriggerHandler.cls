public class MemberAssignmentTriggerHandler {
    
    public static void validateClass(List<Member_Assignment__c> assignments) {
        for (Member_Assignment__c ma : assignments) {
            boolean match = false;
            List<Party__c> parties = [SELECT class_requirements__c FROM Party__c WHERE id = :ma.party__c LIMIT 1];
            if (parties.isEmpty()) {
                ma.addError('Missing a party reference on member assignment object');
                return;
            }
            List<string> partyClasses = new List<string>();
            if (parties[0].class_requirements__c != null && parties[0].class_requirements__c != '') {
                parties[0].class_requirements__c.split(';');
            }
            else {
                match = true;
            }
            List<Guild_Member__c> members = [SELECT class__c FROM Guild_Member__c WHERE id = :ma.guild_member__c LIMIT 1];
            if (members.isEmpty()) {
                ma.addError('Missing a guild member reference on member assignment object');
                return;
            }
            List<string> memberClasses = new List<string>();
            if (members[0].class__c != null && members[0].class__c != '') {
                members[0].class__c.split(';');
            }
            for (string partyClass : partyClasses) {
                for (string memberClass : memberClasses) {
                    if (partyClass == memberClass) {
                        match = true;
                    }
                }
            }
            if (!match) {
                ma.addError('The member does not have any of the party required classes.');
            }
        }
    }

}