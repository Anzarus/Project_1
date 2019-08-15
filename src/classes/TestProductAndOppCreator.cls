/**
 * Created by AntonAntoniuk on 14.08.2019.
 */

@IsTest
public class TestProductAndOppCreator {
    public static List<Product2> generateAndConnectProdToOpp(Integer countOfOpp, Integer prodPerOpp, Integer lowBorderOfPrice, Integer highBorderOfPrice) {
        Pricebook2 standardPricebook2 = new Pricebook2(Name = 'Standard Price Book', Id = Test.getStandardPricebookId(), IsActive = true);
        update standardPricebook2;

        standardPricebook2 = [SELECT Id, IsStandard FROM Pricebook2 WHERE Id = :standardPricebook2.Id];

        List<Product2> product2s = generateAndGetProduct2s(prodPerOpp, lowBorderOfPrice, highBorderOfPrice);
        insert product2s;

        List<PricebookEntry> pricebookEntries = generatePriceBookEntriesForProd(product2s, standardPricebook2);
        insert pricebookEntries;

        List<Opportunity> opportunities = generateAndGetOpps(countOfOpp, standardPricebook2);
        insert opportunities;

        List<OpportunityLineItem> oppLineItems = generateAndGetOppLineItems(countOfOpp, prodPerOpp, opportunities, product2s, pricebookEntries);
        insert oppLineItems;

        opportunities = updateTotalPriceOnOpps(opportunities, oppLineItems, product2s);
        update opportunities;

        return product2s;
    }

    private static List<Product2> generateAndGetProduct2s(Integer prodPerOpp, Integer lowBorderOfPrice, Integer highBorderOfPrice) {
        List<Product2> product2s = new List<Product2>();
        Product2 prod;
        for (Integer i = 0; i < prodPerOpp; i++) {
            prod = new Product2(Name = 'Test Product ' + i,
                    Price__c = Decimal.valueOf(highBorderOfPrice * Math.random() + lowBorderOfPrice));
            product2s.add(prod);
        }
        return product2s;
    }

    private static List<PricebookEntry> generatePriceBookEntriesForProd(List<Product2> product2s, Pricebook2 pricebook2) {
        List<PricebookEntry> pricebookEntries = new List<PricebookEntry>();
        PricebookEntry pricebookEntry;
        for (Product2 prod : product2s) {
            pricebookEntry = new PricebookEntry(UnitPrice = prod.Price__c, IsActive = true,
                    Pricebook2Id = pricebook2.Id, Product2Id = prod.Id, UseStandardPrice = false);
            pricebookEntries.add(pricebookEntry);
        }

        return pricebookEntries;
    }


    private static List<Opportunity> generateAndGetOpps(Integer countOfOpp, Pricebook2 pricebook2) {
        List<Opportunity> opportunities = new List<Opportunity>();
        Opportunity opp;
        for (Integer i = 0; i < countOfOpp; i++) {
            opp = new Opportunity(Name = 'Test Opp ' + i, Pricebook2Id = pricebook2.Id,
                    CloseDate = System.Date.today(), StageName = 'Prospecting', Total_Price__c = 0);
            opportunities.add(opp);
        }
        return opportunities;
    }

    private static List<OpportunityLineItem> generateAndGetOppLineItems(Integer countOfOpp, Integer prodPerOpp, List<Opportunity> opportunities, List<Product2> product2s, List<PricebookEntry> pricebookEntries) {
        List<OpportunityLineItem> oppLineItems = new List<OpportunityLineItem>();
        OpportunityLineItem oppLineItem;
        for (Integer i = 0; i < countOfOpp; i++) {
            for (Integer j = 0; j < prodPerOpp; j++) {
                oppLineItem = new OpportunityLineItem(OpportunityId = opportunities[i].Id,
                        Product2Id = product2s[j].Id, Quantity = Integer.valueOf(1000 * Math.random() + 1),
                        TotalPrice = 0, PricebookEntryId = pricebookEntries[j].Id);
                oppLineItems.add(oppLineItem);
            }
        }
        return oppLineItems;
    }

    private static List<Opportunity> updateTotalPriceOnOpps(List<Opportunity> opportunities, List<OpportunityLineItem> oppLineItems, List<Product2> product2s) {
        Map<Id, Opportunity> opportunitiesByIds = new Map<Id, Opportunity>(opportunities);
        Map<Id, Product2> product2sByIds = new Map<Id, Product2>(product2s);
        for (OpportunityLineItem oppLineItem : oppLineItems) {
            opportunitiesByIds.get(oppLineItem.OpportunityId).Total_Price__c +=
                    product2sByIds.get(oppLineItem.Product2Id).Price__c * oppLineItem.Quantity;
        }
        return opportunitiesByIds.values();
    }
}