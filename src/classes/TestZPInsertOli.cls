@isTest(SeeAllData=true)
public class TestZPInsertOli {
    static testMethod void TestInsertOli() {
        
            Account a = new Account(Name='TestAccount');
            insert a;
            
            Opportunity o = new Opportunity(AccountId=a.id, Name='Prueba Oportunidad', CloseDate=system.today(), Type='Primera compra', StageName='Negociación / Revisión (70%)', Aprobada__c=true);
            insert o;
            
            PriceBookEntry[] p = [SELECT Id, UnitPrice FROM PriceBookEntry where Product2.unique_external_id__c ='ZP_7'];
            
            OpportunityLineItem oli = new OpportunityLineItem(OpportunityId=o.Id, Tipo_Facturacion__c='Total (1 Una)', PricebookEntryId=p[0].Id, Quantity=1, UnitPrice=p[0].UnitPrice, duracion_dias__c='25');
            
            try{
                insert oli;      
            }catch (DmlException e) {
                //Assert Error Message
                System.assert(e.getMessage().contains('La duracion cargada para este producto es incorrecta'),e.getMessage());        
            }
        
        
    }
    
}