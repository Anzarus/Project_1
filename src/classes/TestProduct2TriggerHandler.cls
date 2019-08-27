/**
 * Created by AntonAntoniuk on 14.08.2019.
 */

@IsTest
private class TestProduct2TriggerHandler {
    @IsTest
    static void testOneProductToOneOppPriceUpdate() {

        List<Product2> product2s = TestProductAndOppCreator.generateAndConnectProdToOpp(1, 1, 100, 50000);
        Map<Id, Product2> product2sByIds = new Map<Id, Product2>(product2s);

        Test.startTest();

        List<OpportunityLineItem> oppLineItems = getOppLineItems(product2sByIds);
        Map<Id, OpportunityLineItem> oppLineItemsByOppIds = getOppLineItemsByOppIds(oppLineItems);

        List<Opportunity> opps = getOpps(oppLineItemsByOppIds);

        Map<Id, Double> differenceOfPrices;

        User testUser = getTestUser();
        System.runAs(testUser) {
            differenceOfPrices = getDifferenceOfPrices(product2s, product2s.size());
        }

        List<Opportunity> updatedOpps = getOpps(oppLineItemsByOppIds);

        Test.stopTest();

        System.assertEquals(opps[0].Total_Price__c + differenceOfPrices.get(product2s[0].Id) *
                oppLineItemsByOppIds.get(updatedOpps[0].Id).Quantity, updatedOpps[0].Total_Price__c);

    }

    @IsTest
    static void testOneProductToManyOppPriceUpdate() {

        List<Product2> product2s = TestProductAndOppCreator.generateAndConnectProdToOpp(200, 1, 100, 50000);
        Map<Id, Product2> product2sByIds = new Map<Id, Product2>(product2s);

        Test.startTest();

        List<OpportunityLineItem> oppLineItems = getOppLineItems(product2sByIds);
        Map<Id, OpportunityLineItem> oppLineItemsByOppIds = getOppLineItemsByOppIds(oppLineItems);

        List<Opportunity> opps = getOpps(oppLineItemsByOppIds);

        Map<Id, Double> differenceOfPrices;

        User testUser = getTestUser();
        System.runAs(testUser) {
            differenceOfPrices = getDifferenceOfPrices(product2s, product2s.size());
        }

        List<Opportunity> updatedOpps = getOpps(oppLineItemsByOppIds);

        Test.stopTest();

        for (Integer i = 0; i < opps.size(); i++) {
            System.assertEquals(opps[i].Total_Price__c + differenceOfPrices.get(product2s[0].Id) *
                    oppLineItemsByOppIds.get(updatedOpps[i].Id).Quantity, updatedOpps[i].Total_Price__c);
        }
    }

    @IsTest
    static void testManyProductToOneOppPriceUpdate() {

        List<Product2> product2s = TestProductAndOppCreator.generateAndConnectProdToOpp(1, 200, 100, 50000);
        Map<Id, Product2> product2sByIds = new Map<Id, Product2>(product2s);

        Test.startTest();

        List<OpportunityLineItem> oppLineItems = getOppLineItems(product2sByIds);
        Map<Id, OpportunityLineItem> oppLineItemsByOppIds = getOppLineItemsByOppIds(oppLineItems);

        List<Opportunity> opps = getOpps(oppLineItemsByOppIds);

        Map<Id, Double> differenceOfPrices;

        User testUser = getTestUser();
        System.runAs(testUser) {
            differenceOfPrices = getDifferenceOfPrices(product2s, product2s.size());
        }

        List<Opportunity> updatedOpps = getOpps(oppLineItemsByOppIds);

        Test.stopTest();

        Map<Id, OpportunityLineItem> oppLineItemsByProdIds = getOppLineItemsByProdIds(oppLineItems);

        for (Integer i = 0; i < product2s.size(); i++) {
            opps[0].Total_Price__c += differenceOfPrices.get(product2s[i].Id) *
                    oppLineItemsByProdIds.get(product2s[i].Id).Quantity;
        }
        System.assertEquals(opps[0].Total_Price__c, updatedOpps[0].Total_Price__c);
    }

    @IsTest
    static void testManyProductToManyOppPriceUpdate() {

        List<Product2> product2s = TestProductAndOppCreator.generateAndConnectProdToOpp(2, 2, 100, 500);
        Map<Id, Product2> product2sByIds = new Map<Id, Product2>(product2s);

        Test.startTest();

        List<OpportunityLineItem> oppLineItems = getOppLineItems(product2sByIds);
        Map<Id, OpportunityLineItem> oppLineItemsByOppIds = getOppLineItemsByOppIds(oppLineItems);

        List<Opportunity> opps = getOpps(oppLineItemsByOppIds);

        Map<Id, Double> differenceOfPrices;

        User testUser = getTestUser();
        System.runAs(testUser) {
            differenceOfPrices = getDifferenceOfPrices(product2s, product2s.size());
        }

        List<Opportunity> updatedOpps = getOpps(oppLineItemsByOppIds);

        Test.stopTest();

        for (Integer i = 0; i < opps.size(); i++) {
            for (Integer j = 0; j < product2s.size(); j++) {
                opps[i].Total_Price__c += differenceOfPrices.get(product2s[j].Id) *
                        getTargetQuantity(oppLineItems, opps[i], product2s[j]);
            }
            System.assertEquals(opps[i].Total_Price__c, updatedOpps[i].Total_Price__c);
        }
    }

