trigger ProjectMilestoneTrigger on Project_Milestone__c (before update, before insert, after update, after insert, after delete, after undelete) {

    if(Trigger.isBefore) {
        if(Trigger.isUpdate) {
            ProjectMilestoneTriggerHandler.handleBeforeUpdate(Trigger.newMap, Trigger.oldMap);
        }
        if(Trigger.isInsert) {
            ProjectMilestoneTriggerHandler.handleBeforeInsert(Trigger.new);
        }
    }
    if(Trigger.isAfter){
        if(Trigger.isUpdate){
            ProjectMilestoneTriggerHandler.handleAfterUpdate(Trigger.newMap, Trigger.oldMap);
        }
        if(Trigger.isInsert) {
            ProjectMilestoneTriggerHandler.handleAfterInsert(Trigger.newMap);
        }
        if(Trigger.isDelete){
            ProjectMilestoneTriggerHandler.handleAfterDelete(Trigger.oldMap);
        }
        if (Trigger.isUndelete) {
            ProjectMilestoneTriggerHandler.handleAfterUndelete(Trigger.newMap);
        }
    }
}