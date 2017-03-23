trigger SG_Contact on Contact (after update) {
    
    if(SG_AvoidRecursion.isFirstRun()){

        system.debug('msozzi:trigger partito!');
        Id accid = Trigger.new[0].AccountId;    //assign AccountId of list Trigger.new in a variable accid
        Id cid = Trigger.new[0].Id;             //assign Id of list Trigger.new in a variable cid
        
        
        //update that modify from Contact to Account 
        if(trigger.new[0].primary__c){
            Account Acc = [ SELECT name, Email__c FROM Account WHERE id = :accid][0];
            acc.name    =   trigger.new[0].firstname;
            acc.Email__c=   trigger.new[0].email;
            update acc;
        }
        
        //Define a list for all contact but not where i modifyed 
        list <Contact> tuttiGliAltri = [SELECT id, Primary__c FROM Contact WHERE AccountId = :accid and id != :cid];
        
        //set Primary__c= false for all contact
        for(Contact con : tuttiGliAltri){
            con.Primary__c=FALSE;
        }

        update tuttiGliAltri;
    }
  
   
    
}