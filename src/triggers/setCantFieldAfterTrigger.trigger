trigger setCantFieldAfterTrigger on OpportunityLineItem (after insert, after update) {
    for (OpportunityLineItem oliNew : Trigger.new)
    {        
            

            
            System.debug(LoggingLevel.INFO, 'entro');
            Opportunity o = [Select from_api__c ,Tipo_Facturacion__c, Org_Vta__c from Opportunity where Id =:oliNew.OpportunityId];
            
            /*
            *trigger para ZP MEX y ZP COL
            *arrastro de oportunidad tipo de facturacion y  calculo de duracion dias
            *
            */
            
            OpportunityLineItem oli = [SELECT Tipo_Facturacion__c,Quantity, cantidad__c, PricebookEntry.Product2.duracion__c, duracion_dias__c from OpportunityLineItem where Id=:oliNew.Id];
            
            if(o.Org_Vta__c=='COL-ZP' || o.Org_Vta__c=='MEX-ZP' || o.Org_Vta__c=='ARG-ZP'){
                  if(o.from_api__c==false){         
                         if(oli.Tipo_Facturacion__c == 'Abono Mensual' || oli.Tipo_Facturacion__c == 'Mensual' || oli.Tipo_Facturacion__c == 'Periodica'){
                             oli.Quantity = 1;
                             update oli;
                         }
                  }
            }
            
    }
}