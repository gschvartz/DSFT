@isTest(SeeAllData=true)
public class TestRestUpsertAccountsDM {
    static testMethod void TestDoPost() {
        
        // set up the request object
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
 
        req.requestURI = '/cstmDMAccountUpsert/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        req.addHeader('Content-Type', 'application/json');
        
        System.debug(LoggingLevel.INFO, 'user:  '+ UserInfo.getUserRoleId());  
                
        MAP<String,String> results = DMAccountUpsert.doPost('456', 'Cuenta Prueba', 'ARG', '4545454', 'algo@prueba.com', 'MULTIBRAND', 'ACTIVE', 'Audi;BMW;Peugeot;Fiat;Renault;Chevrolet', 
        'PRueba Razon Social', '1990-03-26', 'VALIDATED', '333', 'bla bal', 'Nuevos', 
        'MARTIN SANTIAGO', 'ALLEGRA', 'Liniers', 'Liniers', '1408',
        '1408', '30-71124401-0', 'Monotributo', 'aa', 'aa',
        'Capital Federal', 'VALIDACION_PENDIENTE', '11061', '11061', 'LOCAL_TAXPAYER', '4556');
        
        try{
        DMAccountUpsert.doPost('456', 'Cuenta Prueba', 'CHI', '4545454', 'algo@prueba.com', 'MULTIBRAND', 'ACTIVE', 'Audi;BMW;Peugeot;Fiat;Renault;Chevrolet', 
        'PRueba Razon Social', '1990-03-26', 'VALIDATED', '333', 'bla bal', 'Nuevos', 
        'MARTIN SANTIAGO', 'ALLEGRA', 'Liniers', 'Liniers', '1408',
        '1408', '30-71124401-0', 'Monotributo', 'aa', 'aa',
        'Capital Federal', 'VALIDACION_PENDIENTE', '11061', '11061', 'LOCAL_TAXPAYER', '4556');
         }catch (applicationException e) {
            //Assert Error Message
            System.assert(e.getMessage().contains('No es posible modificar el pais de una cuenta existente'),e.getMessage());        
        }       
       
    }
}