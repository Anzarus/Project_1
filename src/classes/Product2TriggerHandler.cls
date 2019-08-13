/**
 * Created by AntonAntoniuk on 13.08.2019.
 */

public with sharing class Product2TriggerHandler {

    Product2TriggerHandler(){}

    void onInsert(Map<Id, Product2> product2sByIds){
        Services.checkLinkToOppAndUpdateOpp(product2sByIds);
    }

    void onUpdate(Map<Id, Product2> newProduct2sByIds, Map<Id, Product2> oldProduct2sByIds){
        Services.checkLinkToOppAndUpdateOpp(newProduct2sByIds);
        Services.subProdPriceFromOpp(oldProduct2sByIds);
    }
}