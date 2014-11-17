trigger validateOppIDUFacturador on Opportunity (before update) {

    for (Opportunity opp : Trigger.new)
    {
        Account a = [Select dm_Idu_facturador__c, Negocio__c from Account where Id=:opp.AccountId]; 
        
        if(a.Negocio__c=='DM' && opp.Probability==100){
            Account[] aFacturador = [SELECT Estado_de_la_cuenta__c, dm_idu__c from Account where dm_idu__c=:a.dm_Idu_facturador__c limit 1];
            if(aFacturador[0].Estado_de_la_cuenta__c!='Activo'){
                opp.addError('No es posible Cerrar y Ganar ventas sobre una cuenta cuyo IDU Facturador NO se Encuentra en estado Activo');
            }
        }

    }
}