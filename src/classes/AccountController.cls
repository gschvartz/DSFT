public with sharing class AccountController {
    public List<Account> accs {get; set;}
    public String prefix {get; set;}

    public AccountController(ApexPages.StandardController con) {
        System.debug('abc');
        accs = [SELECT Id, Name, Phone, Type fROM Account];
    }

    public void test() {
    }
}