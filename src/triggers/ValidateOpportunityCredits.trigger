trigger ValidateOpportunityCredits on credito_pos_venta__c (before insert) {
    for (credito_pos_venta__c credit : Trigger.new)
    {
        Opportunity opp = [SELECT Id, importe_credito_pos_venta__c, Amount from Opportunity where Id=:credit.opportunity_credit__c];
        
        if(opp.importe_credito_pos_venta__c == null ){ 
            opp.importe_credito_pos_venta__c = 0; 
        }
        
        if(opp.importe_credito_pos_venta__c +  credit.Amount__c > opp.Amount){    
           credit.addError('NO ES POSIBLE SUPERAR CON CREDITOS POS VENTA EL TOTAL DE LA OPORTUNIDAD');
        }else{
            opp.importe_credito_pos_venta__c += credit.Amount__c;
            update opp;
        }
        
    }
}