/**
 * Created by AntonAntoniuk on 16.08.2019.
 */

public with sharing class OpportunityTotalPriceRecalculator {

    private Map<Id, Product2> newProduct2sByIds;
    private Map<Id, Product2> oldProduct2sByIds;

    public OpportunityTotalPriceRecalculator(Map<Id, Product2> newProduct2sByIds, Map<Id, Product2> oldProduct2sByIds){
        this.newProduct2sByIds = newProduct2sByIds;
        this.oldProduct2sByIds = oldProduct2sByIds;
    }

    public void checkLinkToOppAndUpdateOpp() {

        List<OpportunityLineItem> opportunityLineItems = [
                SELECT Id, Product2Id, OpportunityId, Quantity
                FROM OpportunityLineItem
                WHERE Product2Id IN :THIS.newProduct2sByIds.keySet()
        ];
        if (opportunityLineItems == null) return;

        Map<Id, Opportunity> opportunitiesByIds = getOpportunitiesByIds(opportunityLineItems);

        for (OpportunityLineItem oppLineItem : opportunityLineItems) {
            opportunitiesByIds.get(oppLineItem.OpportunityId).Total_Price__c +=
                    this.newProduct2sByIds.get(oppLineItem.Product2Id).Price__c * oppLineItem.Quantity;
        }

        update opportunitiesByIds.values();
    }

    public void subProdPriceFromOpp() {

        List<OpportunityLineItem> opportunityLineItems = [
                SELECT Id, OpportunityId, Product2Id, Quantity
                FROM OpportunityLineItem
                WHERE Product2Id IN :THIS.oldProduct2sByIds.keySet()
        ];
        if(opportunityLineItems == null) return;

        Map<Id, Opportunity> opportunitiesByIds = getOpportunitiesByIds(opportunityLineItems);

        for (OpportunityLineItem opp : opportunityLineItems) {
            opportunitiesByIds.get(opp.OpportunityId).Total_Price__c -=
                    this.oldProduct2sByIds.get(opp.Product2Id).Price__c * opp.Quantity;
        }

        update opportunitiesByIds.values();
    }

    private Map<Id, Opportunity> getOpportunitiesByIds(List<OpportunityLineItem> opportunityLineItems) {

        Map<Id, OpportunityLineItem> opportunityLineItemsByOppIds = new Map<Id, OpportunityLineItem>();
        for (OpportunityLineItem oppLineItem : opportunityLineItems) {
            if (!opportunityLineItemsByOppIds.containsKey(oppLineItem.OpportunityId)) {
                opportunityLineItemsByOppIds.put(oppLineItem.OpportunityId, oppLineItem);
            }
        }

        List<Opportunity> opportunities = [
                SELECT Id, Total_Price__c
                FROM Opportunity
                WHERE Id IN :opportunityLineItemsByOppIds.keySet() //todo what about "Closed Won" status?
        ];
        Map<Id, Opportunity> opportunitiesByIds = new Map<Id, Opportunity>(opportunities);

        return opportunitiesByIds;
    }
}