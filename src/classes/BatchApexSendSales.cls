global class BatchApexSendSales implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts {

    public String query = 'SELECT Id, AccountId, Condiciones_de_Pago_API__c, Comentario_en_factura__c FROM Opportunity where Estado_Envio__c = \'Envio fallido\' ';

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }   
            
    global void execute(Database.BatchableContext BC, List<Opportunity> scope){
         List<Opportunity> listopp = new List<Opportunity>();
         for(Opportunity opp : scope){
            System.debug(LoggingLevel.INFO, 'Reenvio Oportunidad: '+ opp.Id);
            
            DMContratacionMakeRequest.makeRequest(opp);
            listopp.add(opp);
        }
        if(!DMContratacionCallOut.isApexTest) {
            update listopp;
        }
    }
    
    global void finish(Database.BatchableContext BC){
       //nothing     
    }
    
}