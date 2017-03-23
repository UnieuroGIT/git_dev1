public class SG_UNIEURO_Utility {

	// valori di picklist statici per Richiesta_Voucher__c.stato__c
	public static String PICKVAL_NEW = 'Nuovo';
	public static String PICKVAL_INPROGRESS = 'In corso';
	public static String PICKVAL_ERROR= 'Errore';

	// valori di picklist statici per Richiesta_Voucher__c.Restrizioni__c
	public static String NO_RESTR = '00';
	public static String NUM_ORDER_RESTR = '10';
	public static String REVENUE_RESTR = '20';
	public static String NEW_CUSTOMER_RESTR = '30';
	public static String ORDER_VALUE_RESTR = '40';
	public static String PRODUCT_ITEM_RESTR = '50';
	public static String PRODUCT_CATEGORY_RESTR = '60';
	public static String PRODUCT_AMOUNT_RESTR = '70';
	public static String USER_RESTR = '80';
	public static String TEMPORARY_RESTR = '90';

	private static Map<String, Schema.SObjectType> gd = null;

	// Marco Sozzi 22/03/2017 creazione record error log
	public static void WriteErrorLog(ID itemId, String ErrorCode, String ErrorDescription){

		Log_Errori__c lerr = new Log_Errori__c();

		// Using the first three characters of the record id to retrieve the sobject name
		String sobjectName = findObjectNameFromRecordIdPrefix((String) ItemId);
		
		Map<String, Schema.SObjectField> fieldMap = Schema.SObjectType.Log_Errori__c.fields.getMap();

		for(String fieldAPIname : fieldMap.keySet()){
			Schema.DescribeFieldResult dfrTemp = fieldMap.get(fieldAPIname).getDescribe();

			// if we are in a lookup relationship, then we retrieve the sobject token
			if(dfrTemp.getRelationshipName()!= null && dfrTemp.getRelationshipName().contains('__r')){
				system.debug('SG_Mas_Utility::WriteErrorLog - ' + dfrTemp);
				Schema.SObjectType sobjToken = gd.get(dfrTemp.getRelationshipName().replace('__r', '__c'));

				if(sobjToken.getDescribe().getName() == sobjectName){
					system.debug('SG_Mas_Utility::WriteErrorLog - Setting lookup field');
					lerr.put(sobjectname, itemId);
					// exiting the loop
					break;
				}

			}

		}

		// adding the remaining fields
		lerr.Codice_errore__c = ErrorCode;
		lerr.Descrizione__c = ErrorDescription;
		
		system.debug('SG_Mas_Utility::WriteErrorLog - ' + lerr);
		upsert lerr;

	}

	// funzione che recupera l'API name di un sobject partendo dall'id di un record
	public static String findObjectNameFromRecordIdPrefix(String recordIdOrPrefix){
		Boolean DEBUG = false;

        String objectName = '';
        //Get prefix from record ID
        //This assumes that you have passed at least 3 characters
        String myIdPrefix = String.valueOf(recordIdOrPrefix).substring(0,3);
             
        //Get schema information
        if(gd == null) gd =  Schema.getGlobalDescribe(); 
             
        //Loop through all the sObject types returned by Schema
        for(Schema.SObjectType stype : gd.values()){
            Schema.DescribeSObjectResult r = stype.getDescribe();
            String prefix = r.getKeyPrefix();
            if(DEBUG) System.debug('Prefix is ' + prefix);
                 
            //Check if the prefix matches with requested prefix
            if(prefix!=null && prefix.equals(myIdPrefix)){
                objectName = r.getName();
                if(DEBUG) System.debug('Object Name! ' + objectName);
                break;
            }
        }

        return objectName;
    }

}