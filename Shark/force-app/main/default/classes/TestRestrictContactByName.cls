@isTest
public class TestRestrictContactByName {
    @isTest static void TestRestrictContactByName() {
        Contact cct = new Contact(FirstName='Test', LastName='INVALIDNAME');
        // Perform test
        Test.startTest();
        Database.SaveResult result = Database.insert(cct, false);
        Test.stopTest();
		System.assert(!result.isSuccess());
        System.assert(result.getErrors().size() > 0);
        System.assertEquals('The Last Name "INVALIDNAME" is not allowed for DML',
                             result.getErrors()[0].getMessage());
    }
}