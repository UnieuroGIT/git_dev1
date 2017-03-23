// MSozzi 23/03/2017 utility class contenente metodi statici per i trigger sull'oggetto richiesta_voucher__c
public class SG_richiestaVoucherTrigger_UtilityClass {

	// creazione record Restrizioni_Voucher__c sulla base dei valori di picklist Restrizioni__c
	public static void insertRestrizioniVoucher(Map<Id, Richiesta_Voucher__c> mapRichieste){
		List<Restrizioni_Voucher__c> restrVoucher = new List<Restrizioni_Voucher__c>();

		for(Richiesta_Voucher__c rv : mapRichieste.values()){

			if((rv.stato__c == SG_UNIEURO_Utility.PICKVAL_NEW) || 
			   (rv.stato__c == SG_UNIEURO_Utility.PICKVAL_INPROGRESS) || 
			   (rv.stato__c == SG_UNIEURO_Utility.PICKVAL_ERROR))
			{
				// recupero lista valori selezionati
				Set<String> userSelectedValues = new Set<String>();
				userSelectedValues.addAll(rv.Restrizioni__c.split(';'));

				// tengo solo i numerelli
				Set<String> userSelectedValues_Numbers = new Set<String>();
				for(String s : userSelectedValues){
					userSelectedValues_Numbers.add(s.replaceAll('[A-Za-z]',''));
				}

				// estraggo tutti i record type per Restrizioni_Voucher__c
				List<RecordType> restrVoucher_RT = [select id, name from RecordType where SObjectType = 'Restrizioni_Voucher__c'];

				// metto i record type in una mappa ordinata per numerello
				Map<String, RecordType> Map_restrVoucher_RT = new Map<String, RecordType>();
				for(RecordType rt : restrVoucher_RT)
					Map_restrVoucher_RT.put(rt.name.replaceAll('[A-Za-z]',''), rt);

				for(String snum : userSelectedValues_Numbers){
					if(Map_restrVoucher_RT.containsKey(snum)){
						Restrizioni_Voucher__c restrV = new Restrizioni_Voucher__c();
						restrV.Richiesta_Voucher__c = rv.id;
						restrV.recordType = Map_restrVoucher_RT.get(snum);

						restrVoucher.add(restrV);
					}
				}

			}	// Fine if sullo stato di Richiesta_Voucher__c

		} // Fine loop su Richiesta_Voucher__c
	
		upsert restrVoucher;
	}


}