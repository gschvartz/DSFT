trigger SendOpportunityCredit on credito_pos_venta__c (after insert) {
    if(!System.isFuture()){
        for (credito_pos_venta__c credit : Trigger.new)
        {
            DMcreditoPosVentaCallOut.sendCredit(credit.Id); 
        }
    }
}