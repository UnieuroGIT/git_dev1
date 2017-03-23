trigger SG_CaseTrigger on Case (after insert, after update, before update, before insert) {

    if(Trigger.isInsert && Trigger.IsAfter){
        SG_CaseTriggerHandler.Case_Insert(Trigger.new);
    }
    
    if(Trigger.isUpdate &&  Trigger.IsAfter){
        SG_CaseTriggerHandler.Case_Update(Trigger.oldMap, Trigger.new);
    }
}