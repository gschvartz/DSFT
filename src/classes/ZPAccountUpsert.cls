@RestResource(urlMapping='/cstmZPAccountUpsert/*')
global with sharing class ZPAccountUpsert{

   @HttpPost
    global static Map<String,String> doPost(String name, String tipo, String fecha_registro, String idu, String website, String estado_cuenta,
                                            String first_name, String last_name, String phone, String other_phone, String email,
                                            String estado_comercial, String ciudad_comercial,
                                            String domicilio_comercial, String cod_postal_comercial, String razon_social,
                                            String codigo_fiscal, String condicion_tributaria, String estado_facturacion,
                                            String ciudad_facturacion, String domicilio_facturacion, String cod_postal_facturacion,
                                            String situacion_iibb, String iibb_numero_inscripcion, String estado_fiscal, String country){ 
         
        String defNegocio = 'ZP';
        String external_ID = defNegocio+'_'+idu;    
        
        Map<String,String> currency_code = new Map<String,String> { 'ARG' => 'ARS',
                                                                    'CHI' => 'CLP',
                                                                    'VEN' => 'VEF',
                                                                    'BRA' => 'BRL',
                                                                    'MEX' => 'MXN',
                                                                    'COL' => 'COP',
                                                                    'PER' => 'PEN',
                                                                    'ESP' => 'EUR',
                                                                    'ECU' => 'ECS'};
        Map<String,Map<String,String>> currency_map = new Map<String,Map<String,String>>{country => currency_code};
        
        Map<String,String> tipo_empresa_code = new Map<String,String> {'BROKER' => 'Corredor',
                                                                       'CONSTRUCTION' => 'Constructora',
                                                                       'AGENCY' => 'Agencia',
                                                                       'COMPOUND_AGENCY' => 'Agencia'};
        Map<String,Map<String,String>> tipo_empresa_map = new Map<String,Map<String,String>>{tipo => tipo_empresa_code};                      

        Map<String,String> estado_cuenta_code = new Map<String,String> {'ACTIVE' => 'Activo',
                                                                        'PENDING' => 'Pendiente de Confirmacion',
                                                                        'INACTIVE' => 'Inactivo',
                                                                        'SUSPENDED' => 'Suspendido'};
        Map<String,Map<String,String>> estado_cuenta_map = new Map<String,Map<String,String>>{estado_cuenta => estado_cuenta_code}; 
        
        Map<String,String> condicion_tributaria_code = new Map<String,String> { 'CONSUMIDOR_FINAL' => 'Consumidor Final',
                                                                                'EXCENTO' => 'Excento',
                                                                                'MONOTRIBUTISTA' => 'Monotributista',
                                                                                'RESPONSABLE_INSCRIPTO' => 'Responsable Inscripto',
                                                                                'RFC' => 'RFC',
                                                                                'NIT' => 'NIT',
                                                                                'CC' => 'CC',
                                                                                'CE' => 'CE',
                                                                                'CPF' => 'CPF'};
        Map<String,Map<String,String>> condicion_tributaria_map = new Map<String,Map<String,String>>{condicion_tributaria => condicion_tributaria_code}; 
        
        Map<String,String> situacion_iibb_code = new Map<String,String> {'CONTRIBUYENTE_LOCAL' => 'Contribuyente Local',
                                                                        'CONVENIO_MULTILATERAL' => 'Convenio Multilateral',
                                                                        'NO_INSCRIPTO' => 'No Inscripto',
                                                                        'UNDEFINED' => 'No Definido'};
        Map<String,Map<String,String>> situacion_iibb_map = new Map<String,Map<String,String>>{situacion_iibb => situacion_iibb_code}; 

        Map<String,String> estado_fiscal_code = new Map<String,String> {'VALIDADO' => 'Validado',
                                                                        'NO VALIDADO' => 'No Validado'};
        Map<String,Map<String,String>> estado_fiscal_map = new Map<String,Map<String,String>>{estado_fiscal => estado_fiscal_code}; 
        
              
        
        List<String> requiredFields = new List<String> {    name,
                                                            razon_social,
                                                            fecha_registro,
                                                            string.valueof(idu),
                                                            tipo,
                                                            email,
                                                            estado_fiscal,
                                                            condicion_tributaria,
                                                            country,
                                                            estado_comercial,
                                                            ciudad_comercial,
                                                            domicilio_comercial,
                                                            last_name,
                                                            first_name};    
       for(String key: requiredFields){
           if(String.isEmpty(key)){
                throw new applicationException('Falta campo requerido');
           }
       }
       
        List<Map<String,Map<String,String>>> listvalues = new List<Map<String,Map<String,String>>>{currency_map,tipo_empresa_map,estado_cuenta_map,condicion_tributaria_map, estado_fiscal_map,situacion_iibb_map};
                                                                                                       
        for(Map<String,Map<String,String>> item: listvalues){
              for (string theKey:item.keySet()){
                    //System.debug(LoggingLevel.INFO, 'a buscar:' + theKey);
                    //System.debug(LoggingLevel.INFO, 'mapa:' + item.get(theKey));
                    
                    if(String.isEmpty(item.get(theKey).get(theKey))){
                        System.debug(LoggingLevel.INFO, 'error al buscar' + theKey);
                        throw new applicationException('No coincide "'+theKey+'" con los posibles valores permitidos');
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
        a.zp_idu__c = idu;
        a.Name = name;
        a.Country__c = country;
        a.CurrencyIsoCode = currency_code.get(country);
        a.Negocio__c = defNegocio;
        a.Phone = phone ;
        a.Correo_Electronico__c = email;
        a.tipo_empresa__c = tipo_empresa_code.get(tipo);
        a.Estado_de_la_cuenta__c =  estado_cuenta_code.get(estado_cuenta);
        a.Razon_Social__c = razon_social;
        a.fecha_registro__c = date.parse(fecha);
        a.SHIPPINGSTATE = ciudad_comercial;
        a.SHIPPINGSTREET = domicilio_comercial;
        a.BILLINGSTREET = domicilio_facturacion;
        a.BILLINGCITY = estado_facturacion;
        a.SHIPPINGCITY = estado_comercial;
        a.Nro_Id_Tributaria__c = codigo_fiscal;
        a.SHIPPINGPOSTALCODE = cod_postal_comercial;
        a.BILLINGPOSTALCODE = cod_postal_facturacion;
        a.Condicion_de_IVA__c = condicion_tributaria_code.get(condicion_tributaria);
        a.BILLINGSTATE = ciudad_facturacion;
        a.estado_fiscal__c =  estado_fiscal_code.get(estado_fiscal);
        a.Ingresos_Brutos__c = situacion_iibb_code.get(situacion_iibb);  
                                                                
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
            System.debug(LoggingLevel.INFO, 'Upsert de Cuenta IDU:' + a.zp_idu__c);
            
            Contact c = new Contact();
            
            Contact[] con = [SELECT Id from Contact where AccountId = :a.Id and from_api__c = true];
            if (con.size() > 0){
               c.Id = con[0].Id;
            }
            
            c.AccountId = a.Id;
            c.Phone = phone;
            c.OtherPhone = other_phone;
            c.FirstName = first_name;
            c.LastName = last_name;
            c.Email = email;
            c.OwnerId = a.OwnerId;
            c.from_api__c = true;          
            
            upsert c;    
         
        Map<String,String> account = new Map<String,String> {'id'=>a.Id, 'idu'=>a.zp_idu__c.replace('.',''), 'contact_id'=>c.Id};
        return account;
    
    }
}