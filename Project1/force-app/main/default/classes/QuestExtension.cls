public class QuestExtension {
    
    public String questId {get; set;}
    public transient Boolean hasError {get; set;}
    public transient String errorMessage {get; set;}
    public QuestFormData formData {get; set;}
    
    private final String approvalProcessName = 'Approve_Quest_Application';
    
    public QuestExtension(ApexPages.StandardSetController ssc) {
        ssc.setPageSize(10);
        hasError = false;
        formData = new QuestFormData();
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
    
    // @desc : this function allows us to dynamically create a new quest from the quest page
    public void saveQuest() {
        System.debug(formData);
        
        Quest__c newQuest = new Quest__c();
        newQuest.Name = formData.questName;
        newQuest.Danger_Level__c = formData.dangerLevel;
        newQuest.Location__c = formData.location;
        newQuest.Requires_Party__c = formData.requiresParty;
        newQuest.Quest_Details__c = formData.questDetails;
        newQuest.Reward__c = formData.reward;
        
        if(formData.requiredProfessionAdventurer && formData.requiredProfessionCraftsman) {
            newQuest.Required_Professions__c = 'Adventurer,Craftsman';
        } else if(formData.requiredProfessionAdventurer) {
            newQuest.Required_Professions__c = 'Adventurer';
        } else if(formData.requiredProfessionCraftsman) {
            newQuest.Required_Professions__c = 'Craftsman';
        }
        
        // standard stuff
        newQuest.Status__c = 'New';
        newQuest.Sub_Status__c = 'Pending';
        newQuest.Date_Opened__c = Date.today();
        
        // deprecated, but needed for now
        newQuest.Quest_Country__c = 'USA';
        newQuest.Quest_City__c = 'Baltimore';
        newQuest.Quest_Postal_Code__c = '20740';
        newQuest.Quest_Street__c = '123 main ave';
        newQuest.Quest_State__c = 'Maryland';
        
        try {
            insert newQuest;
        } catch(DMLException e) {
			System.debug(e);
        } catch(Exception e) {
        	System.debug(e);
        } finally {
      	
            formData = new QuestFormData();
        }        
    }
}