public with sharing class MaintenanceRequestHelper {
    public Case updateWorkOrders(Case c, integer cycle) {
        // TODO: Complete the method to update workorders
        if( ((c.Type == 'Repair') || (c.Type == 'Routine Maintenance')) && (c.Status == 'Closed')){
            Case newCase = new Case();
            newCase.Type = 'Routine Maintenance';
            newCase.Status = 'New';
            newCase.Subject = 'Routine Maintenance Request';
            newCase.Origin = 'Web';
            newCase.Date_Reported__c = System.today();
            newCase.Date_Due__c = newCase.Date_Reported__c.addDays(cycle);
            newCase.ParentId = c.Id;
            newCase.Product__c = c.Product__c;
            newCase.Vehicle__c = c.Vehicle__c;
            newCase.Subject = String.isBlank(c.Subject) ? 'Routine Maintenance Request' : c.Subject + ' New';
            newCase.AccountId = c.AccountId;
            newCase.ContactId = c.ContactId;
            newCase.AssetId = c.AssetId;
            newCase.Origin = c.Origin;
            newCase.Reason = c.Reason;
            return newCase;
        } else {
            return null;
        }
    }    
}