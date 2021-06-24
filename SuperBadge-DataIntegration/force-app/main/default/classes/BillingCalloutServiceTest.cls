@isTest
private class BillingCalloutServiceTest {
  //Implement mock callout tests here

  @isTest static void projectUpdate(){
    Account a = new Account(Name='ACME Corp, Inc.');
    insert a;

    Opportunity opptest = new Opportunity(Name='Super-Duper Big Deal', AccountId=a.id, closeDate=Date.Today(), Amount= 150000, StageName='New Project');
    insert opptest;

    Project__c prj = new Project__c(ProjectRef__c='TESTE DO MINOTTO', Name='Super-Duper Big Deal',Opportunity__c = opptest.id, Start_Date__c=Date.Today(), End_Date__c=Date.Today(), Billable_Amount__c=12000, Status__c='Running');
    insert prj;

    Test.setMock(WebServiceMock.class, new BillingCalloutServiceMock());

    prj.Status__c = 'Billable';
    Test.startTest();
    update prj;
    Test.stopTest();
} 
}