public class AddPrimaryContact implements Queueable {
    private Contact contact;
    private String state;
    
    public AddPrimaryContact(Contact records, String state ) {
        this.contact = records;
        this.state = state;
    }
    
	public void execute(QueueableContext context) {
        List<Account> listAcct = new List<Account>();
        List<Contact> lstContact = new List<Contact>();
        for (Account acct : [SELECT Id, (select Id, Name from Contacts) FROM Account
                             WHERE BillingState = :this.state limit 200]) { 
        	Contact cont = contact.clone(false,false,false,false);
            cont.AccountId =  acct.id;
            lstContact.add( cont );                   
        }
        
        if(lstContact.size() >0 )
        {
            insert lstContact;
        }
    }
}