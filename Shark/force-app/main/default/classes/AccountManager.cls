@RestResource(urlMapping='/Accounts/*/contacts')
global with sharing class AccountManager {
    @HttpGet
    global static Account getAccount() {
        RestRequest request = RestContext.request;
        String accountId = request.requestURI.substringBetween('Accounts/','/contacts');
        system.debug(accountId);
        Account result =  [SELECT ID, Name, (Select Id, Name from Contacts)
                           FROM Account
                           WHERE Id = :accountId LIMIT 1];
        return result;
    }
}