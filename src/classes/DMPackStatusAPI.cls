@RestResource(urlMapping='/cstmDMPackStatusAPI/*')
global with sharing class DMPackStatusAPI{
    @HttpPost
    global static Map<String,String> doPost(String saleId, String packId, String uniqueProductId, String packStatus, String changeDate){  
    
     Map<String,String> response = new Map<String,String> {'saleId'=>saleId, 'packId'=>packId};
     
     return response;
    }       
}