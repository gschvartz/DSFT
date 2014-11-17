public class DMContratacionMakeRequest {
    public static Opportunity makeRequest(Opportunity opp){
    
        Account a = [Select dm_idu__c from Account where id=:opp.AccountId];
        Opportunity o = [Select Owner.UserName from Opportunity where Id=:opp.Id];
                     
                    List<OpportunityLineItem> sales = [SELECT Autorrenovable__c, duracion_dias__c, TotalPrice, UnitPrice, Quantity, dm_marcas__c, Discount, cpa_monto_max__c,
                                                        fecha_inicio_servicio__c, PricebookEntry.Product2.Family , PricebookEntry.Product2.external_id__c, Tipo_Facturacion__c 
                                                        FROM OpportunityLineItem where OpportunityId=:opp.Id];            
                                              
                    
                    Map<String,OppObject> jsonRequest = new Map<String,OppObject>(); 
                    OppObject oppobj= new OppObject();
                    
                    List<PublicPack> listadopublicpacks =  new List<PublicPack>();
                    List<ListinPack> listadolistpacks =  new List<ListinPack>();
                    List<AditionalProduct> listadoaditionalproducts =  new List<AditionalProduct>();
                    
                    Decimal totalFacturado = 0;
                    for(OpportunityLineItem oli: sales) {
                   
                        if(oli.PricebookEntry.Product2.Family == 'Pack Publicaciones'){
                                
                                PublicPack pubpack = new PublicPack();
                                
                                pubpack.discountPercentage = string.valueof(oli.Discount);
                                pubpack.durationDays = oli.duracion_dias__c;
                                pubpack.id = oli.PricebookEntry.Product2.external_id__c;
                                pubpack.price = string.valueof(oli.UnitPrice);
                                pubpack.autoRenewal = string.valueof(oli.Autorrenovable__c);
                                pubpack.activationDate = oli.fecha_inicio_servicio__c;
                                pubpack.idLine = oli.Id;
                                
                                listadopublicpacks.add(pubpack); 
                                System.debug(LoggingLevel.INFO, 'publicpack: ' + JSON.serialize(pubpack));
                        }
                        
                        if(oli.PricebookEntry.Product2.Family == 'Pack Listados'){
                                
                                ListinPack listPack = new ListinPack();
                                
                                listPack.discountPercentage = string.valueof(oli.Discount);
                                listPack.durationDays = oli.duracion_dias__c;
                                listPack.id = oli.PricebookEntry.Product2.external_id__c;
                                listPack.price = string.valueof(oli.UnitPrice);
                                listPack.autoRenewal = string.valueof(oli.Autorrenovable__c);
                                List<String> listaMarcas = new List<String>();
                                listaMarcas = oli.dm_marcas__c.split(';');
                                listPack.brands = new List<String>();
                                for(String item : listaMarcas){    
                                    item = item.replace('ë','&euml;');
                                    listPack.brands.add(item);
                                }

                                listPack.activationDate = oli.fecha_inicio_servicio__c;
                                listPack.montoMax = string.valueof(oli.cpa_monto_max__c);
                                listPack.idLine = oli.Id;
                         
                                listadolistpacks.add(listPack);
                                
                                System.debug(LoggingLevel.INFO, 'listpack: ' +  JSON.serialize(listPack));
                        }
                        
                         if(oli.PricebookEntry.Product2.Family == 'Productos Adicionales'){
                                
                                AditionalProduct aditional = new AditionalProduct();
                                
                                aditional.discountPercentage = string.valueof(oli.Discount);
                                aditional.durationDays = oli.duracion_dias__c;
                                aditional.id = oli.PricebookEntry.Product2.external_id__c;
                                aditional.price = string.valueof(oli.UnitPrice);
                                aditional.quantity = string.valueof(Integer.valueOf(oli.Quantity));
                                aditional.activationDate = oli.fecha_inicio_servicio__c;
                                aditional.idLine = oli.Id;
                             
                                
                                System.debug(LoggingLevel.INFO, 'aditional pack: ' +  JSON.serialize(aditional));
                                
                                listadoaditionalproducts.add(aditional);               
                         }
                         //si es facturacion mensual deberia contabilizar en el totalfacturado solo el primer mes
                         //precio unitario - descuento
          
                         if(oli.Tipo_Facturacion__c == 'Mensual'){
                             totalFacturado += oli.UnitPrice * (1 - oli.Discount/100);
                         }else{
                             totalFacturado += oli.TotalPrice;                   
                         }
                         System.debug(LoggingLevel.INFO, 'total facturado: '+totalFacturado );
                         
                    }
                    oppobj.crmSaleId = opp.Id;
                    oppobj.SellerName = o.Owner.UserName;
                    oppobj.userId = a.dm_idu__c;
                    oppobj.paymentConditions = opp.Condiciones_de_Pago_API__c;
                    oppobj.finantialCostsPercentage = '0';
                    oppobj.invoiceNotes = opp.Comentario_en_factura__c;
                    oppobj.billableDate = opp.fecha_de_facturacion_solicitada__c;
                    oppobj.publicationPacks = listadopublicpacks;
                    oppobj.listingPacks = listadolistpacks;
                    oppobj.additionalProducts = listadoaditionalproducts;
                 
                    Http h = new Http();        
                    // Instantiate a new HTTP request, specify the method (GET) as well as the endpoint
                    HttpRequest req = new HttpRequest();
                    
                    //get custom setting value
                    api_send_sale__c api_dm = api_send_sale__c.getInstance('DM');
                    
                    req.setEndpoint(api_dm.Url__c);
                    req.setMethod('POST');
                    req.setHeader('Content-Type', 'application/json');
                    req.setTimeout(120000);
                    req.setBody(JSON.serialize(oppobj));
                        
                        if(!DMContratacionCallOut.isApexTest) {
                            // Send the request, and return a response
                            opp.Estado_Envio__c = 'Enviando';
                            opp.Venta_Enviada_Portal__c = true;                            
                                           
                            try {
                                    HttpResponse res = h.send(req);
                                    //System.debug(LoggingLevel.INFO, 'id: ' +  res.getBody());
                                    
                                    System.debug(LoggingLevel.INFO, 'envio contratacion: ' +  JSON.serialize(oppobj));
                                    
                                    System.debug(LoggingLevel.INFO, 'response: ' + res.getBody());
                                
                                    Pack responseMap = (Pack) System.JSON.deserialize(res.getBody(), Pack.class);
                                    //Map<String,Integer> responseMap = (Map<String,Integer>)JSON.deSerialize(res.getBody(),Map<String,Integer>.class);
                                    
                                    //System.debug(LoggingLevel.INFO, 'saleId: ' + responseMap.get(saleId));
                                    
                                    if(responseMap.saleId != Null){
                                        opp.Estado_Aprobacion__c = 'Aprobada';
                                        opp.Estado_Envio__c = 'Enviado';
                                        opp.Total_Facturado__c= totalFacturado;
                                        opp.Fecha_Venta_Enviada_Portal__c = datetime.now();
                                        opp.Venta_Recibida__c = true;
                                        opp.Fecha_Venta_Recibida__c = datetime.now();
                                        opp.external_sale_id__c = string.valueof(responseMap.saleId);
                                    }
                            } catch (System.CalloutException e) {
                                    opp.Estado_Envio__c = 'Error';
                                    opp.Fecha_Venta_Enviada_Portal__c = datetime.now();
                                    opp.Total_Facturado__c = 0;
                                    System.debug(LoggingLevel.INFO, 'Callout exception: '+e);                                   
                                    //throw new applicationException('Venta de oportunidad:'+ opp.Id +' perteneciente al IDU: '+ a.dm_idu__c +' enviada pero sin respuesta');
                            } catch (System.JSONException e ) {
                                    opp.Estado_Envio__c = 'Envio fallido';
                                    opp.Fecha_Venta_Enviada_Portal__c = datetime.now();
                                    System.debug(LoggingLevel.INFO, 'Json exception: '+e);
                            }
                        }
                        
                 return opp;
    }
}