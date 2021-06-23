@isTest
private class ProjectCalloutServiceTest {
  //Implement mock callout tests here
  @isTest static void testPostCallout() {
    Account a = new Account(Name='ACME Corp, Inc.');
    insert a;
    List<Id> idList = new List<Id>();
    Opportunity opptest = new Opportunity(Name='Super-Duper Big Deal', AccountId=a.id, closeDate=Date.Today(), Amount= 150000, StageName='New Project');
    insert opptest;
    Opportunity opptest1 = new Opportunity(Name='Super-Duper Big Deal', AccountId=a.id, closeDate=Date.Today(), Amount= 150000, StageName='New Project');
    insert opptest1;

    idList.Add(opptest.id);
    idList.Add(opptest1.id);
    // Set mock callout class 
    Test.setMock(HttpCalloutMock.class, new ProjectCalloutServiceMock()); 
    // This causes a fake response to be sent
    // from the class that implements HttpCalloutMock. 
    Test.startTest();
    ProjectCalloutService.postOpportunityToPMS(idList);
    Test.stopTest();

    //System.assertEquals(200, response.getStatusCode());
  }   
}