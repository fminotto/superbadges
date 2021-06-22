@isTest
private class TestRandomContactFactory {
	 @isTest static void TestDeleteContact() {
        // Test data setup
        // Create one account with one opportunity by calling a utility method
        Contact[] ccts = RandomContactFactory.generateRandomContacts(10,'Teste');
       	system.debug(ccts);
        System.assert(ccts.size() == 10);
     }
}