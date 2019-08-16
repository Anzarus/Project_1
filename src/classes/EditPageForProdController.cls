/**
 * Created by AntonAntoniuk on 16.08.2019.
 */

public with sharing class EditPageForProdController {
    @AuraEnabled
    public static Product2 getCurrentProd(String prodId) {
        return [
                SELECT Id, Name, Price__c
                FROM Product2
                WHERE Id = :Id.valueOf(prodId)
        ];
    }
}