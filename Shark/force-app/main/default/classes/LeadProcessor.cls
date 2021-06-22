public class LeadProcessor implements Database.Batchable<sObject>{
    public Database.QueryLocator start(Database.BatchableContext bc) {
         return Database.getQueryLocator('SELECT ID, LeadSource FROM Lead');
    }
    
    public void execute(Database.BatchableContext bc, List<Lead> scope){
        List<Lead> listLead = new List<Lead>();
        for (Lead lead : scope) {
            lead.LeadSource = 'Dreamforce';
        	listLead.add(lead);
        }
        
        if(listLead.size()>0){
            update listLead;
        }
        
    }
    
    public void finish(Database.BatchableContext bc){
    
    }
}