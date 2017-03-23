@isTest private class WSNewCaseTest {

	@IsTest
	private static void prova(){
		//List<Account> LAccount = [ SELECT id FROM Account where Name =: 'Stefania'];
		string ac = NewAccount();
		system.debug(ac);
		
		Case cf = new Case();
		System.debug(ac);
		cf.Status='10';
		cf.Origin='Phone';
		cf.Descrizione__c=ac;
		

		//cf.Categorie__c = 'test';
		//cf.Priority = '10';
		//cf.Descrizione__c= ac;
		//System.debug(cf.Descrizione__c);
		//cf.AccountId = LAccount[0].id;
		insert cf;

		Test.startTest();
		string output = WSNewCase.NewCase(cf);
		//insert cf;
		Test.stopTest();		
		//System.assertEquals(output, '');
	}
	
		@isTest
		public static string NewAccount() {
			Account a = new Account();
			string name='Rares sei un BOMBER';
			a.Name=name;
			return name;
		}
}