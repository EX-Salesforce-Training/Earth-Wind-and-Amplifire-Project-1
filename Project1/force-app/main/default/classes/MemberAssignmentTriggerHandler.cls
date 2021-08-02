public class MemberAssignmentTriggerHandler {
    
    public static void validateClass(List<Member_Assignment__c> assignments) {
        for (Member_Assignment__c ma : assignments) {
            List<string> partyClasses = [SELECT class_requirements__c FROM Party__c WHERE id = :ma.party__c LIMIT 1].class_requirements__c.split(';');
            List<string> memberClasses = [SELECT class__c FROM Guild_Member__c WHERE id = :ma.guild_member__c LIMIT 1].class__c.split(';');
            boolean match = false;
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