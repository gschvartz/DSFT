@isTest
public class TestContact {
        static testMethod void testCantDeletePpalContactTrigger(){
        
            Account a = new Account(Name='TestAccount');
            insert a;
        
            Contact c = new Contact(AccountId=a.Id, FirstName='First Name', LastName='Last Name', from_api__c=true);
            insert c;
            
            Contact testContact = [SELECT Id, FirstName  from Contact where Id=:c.Id];
            
            try{
                delete c;
            }catch(DmlException e){ 
                 System.assert(e.getMessage().contains('FIELD_CUSTOM_VALIDATION_EXCEPTION'), e.getMessage());  
            }
            
           
        }
}