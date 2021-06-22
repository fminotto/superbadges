global with sharing class WarehouseCalloutService implements Queueable {

    private static final String WAREHOUSE_URL = 'https://th-superbadge-apex.herokuapp.com/equipment';
    
    @future (callout=true)
    public static void runWarehouseEquipmentSync (){
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(WAREHOUSE_URL);
        request.setMethod('GET');
        HttpResponse response = http.send(request);
        if (response.getStatusCode() == 200) {
            String resp = response.getBody();
            resp = resp.replace('_id', 'id');

            List<Equipments> equipList = (List<Equipments>)JSON.deserialize(resp, List<Equipments>.class);               
            
            Map<String, Equipments> equipMap = new Map<String, Equipments>();
            for(Equipments equip : equipList){
                equipMap.put(equip.id, equip);
            }

            List<Product2> productList = [SELECT ID, Warehouse_SKU__c from Product2 where Warehouse_SKU__c in :equipMap.keySet()];
            
            for(Product2 prd : productList){
                Equipments equip = equipMap.get(prd.Warehouse_SKU__c);
                prd.Cost__c = equip.cost;
                prd.Current_Inventory__c = equip.quantity;
                prd.Lifespan_Months__c = equip.lifespan;
                prd.Maintenance_Cycle__c = equip.maintenanceperiod;
                prd.Replacement_Part__c = equip.replacement;
                equipMap.remove(prd.Warehouse_SKU__c);
            }

            for(Equipments equip : equipMap.values()) {
                productList.Add(new Product2(Cost__c = equip.cost, Current_Inventory__c = equip.quantity, Lifespan_Months__c = equip.lifespan,
                                            Maintenance_Cycle__c = equip.maintenanceperiod, Replacement_Part__c = equip.replacement, 
                                            Name=equip.name, Warehouse_SKU__c= equip.sku));
            }

            if(productList.size()>0){
                upsert productList;
            }
        }             
    }

    public class Equipments
    {
        String id;
        Boolean replacement;
        Integer quantity;
        String name;
        Integer maintenanceperiod;
        Integer lifespan;
        Integer cost;
        String sku;
    }   

    global static void execute(QueueableContext context){
        runWarehouseEquipmentSync();
    }
}