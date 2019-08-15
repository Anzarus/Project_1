/**
 * Created by AntonAntoniuk on 13.08.2019.
 */

trigger Product2Trigger on Product2 (/*after insert,*/ after update/*, after delete*/) {
    if (Trigger.isAfter) {
        /*if (Trigger.isInsert) { // we cannot handle it cause we should have oppLineItem reference with Id of Product2 which is not exist before
            new Product2TriggerHandler().onInsert(Trigger.newMap);
        }*/
        if (Trigger.isUpdate) {
            new Product2TriggerHandler().onUpdate(Trigger.new, Trigger.oldMap);
        }
        /*if(Trigger.isDelete){   // we cannot handle it cause we cannot delete Product2 which have OppLineItem reference
            new Product2TriggerHandler().onDelete(Trigger.oldMap);
        }*/
    }
}