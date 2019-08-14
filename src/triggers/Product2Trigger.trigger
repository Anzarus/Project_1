/**
 * Created by AntonAntoniuk on 13.08.2019.
 */

trigger Product2Trigger on Product2 (/*after insert,*/ after update/*, after delete*/) {
    if (Trigger.isAfter) {
        /*if (Trigger.isInsert) {
            new Product2TriggerHandler().onInsert(Trigger.newMap);
        }*/
        if (Trigger.isUpdate) {
            new Product2TriggerHandler().onUpdate(Trigger.new, Trigger.oldMap);
        }
        /*if(Trigger.isDelete){
            new Product2TriggerHandler().onDelete(Trigger.oldMap);
        }*/
    }
}