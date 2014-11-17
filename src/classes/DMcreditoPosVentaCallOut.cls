public class DMcreditoPosVentaCallOut {

   public static boolean isApexTest = false;
   
   @future (callout=true)
   public static void sendCredit(String id){
            
            credito_pos_venta__c credit = [Select Id, Amount__c, description__c, opportunity_credit__c from credito_pos_venta__c where Id =:id];
                              
            Opportunity opp = [Select external_sale_id__c, Total_Facturado__c from Opportunity where Id=:credit.opportunity_credit__c];     
                         
            Http h = new Http();        
            // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
            HttpRequest req = new HttpRequest();
            
            Map<String,String> body = new Map<String,String>();
            body.put('idVenta' , opp.external_sale_id__c);
            body.put('amount' , string.valueOf(credit.Amount__c));                                                                                                                                                                                                                                                                                                        
            body.put('accrualPeriod' , '1');
            body.put('description' , credit.description__c);
            
            
            //get custom setting value
            api_send_credit__c api_dm = api_send_credit__c.getInstance('DM');
            
            req.setEndpoint(api_dm.Url__c);
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setTimeout(10000);
            req.setBody(JSON.serialize(body));
            
            System.debug(LoggingLevel.INFO, 'envio de credito pos venta:: ' + JSON.serialize(body));
            
           
                if(!DMcreditoPosVentaCallOut.isApexTest) {
                // Send the request, and return a response
                
                credit.Enviado_Portal__c = true;
                System.debug(LoggingLevel.INFO, 'response: ' + credit.Enviado_Portal__c);
                credit.Fecha_Envio_Portal__c = datetime.now();
                System.debug(LoggingLevel.INFO, 'response: ' + credit.Fecha_Envio_Portal__c);
                               
                HttpResponse res = h.send(req);
                
                System.debug(LoggingLevel.INFO, 'response: ' + res.getBody());
                System.debug(LoggingLevel.INFO, 'status: ' + res.getStatus());
                
                //Map<String,String> responseMap = (Map<String,String>)JSON.deSerialize(res.getBody(),Map<String,String>.class);
                
                if(res.getStatus() == 'OK'){ //&& responseMap.get('externalId')!= Null){
                    credit.Recibido_Portal__c = true;
                    credit.Fecha_Recibido_Portal__c = datetime.now();
                    opp.Total_Facturado__c -= credit.Amount__c;
                    update opp;
                    //credit.external_id__c = string.valueof(responseMap.get('externalId'));
                }
                        
                upsert credit;
            }
   }
}