/**
 * Created by AntonAntoniuk on 14.08.2019.
 */

@IsTest
private class TestProduct2TriggerHandler {
    @IsTest
    static void testOneProductPriceUpdate() {

        List<Product2> product2s = TestProductAndOppCreator.generateAndConnectProdToOpp(1, 1, 100, 50000);

        Map<Id, Product2> product2sByIds = new Map<Id, Product2>(product2s);
        List<OpportunityLineItem> oppLineItems = [
                SELECT Id, OpportunityId, Product2Id, Quantity
                FROM OpportunityLineItem
                WHERE Product2Id IN :product2sByIds.keySet()
        ];

        Map<Id, OpportunityLineItem> oppLineItemsByOppIds = new Map<Id, OpportunityLineItem>();
        for(OpportunityLineItem oppLineItem: oppLineItems){
            if(!oppLineItemsByOppIds.containsKey(oppLineItem.Id)) oppLineItemsByOppIds.put(oppLineItem.OpportunityId, oppLineItem);
        }

        List<Opportunity> opps = [
                SELECT Id, Total_Price__c
                FROM Opportunity
                WHERE Id IN :oppLineItemsByOppIds.keySet()
        ];

        product2s[0].Price__c += 1000;
        update product2s;
        List<Opportunity> updatedOpps = [
                SELECT Id, Total_Price__c
                FROM Opportunity
                WHERE Id IN :oppLineItemsByOppIds.keySet()
        ];

        System.assertEquals(opps[0].Total_Price__c + 1000 * oppLineItems[0].Quantity, updatedOpps[0].Total_Price__c);
    }
}