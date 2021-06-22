public with sharing class MaintenanceRequestTriggerHandler  extends TriggerHandler {
    public MaintenanceRequestTriggerHandler() {

    }

    protected override void afterInsert()
    {
        this.createJoinRecords();
    }

    protected override void beforeUpdate()
    {
        //this.updateWorkOrders();
    }

    protected override void afterUpdate()
    {
        this.updateWorkOrders();
    }

    private void updateWorkOrders() {
        MaintenanceRequestHelper mrh = new MaintenanceRequestHelper();
        List<AggregateResult> cycles = [select Maintenance_Request__c, min(Equipment__r.Maintenance_Cycle__c) cycle 
                                          from Equipment_Maintenance_Item__c 
                                         where Maintenance_Request__c in :Trigger.newMap.keySet()
                                         GROUP BY Maintenance_Request__c];

        Map<String, decimal> mapCycles = new Map<String, decimal>();
        for(AggregateResult a:cycles){
            mapCycles.put((String)a.get('Maintenance_Request__c'), (decimal)a.get('cycle'));
        }     

        List<Case> listNewCases = new List<Case>();
        for(Case c : (List<Case>)Trigger.New) {
            decimal cycle = mapCycles.get(c.id) == null ? 0 : mapCycles.get(c.id);
            Case retCase = mrh.updateWorkOrders(c, cycle.intValue());
            if(retCase != null) {
                listNewCases.add(retCase);
            }
        }

        if(listNewCases.size() > 0) {
            insert listNewCases;
        }
    }

    private void createJoinRecords() {
        List<String> listParent = new List<String>();
        for(Case c : (List<Case>)Trigger.New) {
            if(c.ParentId != null) {
                if (!listParent.contains(c.ParentId)) {
                    listParent.add(c.ParentId);
                }
            }
        }

        if (listParent.size() > 0) {
            List<Equipment_Maintenance_Item__c> listItems = [SELECT Maintenance_Request__c, Equipment__c
                                                               FROM Equipment_Maintenance_Item__c
                                                              WHERE Maintenance_Request__c in :listParent];

            Map<String, List<String>> mapEquip = new Map<String, List<String>>();
            for(Equipment_Maintenance_Item__c e : listItems) {
                List<String> equipments = new List<String>(mapEquip.get(e.Maintenance_Request__c));
                equipments.add(e.Equipment__c);
                mapEquip.put(e.Maintenance_Request__c, equipments);
            }

            List<Equipment_Maintenance_Item__c> joinRecords = new List<Equipment_Maintenance_Item__c>();
            for(Case c : (List<Case>)Trigger.New) {
                for(String equip : mapEquip.get(c.ParentId)) {
                    joinRecords.add(new Equipment_Maintenance_Item__c(Equipment__c = equip, Maintenance_Request__c = c.Id)); 
                }
            }

            System.debug(joinRecords.size());
            if(joinRecords.size()>0){
                List<Database.SaveResult> results = Database.insert(joinRecords, false);
                System.debug(results);
            }
        } 
    }
}