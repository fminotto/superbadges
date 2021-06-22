public class AccountProcessor {
    @future
    public static void countContacts(Set<id> setId) {
        List<Account> listAcct = new List<Account>();
        for (Account acct : [SELECT Id, (select Id from Contacts) FROM Account
                             WHERE Id IN :setId]) {            
        	List<Contact> lstCont = acct.contacts ;
          	acct.Number_of_Contacts__c = lstCont.size();
            listAcct.add(acct);        		
        }
        if(listAcct.size()>0){
            update listAcct;
        }                          
    }
}