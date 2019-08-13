/**
 * Created by AntonAntoniuk on 13.08.2019.
 */

public with sharing class ProductTriggerHandler {

    ProductTriggerHandler(){}

    void onInsert(Map<Id, Product2> productsByIds){
        Services.checkLinkToOppAndUpdateOpp(productsByIds);
    }

    void onUpdate(){

    }
}