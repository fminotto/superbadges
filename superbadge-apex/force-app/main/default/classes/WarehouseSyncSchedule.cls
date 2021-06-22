global with sharing class WarehouseSyncSchedule implements Schedulable{
    // implement scheduled code here
    global static void execute(SchedulableContext context){
        System.enqueueJob(New WarehouseCalloutService());
    }
}