/**
 * Created by AntonAntoniuk on 13.08.2019.
 */

public with sharing class Services {

    void checkLinkToOppAndUpdateOpp(Map<Id, Product2> product2sByIds) {

        List<OpportunityLineItem> opportunityLineItems = [
                SELECT Id, Product2Id, OpportunityId
                FROM OpportunityLineItem
                WHERE Product2Id IN :product2sByIds.keySet()
        ];

        Map<Id, Opportunity> opportunitiesByIds = getOpportunitiesByIds(opportunityLineItems);

        for (OpportunityLineItem opp : opportunityLineItems) {
            opportunitiesByIds.get(opp.OpportunityId).Total_Price__c += product2sByIds.get(opp.Product2Id).Price__c; //todo multiplex to count
        }
    }

    void updatingTotalValueOnOppIfUpdatedPriceOnProd(List<Product2> newProduct2s, Map<Id, Product2> oldProduct2sByIds) {

        Map<Id, Product2> newProduct2sByIds = checkWhichProdChangePriceAndFormMap(newProduct2s, oldProduct2sByIds);

        Map<Id, Product2> updatedOldProduct2sByIds = new Map<Id, Product2>();
        for(Product2 prod : oldProduct2sByIds.values()){
            if(newProduct2sByIds.containsKey(prod.Id)) updatedOldProduct2sByIds.put(prod.Id, prod);
        }

        checkLinkToOppAndUpdateOpp(newProduct2sByIds);
        subProdPriceFromOpp(updatedOldProduct2sByIds);
    }

    Map<Id, Product2> checkWhichProdChangePriceAndFormMap(List<Product2> newProduct2s, Map<Id, Product2> oldProduct2sByIds) {

        Map<Id, Product2> newProduct2sByIds = new Map<Id, Product2>();

        for (Product2 prod : newProduct2s) {
            if (prod.Price__c != oldProduct2sByIds.get(prod.Id).Price__c) newProduct2sByIds.put(prod.Id, prod);
        }

        return newProduct2sByIds;
    }

    void subProdPriceFromOpp(Map<Id, Product2> product2sByIds) {

        List<OpportunityLineItem> opportunityLineItems = [
                SELECT Id, OpportunityId, Product2Id
                FROM OpportunityLineItem
                WHERE Product2Id IN :product2sByIds.keySet()
        ];

        Map<Id, Opportunity> opportunitiesByIds = getOpportunitiesByIds(opportunityLineItems);

        for (OpportunityLineItem opp : opportunityLineItems) {
            opportunitiesByIds.get(opp.OpportunityId).Total_Price__c -= product2sByIds.get(opp.Product2Id).Price__c; //todo multiplex to count
        }
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
                WHERE Id IN :opportunityLineItemsByOppIds.keySet()
        ];
        Map<Id, Opportunity> opportunitiesByIds = new Map<Id, Opportunity>(opportunities);

        return opportunitiesByIds;
    }
}