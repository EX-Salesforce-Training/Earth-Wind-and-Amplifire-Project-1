/* 
 * Name: MemberAssignmentTriggerHandler
 * Authors: Gregory Mannerberg (gregory.mannerberg@revature.net)
 * Last Modified Date: 8/3/2021
 * Description: Handles the logic for MemberAssignmentTrigger
 */
public class MemberAssignmentTriggerHandler {
    
    /* 
     * If the party a guild member is trying to join has any class requirements,
     * check that the guild member has at least one class that matches
     * the party's class requirements. Reject members that don't meet party
     * class requirements.
     */
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
                partyClasses = parties[0].class_requirements__c.split(';');
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
                memberClasses = members[0].class__c.split(';');
            }
            system.debug('Party Classes: ' + partyClasses);
            system.debug('Member Classes: ' + memberClasses);
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