@isTest(SeeAllData=true)
public class TestOpportunity {
        static testMethod void testOpportunityTrigger(){

            Account af = new Account(Name='TestAccountFacturador', Negocio__c='DM', dm_idu__c='124565', dm_commercial_status__c='Validado', Estado_de_la_cuenta__c='Activo');
            insert af;            
            Account a = new Account(Name='TestAccount', Negocio__c='DM', dm_commercial_status__c='Validado', dm_Idu_facturador__c=af.dm_idu__c);
            insert a;
            
            Opportunity o = new Opportunity(AccountId=a.id, Name='Prueba Oportunidad', CloseDate=system.today(), Type='Primera compra', 
                                StageName='Negociación / Revisión (70%)', Probability=70, Aprobada__c=false, Condiciones_de_Pago_API__c='Z001', 
                                Comentario_en_factura__c='xxxxx xxxx', from_api__c=false, Estado_Envio__c='Pendiente Envio');
            insert o;
            
            Opportunity testOpportunity = [SELECT Name from Opportunity where Id=:o.Id];
           
            System.assertEquals('Prueba Oportunidad', testOpportunity.Name); 
            
            PriceBookEntry p = [SELECT Id, UnitPrice FROM PriceBookEntry where Product2.unique_external_id__c ='LP-43' and Pricebook2.Name='DM'];
            
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=o.Id, PriceBookEntryId=p.Id, Tipo_Facturacion__c='Total (1 Una)', Quantity=2, UnitPrice=p.UnitPrice, duracion_dias__c='60', fecha_inicio_servicio__c=Date.today().addDays(-1), dm_marcas__c='Alfa Romeo');
            insert oli;
            
            o.StageName = 'Cerrada Ganada (100%)';
            o.Probability = 100;
            o.Aprobada__c = true;
            DMContratacionCallOut.isApexTest = true;
            update o;
        }
}