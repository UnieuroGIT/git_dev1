trigger SG_richiestaVoucherTrigger_AfterInsertUpdate on Richiesta_Voucher__c (after insert, after update)  {

	if(Trigger.isInsert)
		richiestaVoucherTrigger_UtilityClass.insertRestrizioniVoucher(Trigger.newMap);

	if(Trigger.isUpdate)
		richiestaVoucherTrigger_UtilityClass.insertRestrizioniVoucher(Trigger.newMap);
	
}