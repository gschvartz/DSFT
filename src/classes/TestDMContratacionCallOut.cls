@isTest(SeeAllData=true)
private class TestDMContratacionCallOut {

    static testMethod void testFutureCallSuccess(){
        User u = [SELECT Id from User where Alias='gschv'];
        
        Account a = new Account(dm_idu__c='101010', Name='TestAccount', OwnerId=u.Id);
        insert a;
        
        Opportunity o = new Opportunity(AccountId=a.id, Name='Prueba Oportunidad', CloseDate=system.today(), Type='Primera compra', StageName='Esperando aprobación (80%)', Aprobada__c=true, Condiciones_de_Pago_API__c='Z001'/*, Comentario_en_factura__c='xxxxx xxxx'*/);
        insert o;
        
        PriceBookEntry p = [SELECT Id FROM PriceBookEntry where Product2.unique_external_id__c ='PP-15' and Pricebook2.Name='DM'];
        PriceBookEntry l = [SELECT Id FROM PriceBookEntry where Product2.unique_external_id__c ='LP-43' and Pricebook2.Name='DM'];
        PriceBookEntry ad = [SELECT Id FROM PriceBookEntry where Product2.unique_external_id__c ='AP-1' and Pricebook2.Name='DM'];
                
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId=o.Id, Autorrenovable__c=false, PricebookEntryId=p.Id, Quantity=2, UnitPrice=595, duracion_dias__c='60');
        insert oli1;
        
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId=o.Id, Autorrenovable__c=false, PricebookEntryId=l.Id, Quantity=1, UnitPrice=2587, duracion_dias__c='30', dm_marcas__c='Acura;Alfa Romeo');
        insert oli2;
        
        OpportunityLineItem oli3 = new OpportunityLineItem(OpportunityId=o.Id, Autorrenovable__c=false, PricebookEntryId=ad.Id, Quantity=2, UnitPrice=1190, duracion_dias__c='60');
        insert oli3;

        Opportunity opp = [SELECT Id, StageName FROM Opportunity where Id=:o.Id];
        opp.StageName='Cerrada ganada (100%)';
        update opp;
        
        //OpportunityLineItem[] oppitem = [SELECT PricebookEntry.UnitPrice, Id, Quantity, ListPrice, TotalPrice  from OpportunityLineItem where Id = :oli.Id];
        
        String StrEndPoint = 'http://dmapiq.demotores.com/backend/rest/crm/hire.service';
        DMContratacionCallOut.isApexTest = true;
        Test.startTest();
            DMContratacionCallOut.sendContratacion(o.Id);
            //System.assertEquals(oppitem[0].PricebookEntry.UnitPrice*oppitem[0].Quantity,oppitem[0].TotalPrice);
        Test.stopTest();
    }
}