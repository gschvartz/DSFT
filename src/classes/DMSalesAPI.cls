@RestResource(urlMapping='/cstmDMSalesAPI/*')
global with sharing class DMSalesAPI{
    @HttpPost
    global static Map<String,String> doPost(String purchaseDate, String userId, String saleId, String dmOriginSaleId, Boolean selfService,
                                String packId, List<ListinPack> listingPack, List<PublicPack> publicationPack){  

    System.debug(LoggingLevel.INFO, 'purchaseDate: ' + purchaseDate);
    System.debug(LoggingLevel.INFO, 'userId: ' + userId);
    System.debug(LoggingLevel.INFO, 'saleId: ' + saleId);
    System.debug(LoggingLevel.INFO, 'dmOriginSaleId: ' + dmOriginSaleId);
    System.debug(LoggingLevel.INFO, 'selfService: ' + selfService);
    System.debug(LoggingLevel.INFO, 'packId: ' + packId);
    System.debug(LoggingLevel.INFO, 'List<ListinPack>: ' + listingPack);
    System.debug(LoggingLevel.INFO, 'List<PublicPack>: ' + publicationPack);    
    
      
    Opportunity[] validateSale = [SELECT Id, SitePacksId__c, Total_Facturado__c, external_sale_id__c From Opportunity where external_sale_id__c=:saleId];
    Account a = [SELECT Id, OwnerId, Owner.UserName, Country__c, CurrencyIsoCode from Account where dm_idu__c=:userId];
    
    if(validateSale.size()>0){
        //existe la venta
        Opportunity existOpp = validateSale[0];
   
            //venta autogestionada enviada en partes (se imputan los packs en momentos distintos)
            if(String.isNotBlank(existOpp.SitePacksId__c)){
                System.debug(LoggingLevel.INFO, 'packsId: ' + existOpp.SitePacksId__c ); 
                String[] arrSitePacks = existOpp.SitePacksId__c.split(',');
                for (String sitePackId : arrSitePacks ){
                    //System.debug(LoggingLevel.INFO, 'pack: ' + sitePackId  );
                    if(sitePackId == packId){
                        //envio repetido
                        throw new applicationException('Ya existe una venta: '+existOpp.Id+' con el saleId: '+saleId+' y IdPack = '+packId);
                    }// sino creo oportunidad nueva 
                }
            }
            Boolean isCpa = false;    
            if(listingPack.size() > 0){
                Product2 lp = [SELECT cpa__c from Product2 where unique_external_id__c=:'LP-'+listingPack[0].id];
                isCpa = lp.cpa__c;    
            }
        
        
        if(selfService==false && isCpa==false){
            //notificacion de venta con producto > 30 dias con facturacion mensual: actualizo Oportunidad existente
            existOpp.SitePacksId__c += ','+packId;
            //System.debug(LoggingLevel.INFO, 'facturado: ' + existOpp.Total_Facturado__c );
            //recorre listado de packs y suma el total facturado en Total_Facturado__c a lo que ya estaba: primer envio de CRM
            if(publicationPack.size()>0){
                for (PublicPack publicpack : publicationPack){
                    existOpp.Total_Facturado__c +=  Decimal.valueOf(publicpack.price);
                }
            }
            if(listingPack.size()>0){
                for (ListinPack listpack : listingPack){
                    existOpp.Total_Facturado__c +=  Decimal.valueOf(listpack.price);
                }
            }
            update existOpp;
            Map<String,String> response = new Map<String,String> {'saleId'=>existOpp.external_sale_id__c, 'sellerName'=>a.Owner.UserName};
            return response;
        }
        
    }
    
    Account[] validateAccount = [SELECT Id From Account where dm_idu__c=:userId];
    if(validateAccount.size()==0){
        throw new applicationException('No existe la cuenta con IDU: '+userId);
    }
    
    //creo oportunidad nueva ya sea por autogestion desde sitio o por autorenovacion
    
    String text_name = 'Compra Autogestionada';    
    
    
    String[] stringDate = purchaseDate.split('-');
    Integer y =  Integer.valueOf(stringDate[0]);
    Integer m = Integer.valueOf(stringDate[1]);
    Integer d = Integer.valueOf(stringDate[2]);
    String fecha = d+'/'+m+'/'+y;
    
    Opportunity o = new Opportunity();
    o.AccountId = a.Id;
    o.Name = text_name;
    o.OwnerId = a.OwnerId;
    o.CurrencyIsoCode = a.CurrencyIsoCode;    
    o.StageName = 'Esperando aprobación (80%)';
    o.Aprobada__c = true;
    o.Estado_Aprobacion__c = 'Aprobada';
    o.CloseDate = date.parse(fecha);
    o.Fecha_Aprobacion__c = datetime.now();
    o.Origin_sale_id__c = dmOriginSaleId;
    o.self_service__c = selfService;
    o.external_sale_id__c = saleId;
    o.from_api__c = true;
    System.debug(LoggingLevel.INFO, 'from api: ' + o.from_api__c  );
    o.Fecha_Venta_Recibida__c = datetime.now();
    o.Venta_Recibida__c = true;
    
    //atajo exception si la autogestion es de un usuario con licencia no activa y lo reasigno
    try{
        insert o;
    }catch (System.DmlException e) {
        if(e.getMessage().contains('INACTIVE_OWNER_OR_USER')){
            User[] u = [SELECT Id from User where UserRole.Name =: a.Country__c+'-DM Gerente Comercial'];
            o.OwnerId = u[0].Id;
            insert o;
        }
        System.debug(LoggingLevel.INFO, 'Error: ' + e.getMessage());    
    }
      
      if(publicationPack.size()>0){
        for (PublicPack publicpack : publicationPack){
    
             OpportunityLineItem oli = new OpportunityLineItem();         
             PriceBookEntry p = [SELECT Id FROM PriceBookEntry where Product2.unique_external_id__c =:'PP-'+publicpack.id and Pricebook2.Name='DM'];  
             o.from_api__c = true;
             update o;
             oli.OpportunityId = o.Id;
             oli.PricebookEntryId = p.Id;
             oli.Discount = Decimal.valueOf(publicpack.discountPercentage);
             oli.duracion_dias__c = publicpack.durationDays;
             oli.Autorrenovable__c = Boolean.valueOf(publicpack.autoRenewal);
             oli.fecha_inicio_servicio__c = date.today();
             oli.Quantity =  Decimal.valueOf(publicpack.durationDays) / 30;
             oli.UnitPrice = Decimal.valueOf(publicpack.price) / oli.Quantity;
             o.SitePacksId__c += ','+packId;
             
             System.debug(LoggingLevel.INFO, 'from api: ' + o.from_api__c  );
             insert oli;
         }
     }
     
     if(listingPack.size()>0){
         for (ListinPack listpack : listingPack){
    
             OpportunityLineItem oli = new OpportunityLineItem();         
             PriceBookEntry p = [SELECT Id FROM PriceBookEntry where Product2.unique_external_id__c =:'LP-'+listpack.id and Pricebook2.Name='DM'];
             
             o.from_api__c = true;
             update o;
             oli.OpportunityId = o.Id;
             oli.PricebookEntryId = p.Id;
             oli.Discount = Decimal.valueOf(listpack.discountPercentage);
             oli.duracion_dias__c = listpack.durationDays;
             oli.Autorrenovable__c = Boolean.valueOf(listpack.autoRenewal);
             oli.dm_marcas__c = '';
             Integer i = 1;
             for(String item : listpack.brands){
                 oli.dm_marcas__c += item;    
                 if(i != listpack.brands.size()){
                     oli.dm_marcas__c += ';';
                 }
                 i++;
             }
             oli.fecha_inicio_servicio__c = date.today();
             oli.Quantity =  Decimal.valueOf(listpack.durationDays) / 30;
             oli.UnitPrice = Decimal.valueOf(listpack.price) / oli.Quantity;
             o.SitePacksId__c += ','+packId;
             
             System.debug(LoggingLevel.INFO, 'from api: ' + o.from_api__c  );
             insert oli;
         }
     }
     
     
     //Opportunity opp = [SELECT id FROM Opportunity where Id=:o.Id];
     o.StageName = 'Cerrada ganada - Aprobada';
     update o;
     
     Map<String,String> response = new Map<String,String> {'saleId'=>o.external_sale_id__c, 'sellerName'=>a.Owner.UserName};
     
     return response;
    }       
}