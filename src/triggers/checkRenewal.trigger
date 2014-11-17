trigger checkRenewal on OpportunityLineItem (before insert, before update) {
    for (OpportunityLineItem oliNew : Trigger.new)
    {
         Opportunity o = [SELECT from_api__c from Opportunity where id=:oliNew.OpportunityId];
         if(o.from_api__c==false){         
             if(oliNew.Tipo_Facturacion__c == 'Abono Mensual' || oliNew.Tipo_Facturacion__c == 'Mensual' || oliNew.Tipo_Facturacion__c == 'Periodica'){
                 oliNew.Autorrenovable__c = true;
             }else{
                 oliNew.Autorrenovable__c = false;
             }
         }
    }
}