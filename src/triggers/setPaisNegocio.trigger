trigger setPaisNegocio on OpportunityLineItem (after insert, after update) {
    Integer i = 0;
    for (OpportunityLineItem oliNew : Trigger.new)
    {
        OpportunityLineItem oliAux = new OpportunityLineItem();
        OpportunityLineItem prodData  = [SELECT Id, PricebookEntry.Product2.Pais_del__c, PricebookEntry.Product2.Negocio__c From OpportunityLineItem WHERE Id = :oliNew.Id];
        oliAux.Id = prodData.Id;
        oliAux.Pais__c = ProdData.PricebookEntry.Product2.Pais_del__c;
        oliAux.Negocio__c = ProdData.PricebookEntry.Product2.Negocio__c;
        if(Trigger.isUpdate) {
            if(oliAux.Negocio__c != Trigger.Old[i].Negocio__c || oliAux.Pais__c != Trigger.Old[i].Pais__c ) {
                update oliAux;
            }
        }else{
                try{
                    update oliAux;
                }catch (System.DmlException e) {
                        oliNew.addError(e);
                }
        }
        i++;
     }
}