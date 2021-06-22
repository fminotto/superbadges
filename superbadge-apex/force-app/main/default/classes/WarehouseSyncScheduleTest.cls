@isTest
global  with sharing class WarehouseSyncScheduleTest {
    // implement scheduled code here
    @isTest static void testGetCallout() {
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new WarehouseCalloutServiceMock()); 

        Product2 prd = new Product2(Warehouse_SKU__c = '55d66226726b611100aaf741',name = 'Generator 1000 kW', Replacement_Part__c = true,Cost__c = 100 ,Maintenance_Cycle__c = 100);
        insert prd;

        Test.startTest();
        WarehouseSyncSchedule.execute(null);
        Test.stopTest();
        List<Product2> productList = [SELECT Id FROM Product2 WHERE Warehouse_SKU__c != null];
        System.assertEquals(1, productList.size());
    }
}