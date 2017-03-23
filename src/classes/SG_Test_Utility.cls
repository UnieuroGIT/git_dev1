public class SG_Test_Utility {

	public static Loyalty__c insertNewLoyalty(){
		Loyalty__c l = new Loyalty__c();
		l.name = 'TEST-LOYALTY-' + String.valueOf((Integer) Math.random()*10000);
		l.Data_Inizio__c = Date.today();
		l.Data_Scadenza__c = l.Data_Inizio__c.addDays((Integer) Math.random()*100);
		l.Motivo_Inattivita_carta__c = 'TEST MOTIVO INATTIVITa CARTA';
		insert l;
		return l;
	}

	public static Richiesta_Voucher__c insertNewRichiestaVoucher(){
		Richiesta_Voucher__c r = new Richiesta_Voucher__c();
		
		r.Testo_promozione__c = 'TEST-VOUCHER-' + String.valueOf((Integer) Math.random()*10000);
		r.Codice_promozione__c = 'ABC';
	
		insert r;
		return r;
	}

}