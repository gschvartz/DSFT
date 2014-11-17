@isTest(SeeAllData=true)
public class TestOpportunityLineItem {
        static testMethod void testOpportunityLineItemTrigger(){
            
            Account a = new Account(Name='TestAccount');
            insert a;
            
            Opportunity o = new Opportunity(AccountId=a.id, Name='Prueba Oportunidad', CloseDate=system.today(), Type='Primera compra', StageName='Negociación / Revisión (70%)', Aprobada__c=true, Condiciones_de_Pago_API__c='Z001', Comentario_en_factura__c='xxxxx xxxx');
            insert o;
            
            PriceBookEntry p = [SELECT Id FROM PriceBookEntry where Product2.unique_external_id__c ='PP-15' and Pricebook2.Name='DM'];
            
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=o.Id, Tipo_Facturacion__c='Total (1 Una)', PricebookEntryId=p.Id, Quantity=2, UnitPrice=595, duracion_dias__c='60');
            insert oli;
            
            OpportunityLineItem testOpportunityLineItem  = [SELECT Id, Pais__c, Negocio__c, PricebookEntry.Product2.Pais_del__c, PricebookEntry.Product2.Negocio__c From OpportunityLineItem WHERE Id = :oli.Id];
             
            System.assertEquals(testOpportunityLineItem.PricebookEntry.Product2.Pais_del__c, testOpportunityLineItem.Pais__c);
            System.assertEquals(testOpportunityLineItem.PricebookEntry.Product2.Negocio__c, testOpportunityLineItem.Negocio__c); 
        }
}