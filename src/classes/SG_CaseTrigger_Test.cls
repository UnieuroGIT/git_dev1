@isTest
public class SG_CaseTrigger_Test 
{ 
    static testMethod void test_Insert(){
        Case Ncase = new Case();
        Ncase.subject= 'test Case';
        Ncase.Genera_RMA__c=TRUE;
    
        Test.startTest();
        insert Ncase;
        Ncase.Genera_RMA__c=FALSE;
        update Ncase;
        Ncase.Genera_RMA__c=TRUE;
        update Ncase;
        Test.stopTest();
    }
}