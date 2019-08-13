/**
 * Created by AntonAntoniuk on 13.08.2019.
 */

trigger ProductTrigger on Product2 (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            new ProductTriggerHandler().onInsert(Trigger.newMap);
        }
        if (Trigger.isUpdate) {
            new ProductTriggerHandler().onUpdate();
        }
    }
}