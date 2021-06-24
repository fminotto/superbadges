@isTest
private class ProjectRESTServiceTest {
  //Implement Apex REST service tests here
  @istest static void postProjectDataOk() {
    Account a = new Account(Name = 'TESTE');
    insert a;

    Opportunity o = new Opportunity(AccountId = a.id, Name = 'TESTE', StageName='New', CloseDate = Date.Today());
    insert o;

    Test.startTest();
    String result = ProjectRESTService.postProjectData('TESTE DO MINOTTO', 'Super-Duper Big Deal', o.id, Date.Today(), Date.Today(), 12000, 'Running') ;
    Test.stopTest();
    system.assertEquals('OK', result);
  }

  @istest static void postProjectDataError() {
    Test.startTest();
    String result = ProjectRESTService.postProjectData('TESTE DO MINOTTO', 'Super-Duper Big Deal', '', Date.Today(), Date.Today(), 12000, 'Running') ;
    Test.stopTest();
    system.assert(result.contains('Error:'), result);
  }
}