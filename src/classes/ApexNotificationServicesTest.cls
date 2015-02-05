@isTest
private class ApexNotificationServicesTest {
	
	private class TestException extends Exception{}

	@isTest static void test_1() {
		//pre-context
			TestException t = new TestException('This is a test exception');

		//test
		Test.startTest();
			Integer before = Limits.getEmailInvocations();
			
			ApexNotificationServices.notify(t, 'summary here');

			Integer after = Limits.getEmailInvocations();

			system.assertNotEquals(
				before, 
				after,
				'An email should be sent with a notification!'
			);

		Test.stopTest();
	}

	@isTest static void test_2() {
		//pre-context
			TestException t = new TestException('This is a test exception');

		//test
		Test.startTest();
			Integer before = Limits.getEmailInvocations();
			
			ApexNotificationServices.notify(t);

			Integer after = Limits.getEmailInvocations();

			system.assertNotEquals(
				before, 
				after,
				'An email should be sent with a notification!'
			);

		Test.stopTest();
	}
	
}