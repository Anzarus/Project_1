/**
 * Created by AntonAntoniuk on 16.08.2019.
 */

public with sharing class EditPageForProdController {
    @AuraEnabled
    public static Product2 getCurrentProd(String prodId) {
        return new CurrentProduct2Getter().getCurrentProduct2(prodId);
    }

    class CurrentProduct2Getter {

        private Product2 getCurrentProduct2(String prodId) {
            return [
                    SELECT Id, Name, Price__c
                    FROM Product2
                    WHERE Id = :Id.valueOf(prodId)
            ];
        }
    }

    @AuraEnabled
    public static void setNewParamOfProduct2(String name, Decimal price, String prodId) {
        Product2 newProduct2 = new Product2(Id = prodId, Name = name, Price__c = price);
        update newProduct2;
    }
}