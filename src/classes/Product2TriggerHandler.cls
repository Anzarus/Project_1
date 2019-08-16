/**
 * Created by AntonAntoniuk on 13.08.2019.
 */

public with sharing class Product2TriggerHandler {

    private OpportunityTotalPriceRecalculator recalc;

    public Product2TriggerHandler() {
    }

    public void onUpdate(List<Product2> newProduct2s, Map<Id, Product2> oldProduct2sByIds) {

        Map<Id, Product2> newProduct2sByIds = checkWhichProdChangePriceAndFormMap(newProduct2s, oldProduct2sByIds);
        Map<Id, Product2> updatedOldProduct2sByIds = getUpdatedOldProduct2sByIds(newProduct2sByIds, oldProduct2sByIds);

        recalc = new OpportunityTotalPriceRecalculator(newProduct2sByIds, updatedOldProduct2sByIds);

        recalc.checkLinkToOppAndUpdateOpp();
        recalc.subProdPriceFromOpp();
    }

    private Map<Id, Product2> checkWhichProdChangePriceAndFormMap(List<Product2> newProduct2s, Map<Id, Product2> oldProduct2sByIds) {
        Map<Id, Product2> newProduct2sByIds = new Map<Id, Product2>();
        for (Product2 prod : newProduct2s) {
            if (prod.Price__c != oldProduct2sByIds.get(prod.Id).Price__c) newProduct2sByIds.put(prod.Id, prod);
        }
        return newProduct2sByIds;
    }

    private Map<Id, Product2> getUpdatedOldProduct2sByIds(Map<Id, Product2> newProduct2sByIds, Map<Id, Product2> oldProduct2sByIds) {
        Map<Id, Product2> updatedOldProduct2sByIds = new Map<Id, Product2>();
        for (Product2 prod : newProduct2sByIds.values()) {
            if (oldProduct2sByIds.containsKey(prod.Id)) updatedOldProduct2sByIds.put(prod.Id, oldProduct2sByIds.get(prod.Id));
        }
        return updatedOldProduct2sByIds;
    }
}