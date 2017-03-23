@isTest
private class SG_UNIEURO_Utility_Test {

	@isTest
	private static void testWriteErrorLog1() {
		Loyalty__c l = SG_Test_Utility.insertNewLoyalty();
		
		String code = '123456';
		String descr = 'TEST-DESCR';
		SG_UNIEURO_Utility.WriteErrorLog(l.id, code, descr);
		
		// verifico che l'elemento sia stato creato come deve
		List<Log_Errori__c> lerr = [select id, Loyalty__c, Codice_errore__c, Descrizione__c from Log_Errori__c];
		system.assertEquals(1, lerr.size());
		system.assertEquals(code, lerr[0].Codice_errore__c);
		system.assertEquals(descr, lerr[0].Descrizione__c);
		system.assertEquals(l.id, lerr[0].Loyalty__c);
	}

	@isTest
	private static void testWriteErrorLog2() {
		Richiesta_Voucher__c r = SG_Test_Utility.insertNewRichiestaVoucher();
		
		String code = '123456';
		String descr = 'TEST-DESCR';
		SG_UNIEURO_Utility.WriteErrorLog(r.id, code, descr);
		
		// verifico che l'elemento sia stato creato come deve
		List<Log_Errori__c> lerr = [select id, Richiesta_Voucher__c, Codice_errore__c, Descrizione__c from Log_Errori__c];
		system.assertEquals(1, lerr.size());
		system.assertEquals(code, lerr[0].Codice_errore__c);
		system.assertEquals(descr, lerr[0].Descrizione__c);
		system.assertEquals(r.id, lerr[0].Richiesta_Voucher__c);
	}

	@isTest
	private static void testfindObjectNameFromRecordIdPrefix(){
		Loyalty__c l = SG_Test_Utility.insertNewLoyalty();
	
		String sobjName = SG_UNIEURO_Utility.findObjectNameFromRecordIdPrefix(l.id);

		// verifico che dall'id del record fornito, la funzione recuperi correttamente l'API name dell'oggetto
		system.assertEquals(Schema.SOBjectType.Loyalty__c.name, sobjName);
	}
}