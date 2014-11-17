trigger setErrorSaveMainContact on Contact (before delete) {
        for (Contact c : Trigger.old) {
            if (c.from_api__c == true) {
                c.addError('No es posible borrar el contaco principal de una cuenta');
            } 
        }    
}