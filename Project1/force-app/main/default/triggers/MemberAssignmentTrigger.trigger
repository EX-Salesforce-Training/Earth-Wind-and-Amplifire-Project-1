trigger MemberAssignmentTrigger on Member_Assignment__c (before insert, before update, before delete, after insert, after update, after delete, after undelete) {
    
    switch on trigger.OperationType {
        when BEFORE_INSERT {
            MemberAssignmentTriggerHandler.validateClass(trigger.new);
        }
        when BEFORE_UPDATE {
            MemberAssignmentTriggerHandler.validateClass(trigger.new);
        }
        when BEFORE_DELETE {
            
        }
        when AFTER_INSERT {
            
        }
        when AFTER_UPDATE {
            
        }
        when AFTER_DELETE {
            
        }
        when AFTER_UNDELETE {
            
        }
    }

}