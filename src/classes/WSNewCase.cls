@RestResource (urlMapping = '/WSNewCaseTest/*')
global class WSNewCase {
	
	@HttpPost
	global static string NewCase(Case csfield){
		system.debug('msozzi:start NewCase');
		string returnString='';
		Savepoint sv = Database.setSavePoint();
		
		try{
			if(csfield != null){
				system.debug('WSNewCase - Caso da inserire'); 				
				list<Account> LAccount = [select Name from Account where Name =: 'Marco Sozzi'];	
				System.debug(LAccount);
				csfield.Status='10';
				csfield.Origin='Phone';

				csfield.Account.Name= LAccount[0].Name;
				System.debug('devo fare la insert');
				insert csfield;
					system.debug('WSNewCase - Case Popolato- non riuscito a inserire');
				}
			}						
			catch(Exception e) {
				Database.rollback(sv);
				returnString = 'Errore: ' + e.getMessage() + '. Stack Trace: ' + e.getStackTraceString();
				return returnString;
				
			}
			return returnstring;		
		}	

}