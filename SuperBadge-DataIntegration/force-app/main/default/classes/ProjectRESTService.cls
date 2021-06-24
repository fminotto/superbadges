@RestResource(urlMapping='/project')
global class ProjectRESTService {
    //Implement service logic here
    @HttpPost
    global static String postProjectData(String ProjectRef, String ProjectName, String OpportunityId, Date StartDate, Date EndDate, Double Amount, String Status){
        SavePoint sp = Database.setSavepoint();
        try {
            Project__c prj = new Project__c(ProjectRef__c=ProjectRef, Name=ProjectName, Opportunity__c=OpportunityId, Start_Date__c=StartDate, End_Date__c=EndDate, Billable_Amount__c=Amount, Status__c=Status);
            upsert prj ProjectRef__c;

            Opportunity opp = new Opportunity(id=prj.Opportunity__c, DeliveryInstallationStatus__c='In progress');
            update opp;
            return 'OK';

        } catch (Exception e) {
            Database.rollback(sp);
            return 'Error: ' + e.getMessage();           
        }
    }
}