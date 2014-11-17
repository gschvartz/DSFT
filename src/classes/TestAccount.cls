@isTest
public class TestAccount {
        static testMethod void testAccountTrigger(){
        
            Account a = new Account(Name='TestAccount');
            insert a;
            
            Account testAccount = [SELECT Name from Account where Id=:a.Id];
           
            System.assertEquals('TestAccount', testAccount.Name); 
        }
}