/**
 * Created by AntonAntoniuk on 15.08.2019.
 */

public with sharing class OppTableController {
    @AuraEnabled
    public static List<Product2> getProduct2sofOpp(String oppId) {
        return new Product2sOfCurrentOppGetter().getProduct2sOfOpp(oppId);
    }

    private class Product2sOfCurrentOppGetter {

        private List<Product2> getProduct2sOfOpp(String oppId) {
            List<OpportunityLineItem> oppLineItems = [
                    SELECT Id, OpportunityId, Product2Id
                    FROM OpportunityLineItem
                    WHERE OpportunityId = :Id.valueOf(oppId)
            ];
            Map<Id, OpportunityLineItem> oppLineItemsByProdIds = new Map<Id, OpportunityLineItem>();
            for (OpportunityLineItem oppLineItem : oppLineItems) {
                if (!oppLineItemsByProdIds.containsKey(oppLineItem.Product2Id)) {
                    oppLineItemsByProdIds.put(oppLineItem.Product2Id, oppLineItem);
                }
            }

            return [
                    SELECT Id, Name, Price__c
                    FROM Product2
                    WHERE Id IN :oppLineItemsByProdIds.keySet()
            ];
        }
    }

}