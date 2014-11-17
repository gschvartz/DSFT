@isTest(SeeAllData=true)
public class TestOpportunityFutureOP {
        static testMethod void testOpportunityOPTrigger(){
            
        Account a = new Account(Name='TestAccount');
        insert a;
        
        Opportunity o = new Opportunity(AccountId=a.id, Name='Prueba Oportunidad', CloseDate=system.today(), Type='Primera compra', StageName='Esperando aprobación (80%)',
                                        Fecha_Aprobacion__c=system.now(), Probability=80, Aprobada__c=false, Cantidad_Facturas__c='3', Numero_Factura__c=1, zp_tipo_de_pago__c='OP');
        insert o;
        
        PriceBookEntry p = [SELECT Id, UnitPrice  FROM PriceBookEntry where Product2.unique_external_id__c ='ZP_125' and Pricebook2.Name = 'ZP Especial'];
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId=o.Id, Autorrenovable__c=false, PricebookEntryId=p.Id, Quantity=2, UnitPrice=p.UnitPrice, duracion_dias__c='90',
                                                            Tipo_Facturacion__c = 'Mensual', fecha_inicio_servicio__c = system.today());
        insert oli1;
        
        o.Probability=100;
        o.Aprobada__c = true;
        o.StageName='Cerrada ganada - Aprobada';
        update o;
        
        
        }
}