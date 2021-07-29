public class QuestExtension {
    
    public String questId {get; set;}
    public transient Boolean hasError {get; set;}
    public transient String errorMessage {get; set;}
    
    private final String approvalProcessName = 'Approve_Quest_Application';
    
    public QuestExtension(ApexPages.StandardSetController ssc) {
        ssc.setPageSize(10);
        hasError = false;
    }
    
    // @desc: get the description of a quest
    public String getDescription() {
        if(questId == null) {
        	return 'Select a quest from the left to see its information here';
        }
        
        Quest__c q = [SELECT Quest_Details__c From Quest__c WHERE Id = :questId];
        return q.Quest_Details__c;
    }
    
    // @desc: get the title of a quest
    public String getTitle() {
        if(questId == null) {
            return 'Quest Panel';
        }
        
        Quest__c q = [SELECT Name From Quest__c WHERE Id = :questId];
        return q.Name;
    }
    
    // @desc: submit a quest for approval
    public void submitForApproval() {
        if(questId == null) return;
        
        Approval.ProcessSubmitRequest questApprovalRequest = new Approval.ProcessSubmitRequest();
        questApprovalRequest.setObjectId(questId);
        questApprovalRequest.submitterid = UserInfo.getUserId();
        questApprovalRequest.setProcessDefinitionNameOrId(approvalProcessName);
         
        try {
        	Approval.process(questApprovalRequest);
        } catch(Exception e) {
            System.debug(e);
            hasError = true;
            // query for the quest and figure out why we failed
            Quest__c q = [SELECT Status__c, Sub_Status__c FROM Quest__c WHERE Id = :questId ];
            
            // if the quest has already been accepted by some player
            if(q.Status__c == 'Open' && q.Sub_Status__c == 'Accepted') {
                errorMessage = 'This quest has already been accepted by some user. Please try another quest.';
            } 
            
            // if something else happened
            else {
            	errorMessage = 'Unable to submit quest for approval. Please try another quest.';
            }
        } finally {
        	questId = null;
        }
    }
    
}