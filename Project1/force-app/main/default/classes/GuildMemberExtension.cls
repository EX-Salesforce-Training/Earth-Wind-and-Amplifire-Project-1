public class GuildMemberExtension {
    
    public GuildMemberExtension(ApexPages.StandardSetController ssc){
        ssc.setPageSize(10);
    }
    
    public List<SelectOption> getSkills() {
        List<SelectOption> skills = new List<SelectOption>();
        Schema.DescribeFieldResult describeResult = Guild_Member__c.Skills__c.getDescribe();
        List<Schema.PicklistEntry> picklistEntries = describeResult.getPickListValues();
        for(Schema.PicklistEntry pe : picklistEntries){
            skills.add(new SelectOption(pe.getValue(), pe.getLabel()));
        }
        return skills;
    }
    
}