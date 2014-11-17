trigger validateDuration on OpportunityLineItem (before insert, before update) {
    for (OpportunityLineItem oliNew : Trigger.new)
    {
        
        if(oliNew.Opportunity.Org_Vta__c == 'ARG-ZP'){
            
            OpportunityLineItem oli = [Select PricebookEntry.Product2.duracion__c from OpportunityLineItem where Id =: oliNew.Id];
            
            if(oli.PricebookEntry.Product2.duracion__c!=null && (integer.valueof(oliNew.duracion_dias__c) != oli.PricebookEntry.Product2.duracion__c)){
                oliNew.addError('La duracion cargada para este producto es incorrecta. Debe ser igual a la duracion que figura en el catalogo del producto en cuestion.');
            }
        }         
    }
}