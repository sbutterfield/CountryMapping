/**
 * @author Sudheer Peddineni
 * @date January 2013
 * @description to test the TestUtil class
*/
@isTest (SeeAllData=true)
private class TestUtilTest {

	static testMethod void myUnitTest() {
		
		List<Account> act = TestUtil.newAccount('Canada', 2);
		List<Contact> cont = TestUtil.newContact('United States', 3);
		List<Lead>    led  = TestUtil.newLead('Australia', 2);
		//insert act;
		Test.startTest();
		system.assertequals(2, act.size());
		system.assertequals(3, cont.size());
		system.assertequals(2, led.size());
		Test.stopTest();
	}
}