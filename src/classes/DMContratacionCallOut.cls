public class DMContratacionCallOut {

   public static boolean isApexTest = false;
   
   @future(callout=true)

   public static void sendContratacion(String id){
            
            Opportunity opp = [Select Id, AccountId, Condiciones_de_Pago_API__c, Comentario_en_factura__c,
                              fecha_de_facturacion_solicitada__c, Total_Facturado__c from Opportunity where id=:id];     
            
            Opportunity updateOpp = DMContratacionMakeRequest.makeRequest(opp);
            
            update updateOpp;
   }
}