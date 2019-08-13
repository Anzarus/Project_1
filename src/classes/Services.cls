/**
 * Created by AntonAntoniuk on 13.08.2019.
 */

public with sharing class Services {

    void checkLinkToOppAndUpdateOpp(Map<Id, Product2> productsByIds) {
        List<OpportunityLineItem> opportunityLineItems = [
                SELECT Id, Product2Id, OpportunityId
                FROM OpportunityLineItem
                WHERE Product2Id IN :productsByIds.keySet()
        ];

        Map<Id, OpportunityLineItem> opportunityLineItemsByOppIds = new Map<Id, OpportunityLineItem>();
        for (OpportunityLineItem oppLineItem : opportunityLineItems) {
            if (!opportunityLineItemsByOppIds.containsKey(oppLineItem.OpportunityId)) {
                opportunityLineItemsByOppIds.put(oppLineItem.OpportunityId, oppLineItem);
            }
        }

        List<Opportunity> opportunities = [
                SELECT Id, Total_Price__c
                FROM Opportunity
                WHERE Id IN :opportunityLineItemsByOppIds.keySet()
        ];
        Map<Id, Opportunity> opportunitiesByIds = new Map<Id, Opportunity>(opportunities);

        for (OpportunityLineItem opp : opportunityLineItems) {
            opportunitiesByIds.get(opp.OpportunityId).Total_Price__c += productsByIds.get(opp.Product2Id).Price__c;
        }
    }
}