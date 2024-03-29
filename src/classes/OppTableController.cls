/**
 * Created by AntonAntoniuk on 15.08.2019.
 */

public with sharing class OppTableController {
    @AuraEnabled
    public static List<Product2> getProduct2sOfOpp(String oppId) {
        return new Product2sOfCurrentOppGetter().getProduct2sOfOpp(oppId);
    }

    class Product2sOfCurrentOppGetter {

        private List<Product2> getProduct2sOfOpp(String oppId) {

            List<OpportunityLineItem> oppLineItems = [
                    SELECT Id, OpportunityId, Product2Id
                    FROM OpportunityLineItem
                    WHERE OpportunityId = :oppId
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

    @AuraEnabled
    public static void deleteProdFromOpp(String oppId, String prodId){
        new Product2FromCurrentOppDeleter().deleteProdFromOpp(oppId, prodId);
    }

    class Product2FromCurrentOppDeleter {

        private void deleteProdFromOpp(String oppId, String prodId) {

            Product2 prod = [
                    SELECT Id, Price__c
                    FROM Product2
                    WHERE Id = :prodId
            ];

            OpportunityLineItem oppLineItem = [
                    SELECT Id, Quantity
                    FROM OpportunityLineItem
                    WHERE Product2Id = :prod.Id AND OpportunityId = :oppId
                    LIMIT 1
            ];
            Opportunity opp = [
                    SELECT Id, Total_Price__c
                    FROM Opportunity
                    WHERE Id = :oppId
                    LIMIT 1
            ];
            opp.Total_Price__c -= prod.Price__c * oppLineItem.Quantity;

            update opp;
            delete oppLineItem;
        }
    }
}