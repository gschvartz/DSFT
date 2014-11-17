trigger DMValidateAttachmentTrigger on Attachment (before delete, before update, before insert) {
    if (Trigger.isDelete) {
        for (Attachment attachment :Trigger.old){
            if(attachment.ParentId.getSObjectType() == Opportunity.sObjectType){
                Opportunity o = [Select Aprobada__c from Opportunity where Id=: attachment.ParentId];
                if(o.Aprobada__c == true){
                    attachment.addError('No es posible realizar esta accion sobre una Oportunidad Aprobada');
                }
            }
        }
    }
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Attachment attachment :Trigger.new){
            if(attachment.ParentId.getSObjectType() == Opportunity.sObjectType){
                Opportunity o = [Select Aprobada__c from Opportunity where Id=: attachment.ParentId];
                if(o.Aprobada__c == true){
                    attachment.addError('No es posible realizar esta accion sobre una Oportunidad Aprobada');
                }
            }
        }
    }
}