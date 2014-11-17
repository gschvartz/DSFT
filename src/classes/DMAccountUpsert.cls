@RestResource(urlMapping='/cstmDMAccountUpsert/*')
global with sharing class DMAccountUpsert{

   @HttpPost
    global static Map<String,String> doPost(String idu, String name, String country, String phone, String email, String tipo_empresa, String estado_cuenta, String marcas, 
    String razon_social, String fecha_registro, String status_comercial, String idu_matriz, String estado_comercial, String rubro_principal, 
    String first_name, String last_name, String ciudad_comercial, String ciudad_facturacion, String cod_postal_comercial,
    String cod_postal_facturacion, String codigo_fiscal, String condicion_tributaria, String domicilio_comercial, String domicilio_facturacion,
    String estado_facturacion, String estado_fiscal, String nro_domicilio_comercial, String nro_domicilio_facturacion, String situacion_iibb, String billableUserId){ 
       
        System.debug(LoggingLevel.INFO, 'tipo_empresa:' + tipo_empresa);
        System.debug(LoggingLevel.INFO, 'estado_cuenta:' + estado_cuenta);
        System.debug(LoggingLevel.INFO, 'status_comercial:' + status_comercial);
        System.debug(LoggingLevel.INFO, 'estado_fiscal:' + estado_fiscal);
        System.debug(LoggingLevel.INFO, 'situacion_iibb:' + situacion_iibb);
       
        String defNegocio = 'DM'; 
        
        String external_ID = defNegocio+'_'+idu;    
        
        Map<String,String> currency_code = new Map<String,String> {'ARG' => 'ARS',
                                                                    'CHI' => 'CLP',
                                                                    'VEN' => 'VEF',
                                                                    'BRA' => 'BRL',
                                                                    'MEX' => 'MXN',
                                                                    'COL' => 'COP',
                                                                    'PER' => 'PEN',
                                                                    'ESP' => 'EUR',
                                                                    'ECU' => 'ECS'};
        Map<String,Map<String,String>> currency_map = new Map<String,Map<String,String>>{country => currency_code};
        
        Map<String,String> tipo_empresa_code = new Map<String,String> {'MULTIBRAND' => 'Multimarca',
                                                                        'OFFICIAL' => 'Oficial'};
        Map<String,Map<String,String>> tipo_empresa_map = new Map<String,Map<String,String>>{tipo_empresa => tipo_empresa_code};                                                                       
                
        Map<String,String> estado_cuenta_code = new Map<String,String> {'ACTIVE' => 'Activo',
                                                                        'PENDING' => 'Pendiente de Confirmacion',
                                                                        'DISABLED' => 'Inhabilitado',
                                                                        'SUSPENDED' => 'Suspendido'};

        Map<String,Map<String,String>> estado_cuenta_map = new Map<String,Map<String,String>>{estado_cuenta => estado_cuenta_code};                                                                                      

        Map<String,String> status_comercial_code = new Map<String,String> {'VALIDATED' => 'Validado',
                                                                        'TO_VALIDATE' => 'Pendiente de Validacion',
                                                                        'DEBTOR' => 'Suspendido por Mora'};
        Map<String,Map<String,String>> status_comercial_map = new Map<String,Map<String,String>>{status_comercial => status_comercial_code}; 

        Map<String,String> estado_fiscal_code = new Map<String,String> {'VALIDACION_PENDIENTE' => 'Pendiente de Validacion',
                                                                        'VALIDADO' => 'Validado'};
        Map<String,Map<String,String>> estado_fiscal_map = new Map<String,Map<String,String>>{estado_fiscal => estado_fiscal_code};                                                                             

        Map<String,String> situacion_iibb_code = new Map<String,String> {'LOCAL_TAXPAYER' => 'Contribuyente Local',
                                                                        'MULTILATERAL_AGREEMENT' => 'Convenio Multilateral',
                                                                        'NOT_REGISTERED' => 'Exento'};
        Map<String,Map<String,String>> situacion_iibb_map = new Map<String,Map<String,String>>{situacion_iibb => situacion_iibb_code};
                                                                          
        
         List<String> requiredFields = new List<String> {   name,
                                                            razon_social,
                                                            fecha_registro,
                                                            string.valueof(idu),
                                                            estado_cuenta,
                                                            status_comercial,
                                                            tipo_empresa,
                                                            email,
                                                            estado_fiscal,
                                                            condicion_tributaria,
                                                            country,
                                                            estado_comercial,
                                                            ciudad_comercial,
                                                            domicilio_comercial,
                                                            last_name,
                                                            first_name,
                                                            situacion_iibb};
         for(String key: requiredFields){
             if(String.isEmpty(key)){
                    throw new applicationException('Falta campo requerido');
             }
         } 
        
         List<Map<String,Map<String,String>>> listvalues = new List<Map<String,Map<String,String>>>{currency_map,tipo_empresa_map,estado_cuenta_map,status_comercial_map,estado_fiscal_map,situacion_iibb_map};
                                                                                                       
        for(Map<String,Map<String,String>> item: listvalues){
              for (string theKey:item.keySet()){
                    //System.debug(LoggingLevel.INFO, 'a buscar:' + theKey);
                    //System.debug(LoggingLevel.INFO, 'mapa:' + item.get(theKey));
                    
                    if(String.isEmpty(item.get(theKey).get(theKey))){
                        System.debug(LoggingLevel.INFO, 'error al buscar' + theKey);
                        throw new applicationException('No coincide '+theKey+' con los posibles valores permitidos');
                    }
                }
        }   
           
        String[] stringDate = fecha_registro.split('-');
        Integer y =  Integer.valueOf(stringDate[0]);
        Integer m = Integer.valueOf(stringDate[1]);
        Integer d = Integer.valueOf(stringDate[2]);
        String fecha = d+'/'+m+'/'+y;
        
                                                                    
        Account a = new Account();
        a.ID_Externo__c = external_ID;
        a.dm_idu__c = idu;
        a.Name = name;
        a.Country__c = country;
        a.CurrencyIsoCode = currency_code.get(country);
        a.Negocio__c = defNegocio;
        a.Phone = phone ;
        a.Correo_Electronico__c = email;
        a.dm_tipo_empresa__c = tipo_empresa_code.get(tipo_empresa);
        a.Estado_de_la_cuenta__c = estado_cuenta_code.get(estado_cuenta);
        a.dm_marcas__c = marcas;
        a.Razon_Social__c = razon_social;
        a.fecha_registro__c = date.parse(fecha);
        a.dm_commercial_status__c = status_comercial_code.get(status_comercial);
        a.dm_idu_matriz__c = idu_matriz;
        a.SHIPPINGSTATE = estado_comercial;
        a.dm_rubro_principal__c = rubro_principal;
        a.SHIPPINGSTREET = domicilio_comercial+' '+nro_domicilio_comercial;
        a.BILLINGSTREET = domicilio_facturacion+' '+nro_domicilio_facturacion;
        a.BILLINGCITY = ciudad_facturacion;
        a.SHIPPINGCITY = ciudad_comercial;
        a.Nro_Id_Tributaria__c = codigo_fiscal;
        a.SHIPPINGPOSTALCODE = cod_postal_comercial;
        a.BILLINGPOSTALCODE = cod_postal_facturacion;
        a.Condicion_de_IVA__c = condicion_tributaria;
        a.BILLINGSTATE = estado_facturacion;
        a.estado_fiscal__c = estado_fiscal_code.get(estado_fiscal);
        a.Ingresos_Brutos__c = situacion_iibb_code.get(situacion_iibb);
        a.dm_Idu_facturador__c = billableUserId;
        
        Account[] existaccount = [SELECT Id, OwnerId, Country__c, Negocio__c From Account where ID_Externo__c=:external_ID];
        if(existaccount.size()<1){
        
             List<String> usersFromRole = new List<String>();
             
             Usuario_Asignador_pais_negocio__c[] uapn = [SELECT User__c from Usuario_Asignador_pais_negocio__c where Pais__c=:country and Negocio__c=:defNegocio];
             
            if(uapn.size()<1){
                throw new applicationException('No es posible asignar la Cuenta a ningun Usuario para el pais: '+country+' y negocio: '+defNegocio+' indicado');
            }else{
                User u = [SELECT Id FROM user WHERE Username = :uapn[0].User__c limit 1];
                a.OwnerId = u.Id;
            }
        
                 
        }else{
            if(existaccount[0].Country__c != country){
                throw new applicationException('No es posible modificar el pais de una cuenta existente. (Pais: '+existaccount[0].Country__c+' a '+country+')');
            }else{
                a.OwnerId = existaccount[0].OwnerId;
            }
        }
   
            upsert a ID_Externo__c;
            
            System.debug(LoggingLevel.INFO, 'Upsert de Cuenta Id:' + a.Id);
            System.debug(LoggingLevel.INFO, 'Upsert de Cuenta IDU:' + a.dm_idu__c);
            
            Contact c = new Contact();
            
            Contact[] con = [SELECT Id from Contact where AccountId = :a.Id and from_api__c = true];
            if (con.size() > 0){
               c.Id = con[0].Id;
            }
            
            c.AccountId = a.Id;
            c.Phone = phone;
            c.FirstName = first_name;
            c.LastName = last_name;
            c.Email = email;
            c.OwnerId = a.OwnerId;
            c.from_api__c = true;          
            
            upsert c;    
         
        Map<String,String> account = new Map<String,String> {'id'=>a.Id, 'idu'=>a.dm_idu__c.replace('.',''), 'contact_id'=>c.Id};
        return account;
    
    }
}