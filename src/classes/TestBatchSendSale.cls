@isTest(SeeAllData=true)
public class TestBatchSendSale {
    static testMethod void testBatch(){
    
        Account a = new Account(Name='TestAccount', dm_idu__c='1234', dm_Idu_facturador__c='1234', Estado_de_la_cuenta__c = 'Activo');
        insert a;
        
        
          for(integer i = 0; i<3; i++){
             Opportunity opp = new Opportunity(AccountId=a.id, Name='Prueba Oportunidad'+i, CloseDate=system.today(), Type='Primera compra', StageName='Negociación / Revisión (70%)', Aprobada__c=true, Condiciones_de_Pago_API__c='Z001', Comentario_en_factura__c='xxxxx xxxx',  fecha_de_facturacion_solicitada__c=system.today()); 
             insert opp;
             PriceBookEntry p = [SELECT Id FROM PriceBookEntry where Product2.unique_external_id__c ='PP-15' and Pricebook2.Name='DM'];
             OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=opp.Id, Autorrenovable__c=false, PricebookEntryId=p.Id, Quantity=2, UnitPrice=595, duracion_dias__c='60');
             insert oli;
             
             opp.Aprobada__c = true;
             opp.Estado_Envio__c='Envio fallido';
             
             opp.Venta_Enviada_Portal__c = true;
             opp.Venta_Recibida__c = false;
             
             upsert opp;
          }
   
            BatchApexSendSales bc = new BatchApexSendSales();
            bc.query = 'SELECT Id, AccountId, Condiciones_de_Pago_API__c, Comentario_en_factura__c, fecha_de_facturacion_solicitada__c FROM Opportunity where Estado_Envio__c = \'Envio fallido\' ';
            
            
            DMContratacionCallOut.isApexTest = true;
            Test.startTest();
            Database.executeBatch(bc);
            Test.stopTest();
          
          
    }
}