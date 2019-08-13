/**
 * Created by AntonAntoniuk on 13.08.2019.
 */

trigger Product2Trigger on Product2 (after insert, after update) {
    if (Trigger.isAfter) {
        if (Trigger.isInsert) {
            new Product2TriggerHandler().onInsert(Trigger.newMap);
        }
        if (Trigger.isUpdate) {
            new Product2TriggerHandler().onUpdate(Trigger.newMap, Trigger.oldMap);
        }
    }
}