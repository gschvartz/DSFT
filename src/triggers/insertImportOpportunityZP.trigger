trigger insertImportOpportunityZP on Opportunity(before insert) {
    for (Opportunity oliNew : Trigger.new)
    {
        User u = [Select Negocio__c from User where Id=:oliNew.OwnerId];
        if(oliNew.from_api__c==true && u.Negocio__c == 'ZP'){ // y el negocio de la cuenta es ZP
            
            //reviso si el registro es duplicado                                                                    
        }
    }
}