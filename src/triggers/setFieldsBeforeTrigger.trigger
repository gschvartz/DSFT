trigger setFieldsBeforeTrigger on OpportunityLineItem (before insert, before update) {
    for (OpportunityLineItem oliNew : Trigger.new)
    {       
            
            //System.debug(LoggingLevel.INFO, 'Opp Nombre: ' + oliNew.Opportunity.get(ID_Propuesta__c));
            Opportunity o = [Select from_api__c ,Tipo_Facturacion__c, Org_Vta__c from Opportunity where Id =:oliNew.OpportunityId];
            
            /*
            *trigger para ZP MEX y ZP COL
            *arrastro de oportunidad tipo de facturacion y  calculo de duracion dias
            *
            */
            if(o.Org_Vta__c=='COL-ZP' || o.Org_Vta__c=='MEX-ZP' || o.Org_Vta__c=='ARG-ZP'){
                        PricebookEntry pe = [SELECT Product2.duracion__c from PricebookEntry where Id=:oliNew.PricebookEntryId];
                        //System.debug(LoggingLevel.INFO, 'Duracion Catalogo: ' + pe.Product2.duracion__c)
                        oliNew.Tipo_Facturacion__c = o.Tipo_Facturacion__c;
                        
                        if(o.from_api__c==false){         
                             if(oliNew.Tipo_Facturacion__c == 'Periodica'){
                                 oliNew.devengamiento_facturacion__c = 30;
                                 if(oliNew.Quantity!=1){
                                     oliNew.Cantidad__c = math.abs(oliNew.Quantity);
                                 }
                                 oliNew.Quantity = 1;
                                 if(oliNew.Cantidad__c==null){ 
                                    oliNew.duracion_dias__c = String.valueOf(pe.Product2.duracion__c);
                                 }else{
                                    oliNew.duracion_dias__c = String.valueOf(oliNew.Cantidad__c * pe.Product2.duracion__c);
                                 }
                                 
                                 
                             }else{
                                 oliNew.Cantidad__c = math.abs(oliNew.Quantity);
                                 oliNew.duracion_dias__c = String.valueOf(oliNew.Cantidad__c * pe.Product2.duracion__c);
                                 oliNew.devengamiento_facturacion__c =  Integer.valueOf(oliNew.duracion_dias__c);
                             }
                      }
                      
            }
            
            if(o.Org_Vta__c=='ARG-ZJ'){

                        PricebookEntry pe = [SELECT Product2.duracion__c, Product2.valor_cantidad__c, Product2.validacion_cantidad__c, UnitPrice
                        from PricebookEntry where Id=:oliNew.PricebookEntryId];
  
                        if(pe.Product2.validacion_cantidad__c == 'Fija' && oliNew.Quantity!= pe.Product2.valor_cantidad__c){
                            oliNew.addError('Segun definicion del Producto la cantidad debe ser ' + pe.Product2.valor_cantidad__c); 
                        }
                        if(pe.Product2.validacion_cantidad__c == 'Mayor' && oliNew.Quantity < pe.Product2.valor_cantidad__c){
                            oliNew.addError('Segun definicion del Producto la cantidad debe ser mayor o igual a ' + pe.Product2.valor_cantidad__c);   
                        }
                        /*    
                        if(Trigger.isInsert){  
                            oliNew.cantidad__c = math.abs(oliNew.Quantity);
                            oliNew.UnitPrice= oliNew.UnitPrice * oliNew.Duracion__c / pe.Product2.duracion__c;
                        }    
                                             
                        if(Trigger.isUpdate ){                        
                            oliNew.Quantity= oliNew.Quantity * oliNew.Duracion__c / pe.Product2.duracion__c;
                        }
                        */

            }
                      
    }
}