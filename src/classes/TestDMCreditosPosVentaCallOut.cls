@isTest(SeeAllData=true)
private class TestDMCreditosPosVentaCallOut {

    static testMethod void testFutureCallSuccess(){
        User u = [SELECT Id from User where Alias='gschv'];
        
        Account a = new Account(dm_idu__c='101010', Name='TestAccount', OwnerId=u.Id);
        insert a;
        
        Opportunity o = new Opportunity(AccountId=a.id, Name='Prueba Oportunidad', CloseDate=system.today(), Type='Primera compra', StageName='Esperando aprobación (80%)', Aprobada__c=true, Condiciones_de_Pago_API__c='Z001', Comentario_en_factura__c='xxxxx xxxx');
        insert o;
        
        PriceBookEntry p = [SELECT Id FROM PriceBookEntry where Product2.unique_external_id__c ='PP-15' and Pricebook2.Name='DM'];
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId=o.Id, Autorrenovable__c=false, PricebookEntryId=p.Id, Quantity=2, UnitPrice=595, duracion_dias__c='60');
        insert oli1;
        
        Opportunity opp = [SELECT Id, StageName, Venta_Enviada_Portal__c, Venta_Recibida__c FROM Opportunity where Id=:o.Id];
        opp.StageName='Cerrada ganada (100%)';
        opp.Venta_Enviada_Portal__c = true;
        opp.Venta_Recibida__c = true;
        update opp;
        
        credito_pos_venta__c credit = new credito_pos_venta__c(opportunity_credit__c=o.Id, Name='Test', Amount__c=100, description__c='descripcion');
        insert credit;
        
        DMcreditoPosVentaCallOut.isApexTest = true;
        Test.startTest();
            DMcreditoPosVentaCallOut.sendCredit(credit.Id);
        Test.stopTest();
    }
}