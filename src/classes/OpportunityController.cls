public with sharing class OpportunityController {
    public Opportunity opp {get; set;}
    public OpportunityController(ApexPages.StandardController con) {
        opp = [SELECT Id, Name, StageName FROM Opportunity LIMIT 1];
    }
}