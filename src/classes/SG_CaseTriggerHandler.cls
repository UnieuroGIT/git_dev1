public class SG_CaseTriggerHandler {
    public static void Case_Insert (List <Case> Casi){
    List <Case> Case_Child = new List <Case> (); 
        for (Case C: Casi){
         if(C.Genera_RMA__c){
             Case_Child.add(new Case(Parentid=C.id, Type='RMA', Subject=C.Subject +'RMA'));
         }
         insert Case_Child;
       }
    }
    public static void Case_Update (Map<ID, Case> CaseOld, List<Case> CaseNew){
        List<Case> Case_Child = new List <Case> ();
         for(Case C: CaseNew){
            if(C.Genera_RMA__c==TRUE  && CaseOld.get(C.ID).Genera_RMA__c==FALSE ){
                Case_Child.add(new Case(Parentid=C.id, Type='RMA', Subject=C.Subject +'RMA'));
                }
                insert Case_Child;
            }
    system.debug('Federica'+Case_Child);
    }
    
}