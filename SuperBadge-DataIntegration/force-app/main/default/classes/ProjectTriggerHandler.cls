public with sharing class ProjectTriggerHandler extends TriggerHandler{
    public ProjectTriggerHandler() {}

    protected override void afterUpdate()
    {
        BillingCalloutService.callBillingService((List<Project__c>)Trigger.new, (Map<Id, Project__c>)Trigger.newMap, (List<Project__c>)Trigger.old, (Map<Id, Project__c>)Trigger.oldMap);
    }
}
