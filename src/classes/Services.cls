/**
 * Created by AntonAntoniuk on 13.08.2019.
 */

public with sharing class Services {

    public static void checkLinkToOppAndUpdateOpp(Map<Id, Product2> product2sByIds) {

        List<OpportunityLineItem> opportunityLineItems = [
                SELECT Id, Product2Id, OpportunityId, Quantity
                FROM OpportunityLineItem
                WHERE Product2Id IN :product2sByIds.keySet()
        ];
        if (opportunityLineItems == null) return;

        Map<Id, Opportunity> opportunitiesByIds = getOpportunitiesByIds(opportunityLineItems);

        for (OpportunityLineItem oppLineItem : opportunityLineItems) {
            opportunitiesByIds.get(oppLineItem.OpportunityId).Total_Price__c +=
                    product2sByIds.get(oppLineItem.Product2Id).Price__c * oppLineItem.Quantity;
        }

        update opportunitiesByIds.values();
    }

    public static void updatingTotalValueOnOppIfUpdatedPriceOnProd(List<Product2> newProduct2s, Map<Id, Product2> oldProduct2sByIds) {

        Map<Id, Product2> newProduct2sByIds = checkWhichProdChangePriceAndFormMap(newProduct2s, oldProduct2sByIds);

        Map<Id, Product2> updatedOldProduct2sByIds = new Map<Id, Product2>();
        for (Product2 prod : newProduct2sByIds.values()) {
            if (oldProduct2sByIds.containsKey(prod.Id)) updatedOldProduct2sByIds.put(prod.Id, oldProduct2sByIds.get(prod.Id));
        }

        checkLinkToOppAndUpdateOpp(newProduct2sByIds);
        subProdPriceFromOpp(updatedOldProduct2sByIds);
    }

    private static Map<Id, Product2> checkWhichProdChangePriceAndFormMap(List<Product2> newProduct2s, Map<Id, Product2> oldProduct2sByIds) {

        Map<Id, Product2> newProduct2sByIds = new Map<Id, Product2>();

        for (Product2 prod : newProduct2s) {
            if (prod.Price__c != oldProduct2sByIds.get(prod.Id).Price__c) newProduct2sByIds.put(prod.Id, prod);
        }

        return newProduct2sByIds;
    }

    public static void subProdPriceFromOpp(Map<Id, Product2> product2sByIds) {

        List<OpportunityLineItem> opportunityLineItems = [
                SELECT Id, OpportunityId, Product2Id, Quantity
                FROM OpportunityLineItem
                WHERE Product2Id IN :product2sByIds.keySet()
        ];
        if(opportunityLineItems == null) return;

        Map<Id, Opportunity> opportunitiesByIds = getOpportunitiesByIds(opportunityLineItems);

        for (OpportunityLineItem opp : opportunityLineItems) {
            opportunitiesByIds.get(opp.OpportunityId).Total_Price__c -=
                    product2sByIds.get(opp.Product2Id).Price__c * opp.Quantity;
        }

        update opportunitiesByIds.values();
    }

    private static Map<Id, Opportunity> getOpportunitiesByIds(List<OpportunityLineItem> opportunityLineItems) {

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