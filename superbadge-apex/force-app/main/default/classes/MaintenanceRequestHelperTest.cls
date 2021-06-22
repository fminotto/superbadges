@isTest
global with sharing class MaintenanceRequestHelperTest {
    @isTest static void closeMaintenance() {
        List<Case> cases = MaintenanceRequestHelperDataFactory.createData();
        cases[0].Status = 'Closed';
        
        Test.startTest();
        Database.SaveResult results = Database.update(cases[0], false);
        Test.stopTest();

        Case m = [SELECT ID FROM Case Where ParentId = :results.getId()];
        List<Equipment_Maintenance_Item__c> equip = [SELECT Id, Equipment__c FROM Equipment_Maintenance_Item__c WHERE Maintenance_Request__c = :m.id];
        System.assertEquals(3, equip.size());
    }

    @isTest static void workingMaintenance() {
        List<Case> cases = MaintenanceRequestHelperDataFactory.createData();
        cases[0].Status = 'Working';
        
        Test.startTest();
        Database.SaveResult results = Database.update(cases[0], false);
        Test.stopTest();

        List<Case> m = [SELECT ID FROM Case Where ParentId = :results.getId()];
        System.assertEquals(0, m.size());
    }
}