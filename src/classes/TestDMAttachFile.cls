@isTest
public class TestDMAttachFile {
        static testMethod void testAttachTrigger(){
             
            Account a = new Account(Name='TestAccount', Negocio__c='DM', dm_commercial_status__c='Validado');
            insert a;
            
            Attachment att = new Attachment(Name='Adjunto Prueba', Body=Blob.valueOf('Unit Test Attachment Body'), ParentId=a.Id);
            insert att;
            
            delete att;
            
        }
}