    @IsTest
    static void testProductUpdatePrice() {
        List<Product2> product2s = TestProductAndOppCreator.generateAndConnectProdToOpp(1, 1000, 100, 50000);
        Map<Id, Product2> product2sByIds = new Map<Id, Product2>(product2s);

        Test.startTest();

        List<OpportunityLineItem> oppLineItems = getOppLineItems(product2sByIds);
        Map<Id, OpportunityLineItem> oppLineItemsByOppIds = getOppLineItemsByOppIds(oppLineItems);

        List<Opportunity> opps = getOpps(oppLineItemsByOppIds);

        Map<Id, Double> differenceOfPrices;
        Integer quantityOfProduct2sUpdatedByPrice;

        User testUser = getTestUser();
        System.runAs(testUser) {
            quantityOfProduct2sUpdatedByPrice = Integer.valueOf(Math.random() * product2s.size());
            renamePartOfProducts(product2s, quantityOfProduct2sUpdatedByPrice);

            differenceOfPrices = getDifferenceOfPrices(product2s, quantityOfProduct2sUpdatedByPrice);
        }

        List<Opportunity> updatedOpps = getOpps(oppLineItemsByOppIds);

        Test.stopTest();

        Map<Id, OpportunityLineItem> oppLineItemsByProdIds = getOppLineItemsByProdIds(oppLineItems);

        for (Integer i = 0; i < quantityOfProduct2sUpdatedByPrice; i++) {
            opps[0].Total_Price__c += differenceOfPrices.get(product2s[i].Id) *
                    oppLineItemsByProdIds.get(product2s[i].Id).Quantity;
        }
        System.assertEquals(opps[0].Total_Price__c, updatedOpps[0].Total_Price__c);
    }

    private static User getTestUser() {
//        return [SELECT Id FROM User WHERE Username = 'antonuk1999@gmail.com'];
        Profile profile = [SELECT Id FROM Profile WHERE Name = 'Standard user' LIMIT 1];
        User testUser = new User(LastName = 'Robinson', Alias = 'Robi', Email = 'antonantonuk1999@gmail.com',
                Username = 'testUserProject1@gmail.com' + Datetime.now().getTime(), CommunityNickname = 'testUser',
                EmailEncodingKey = 'UTF-8', LanguageLocaleKey = 'en_US', LocaleSidKey = 'en_US', ProfileId = profile.Id,
                TimeZoneSidKey = 'America/Los_Angeles');

        PermissionSet permissionSet = [SELECT Id FROM PermissionSet WHERE Label = 'Project 1 user permission set'];
        PermissionSetAssignment psa = new PermissionSetAssignment
                (PermissionSetId = permissionSet.Id, AssigneeId = testUser.Id);

        return testUser;
    }

    private static Map<Id, OpportunityLineItem> getOppLineItemsByOppIds(List<OpportunityLineItem> oppLineItems) {
        Map<Id, OpportunityLineItem> oppLineItemsByOppIds = new Map<Id, OpportunityLineItem>();
        for (OpportunityLineItem oppLineItem : oppLineItems) {
            if (!oppLineItemsByOppIds.containsKey(oppLineItem.Id)) {
                oppLineItemsByOppIds.put(oppLineItem.OpportunityId, oppLineItem);
            }
        }
        return oppLineItemsByOppIds;
    }

    private static Map<Id, OpportunityLineItem> getOppLineItemsByProdIds(List<OpportunityLineItem> oppLineItems) {
        Map<Id, OpportunityLineItem> oppLineItemsByProdIds = new Map<Id, OpportunityLineItem>();
        for (OpportunityLineItem oppLineItem : oppLineItems) {
            if (!oppLineItemsByProdIds.containsKey(oppLineItem.Product2Id)) {
                oppLineItemsByProdIds.put(oppLineItem.Product2Id, oppLineItem);
            }
        }
        return oppLineItemsByProdIds;
    }

    private static List<OpportunityLineItem> getOppLineItems(Map<Id, Product2> product2sByIds) {
        List<OpportunityLineItem> oppLineItems = [
                SELECT Id, OpportunityId, Product2Id, Quantity
                FROM OpportunityLineItem
                WHERE Product2Id IN :product2sByIds.keySet()
        ];
        return oppLineItems;
    }

    private static List<Opportunity> getOpps(Map<Id, OpportunityLineItem> oppLineItemsByOppIds) {
        List<Opportunity> opps = [
                SELECT Id, Total_Price__c
                FROM Opportunity
                WHERE Id IN :oppLineItemsByOppIds.keySet()
        ];
        return opps;
    }

    private static Map<Id, Double> getDifferenceOfPrices(List<Product2> product2s, Integer quantityToUpdate) {
        Map<Id, Double> differenceOfPrices = new Map<Id, Double>();
        Double diff;
        for (Integer i = 0; i < quantityToUpdate; i++) {
            diff = Decimal.valueOf(10000 * Math.random() - 5000);
            product2s[i].Price__c += diff;
            differenceOfPrices.put(product2s[i].Id, diff);
        }
        update product2s;
        return differenceOfPrices;
    }

    private static void renamePartOfProducts(List<Product2> originalProduct2s, Integer quantityOfProduct2sUpdatedByPrice) {
        for (Integer i = quantityOfProduct2sUpdatedByPrice; i < originalProduct2s.size(); i++) {
            originalProduct2s[i].Name = 'New Product Name ' + i;
        }
    }

    private static Decimal getTargetQuantity(List<OpportunityLineItem> oppLineItems, Opportunity opp, Product2 prod) {
        Decimal targetQuantity;
        for (Integer i = 0; i < oppLineItems.size(); i++) {
            if (oppLineItems[i].Product2Id == prod.Id && oppLineItems[i].OpportunityId == opp.Id) {
                targetQuantity = oppLineItems[i].Quantity;
                break;
            }
        }
        return targetQuantity;
    }
}