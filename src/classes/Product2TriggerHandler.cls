/**
 * Created by AntonAntoniuk on 13.08.2019.
 */

public with sharing class Product2TriggerHandler {

    Product2TriggerHandler(){}

    void onInsert(Map<Id, Product2> product2sByIds){
        Services.checkLinkToOppAndUpdateOpp(product2sByIds);
    }

    void onUpdate(List<Product2> newProduct2s, Map<Id, Product2> oldProduct2sByIds){
        Services.updatingTotalValueOnOppIfUpdatedPriceOnProd(newProduct2s, oldProduct2sByIds);
    }

    void onDelete(Map<Id, Product2> Product2sByIds){
        Services.subProdPriceFromOpp(Product2sByIds);
    }
}