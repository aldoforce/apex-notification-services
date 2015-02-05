/**
*	Apex Notification Services: given an exception, sends a notification to a defined user.
*	
*	Check source repo: https://github.com/aldoforce/apex-notification-services
* Send some feedback! Happy coding!
* --@aldoforce
**/
public with sharing class ApexNotificationServices {
	
	public static void notify(Exception pException) {
		ApexNotificationServices.notify(pException, null);
	}
	
	public static void notify(Exception pException, String pSummary) {
		//you will need to change this to a valid address. Best practice: use a Custom Setting
		String recipient_email_address = 'something@domain.com'; 
		try {
			//create email
		  Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();	

		  //subject
		  mail.setSubject('[Apex Notification Services] Exception detected!');

		  //get email's body
		  String body = ApexNotificationServices.get_email_body(pException, pSummary);

		  //body
		  mail.setPlainTextBody(body);

		  //to
		  mail.setToAddresses(
		  	new String[]{
		  		recipient_email_address
		  	}
		  );

		  //send email
		  Messaging.sendEmail(
		  	new Messaging.SingleEmailMessage[]{
		  		mail
		  	}
		  );
		}
		catch(Exception pEx) {
			system.debug(logginglevel.ERROR, pEx.getStackTraceString());
		}
		
	}

	private static String get_email_body(Exception pException, String pSummary) {
		String result;
		try {
			result = 'Apex Notification Services reporting a system exception: \n\n' +
							 'Exception details: \n' +
							 '	[ Message ] : {0} \n ' +
							 '	[ Type ] : {1} \n ' +
							 '	[ Trace ] : {2} \n ' +
							 '\n' +
							 'Context: \n' +
							 '	[ Summary ] : {3} \n' +
							 '	[ Org ] : {4} ({5})\n' +
							 '	[ Running user ] : {6} ({7}) \n' +
							 '	[ Profile ] : ({8}) \n' +
							 '	[ Timestamp ] : {9}';

			//binding
			result = String.format(	result, 
															new String[]{
																pException.getMessage(),
																pException.getTypeName(),
																pException.getStackTraceString(),
																pSummary != null ? pSummary : 'n/a',
																UserInfo.getOrganizationName(),
																UserInfo.getOrganizationId(),
																UserInfo.getUserName(),
																UserInfo.getUserId(),
																UserInfo.getProfileId(),
																Datetime.now().format()
															}
			);
							 					 
		}
		catch(Exception pEx) {
			result = ''; //default value
		}
		
		return result;
	}
}