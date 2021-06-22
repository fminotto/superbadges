trigger MaintenanceRequest on Case (after update, before insert) {
    // ToDo: Call MaintenanceRequestHelper.updateWorkOrders
    new MaintenanceRequestTriggerHandler().run();  
}