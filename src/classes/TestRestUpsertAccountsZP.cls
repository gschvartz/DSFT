@isTest(SeeAllData=true)
public class TestRestUpsertAccountsZP {
    static testMethod void TestDoPost() {
        
        // set up the request object
        
        RestRequest req = new RestRequest(); 
        RestResponse res = new RestResponse();
 
        req.requestURI = '/cstmZPAccountUpsert/';
        req.httpMethod = 'POST';
        RestContext.request = req;
        RestContext.response = res;
        req.addHeader('Content-Type', 'application/json');
        
        System.debug(LoggingLevel.INFO, 'user:  '+ UserInfo.getUserRoleId());  
                
        MAP<String,String> results = ZPAccountUpsert.doPost('Cuenta Prueba','AGENCY','2014-05-21','1015',
        'http://www.google.com','ACTIVE','Guillermo','Schvartz','44445555','115487965','gschvartz@dridco.com',
        'VALIDATED','Buenos Aires','Maipu 942','1021','Prueba S.A.','30-25698784-6','RESPONSABLE_INSCRIPTO',
        'Buenos Aires','CABA','Saraza 154','2056','CONVENIO_MULTILATERAL','A1BXXX','VALIDADO','ARG');  
    }
}