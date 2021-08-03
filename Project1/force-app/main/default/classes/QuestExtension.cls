public class QuestExtension {
    
    public String questId {get; set;}
    public QuestFormData formData {get; set;}
    public transient String assigneeEmail {get;set;}
    
    private final String approvalProcessName = 'Approve_Quest_Application';
    
    public QuestExtension(ApexPages.StandardSetController ssc) {
        ssc.setPageSize(10);
        formData = new QuestFormData();
    }
    
    // @desc: get the description of a quest
    public String getDescription() {
        String details = 'Select a quest from the left to see its information here';
        if(questId == null) return details;
        

        try {
        	Quest__c q = [SELECT Quest_Details__c From Quest__c WHERE Id = :questId];
            details = q.Quest_Details__c;
        } catch(Exception e) {
            // move on
        }
        
        return details;
    }
    
    // @desc: get the title of a quest
    public String getTitle() {
        String title = 'Quest Panel';
        if(questId == null) {
            return title;
        }
        
        try {
        	Quest__c q = [SELECT Name From Quest__c WHERE Id = :questId];
            title = q.Name;
        } catch(Exception e) {
            // invalid id
        }
        return title;
    }
    
    // @desc: submit a quest for approval
    public PageReference submitForApproval() {
        if(questId == null) return null;
        if(assigneeEmail == null || assigneeEmail == '') return null;
        
        
        assigneeEmail = assigneeEmail.toLowerCase();

        Approval.ProcessSubmitRequest questApprovalRequest = new Approval.ProcessSubmitRequest();
        questApprovalRequest.setObjectId(questId);
        questApprovalRequest.submitterid = UserInfo.getUserId();
        questApprovalRequest.setProcessDefinitionNameOrId(approvalProcessName);
        
        Guild_Member__c guildMem;
        Quest__c q;
        try {
            guildMem = [SELECT Member_Email__c FROM Guild_Member__c WHERE Member_Email__c = :assigneeEmail];
            q = [SELECT Contact__c FROM Quest__c WHERE Id = :questId];
        } catch(Exception e) {
            System.debug(e);
            return null;
        }
        
        PageReference nextPage = null;
        try {
        	Approval.process(questApprovalRequest);
            nextPage = Page.QuestPageSuccessfulSubmission;
            
            // if the guild member gets rejected, this will still be here, not exactly elegant
            q.Guild_Member__c = guildMem.id;
            update q;
        } catch(Exception e) {
            System.debug(e);
            // do nothing and move on
        } finally {
        	questId = null;
        }
        
        return nextPage;
    } 
    
    // @desc : this function allows us to dynamically create a new quest from the quest page
    public PageReference saveQuest() {
        Quest__c newQuest = new Quest__c();
        newQuest.Name = formData.questName;
        newQuest.Danger_Level__c = formData.dangerLevel;
        newQuest.Location__c = formData.location;
        newQuest.Requires_Party__c = formData.requiresParty;
        newQuest.Quest_Details__c = formData.questDetails;
        newQuest.Reward__c = formData.reward;
        
        if(formData.requiredProfessionAdventurer && formData.requiredProfessionCraftsman) {
            newQuest.Required_Professions__c = 'Adventurer;Craftsman';
        } else if(formData.requiredProfessionAdventurer) {
            newQuest.Required_Professions__c = 'Adventurer';
        } else if(formData.requiredProfessionCraftsman) {
            newQuest.Required_Professions__c = 'Craftsman';
        }
        
        String email = formData.email;
        
		// we're done with form data, reset it        
        formData = new QuestFormData();
		
        try {        
        	Contact con = [SELECT Id FROM Contact WHERE Email = :email];
            newQuest.Contact__c = con.id;
        } catch(Exception e) {
            return null;
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
        } catch(Exception e) {
			return null;
        }
        
        return Page.QuestPageSuccessfulSubmission;
    }
}