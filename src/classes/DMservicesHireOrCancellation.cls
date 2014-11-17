@RestResource(urlMapping='/cstmDMservicesHireOrCancellation/*')
global with sharing class DMservicesHireOrCancellation{
    @HttpPost
    global static Map<String,String> doPost(String concept, String idPack, String idSale, String amount, String opType){  

     Map<String,String> response = new Map<String,String> {'saleId'=>idSale, 'packId'=>idPack};
     
     return response;
    }       
}