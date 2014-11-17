@isTest(SeeAllData=true)
public class TestProduct {
        static testMethod void testDiscountForOpportunityLineItem(){
        
        Account a = new Account(Name='TestAccount');
        insert a;
        
        Opportunity o = new Opportunity(AccountId=a.id, Name='Prueba Oportunidad', CloseDate=system.today(), Type='Primera compra', StageName='Esperando aprobación (80%)');
        insert o;
        
        PriceBookEntry p = [SELECT Id FROM PriceBookEntry where Product2.unique_external_id__c ='PP-15' and Pricebook2.Name='DM'];
        PriceBookEntry l = [SELECT Id FROM PriceBookEntry where Product2.unique_external_id__c ='LP-43' and Pricebook2.Name='DM'];
        PriceBookEntry ad = [SELECT Id FROM PriceBookEntry where Product2.unique_external_id__c ='AP-1' and Pricebook2.Name='DM'];
        
        
        OpportunityLineItem oli1 = new OpportunityLineItem(OpportunityId=o.Id, Autorrenovable__c=false, PricebookEntryId=p.Id, Quantity=2, UnitPrice=595, duracion_dias__c='60', Discount=10);
        OpportunityLineItem oli2 = new OpportunityLineItem(OpportunityId=o.Id, Autorrenovable__c=false, PricebookEntryId=l.Id, Quantity=1, UnitPrice=2587, duracion_dias__c='30', dm_marcas__c='Acura;Alfa Romeo', Discount=15);

        try{
            insert oli1;
            insert oli2;
        }catch(DmlException e){ 
             System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'), e.getMessage());  
        }

        

                      
        }
}