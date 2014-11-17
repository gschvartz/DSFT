@isTest(SeeAllData=true)
public class TestRestApiSalesDM {
    static testMethod void TestDoPost() {
        
        // set up the request object
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
 
        req.requestURI = '/cstmDMSalesAPI/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        req.addHeader('Content-Type', 'application/json'); 
       
        PublicPack pp = new PublicPack();
        pp.discountPercentage='10'; 
        pp.durationDays='30'; 
        pp.id='15'; 
        pp.price='120'; 
        pp.autoRenewal='true';
        
        ListinPack lp = new ListinPack();
        lp.discountPercentage='10';
        lp.durationDays='90';
        lp.id='43'; 
        lp.price='150'; 
        lp.autoRenewal='false'; 
        List<String> marcas = new list<String> {'Ford','Peugeot','Chevrolet'};
        lp.brands=marcas;       
        
        List<PublicPack> listpp = new List<PublicPack>();
        listpp.add(pp);
        
        List<ListinPack> listlp = new List<ListinPack>();
        listlp.add(lp);
        
        //caso simple: traigo el idu de una cuenta cuyo idu facturador tiene estado "Activo" 
        Account a1 = [Select dm_idu__c from Account where Estado_de_la_cuenta__c = 'Activo' and Negocio__c='DM' and Country__c='ARG' limit 1];
        Account a = [Select dm_idu__c from Account where dm_Idu_facturador__c =:a1.dm_idu__c limit 1];
       
        //envio venta de productos > 30 dias y facturacion mensual (actualiza TotalFacturado de la oportunidad)
        DMSalesAPI.doPost('2099-12-05', a.dm_idu__c, '5000505', '23', false, '23', listlp, listpp);
                    
        DMSalesAPI.doPost('2099-12-05', a.dm_idu__c, '5000303', '1', true, '23', listlp, listpp);       
        // reenvio la misma venta con el mismo pack y espero el error
        try{
            DMSalesAPI.doPost('2099-12-05', a.dm_idu__c, '5000303', '1', true, '23', listlp, listpp);       
        }catch (applicationException e) {
            //Assert Error Message
            System.assert(e.getMessage().contains('Ya existe una venta'),e.getMessage());        
        }
        
        
    }
    
}