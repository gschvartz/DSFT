trigger validateDiscount on OpportunityLineItem (before insert, before update) {
    Integer i = 0;
    for (OpportunityLineItem oliNew : Trigger.new)
    {
        OpportunityLineItem[] olis = [SELECT Id, Discount from OpportunityLineItem where OpportunityId =:oliNew.OpportunityId];
             
             if(olis.size() > 0){ 
                 
                 for (OpportunityLineItem oli : olis){
                        
                        if(oliNew.Discount != oli.Discount && oliNew.Id != oli.Id){
                                oliNew.addError('No es posible asignar diferentes descuentos sobre la misma oportunidad');
                        }
                 }
             }         
    }
}