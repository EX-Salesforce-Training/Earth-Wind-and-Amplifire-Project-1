// @author: Zackary Frazier
// @created: 7/29/2021
// @desc: trigger handler for contact trigger


public class ContactTriggerHandler {
    
    // @desc: ensure that there are no duplicate emails
    public static void ensureUniqueEmail(List<Contact> newContacts) {
        
        // gather up all the new emails
        Set<String> newEmails = new Set<String>();
        for(Contact con: newContacts) {
            if(con.Email != null) {
            	newEmails.add(con.Email);
            }
        }
        
        // gather up all the old emails
        List<Contact> conList = [SELECT Email FROM Contact WHERE Email IN :newEmails];
        Set<String> usedEmails = new Set<String>();
        for(Contact con: conList) {
            if(con.Email != null) {
            	usedEmails.add(con.Email);
            }
        }
        
        // ensure that none of the new emails are already in use
        for(Contact con: newContacts) {
            if(usedEmails.contains(con.Email)) {
                con.addError('This email is already in use.');
            }
        }
        
        // ensure that we're not adding two emails with the same value
        for(Contact firstCon: newContacts) {
            Integer i = 0;
            for(Contact secondCon: newContacts) {
                if(firstCon.Email == secondCon.Email && firstCon.Email != null) {
                    i++;
                }
                
                if(i == 2) {
                    firstCon.addError('Attempted to add two contacts with duplicate emails.');
                    secondCon.addError('Attempted to add two contacts with duplicate emails.');
                }
            }
        }
    } 
}