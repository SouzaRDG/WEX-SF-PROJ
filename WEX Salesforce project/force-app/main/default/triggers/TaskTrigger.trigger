trigger TaskTrigger on Task (after insert,  after update, after delete, after undelete) {

    if(Trigger.isAfter ) {
        if(Trigger.isInsert) {
            TaskTriggerHandler.handleAfterInsert(Trigger.newMap);
        }
        if (Trigger.isUpdate) {
            TaskTriggerHandler.handleAfterUpdate(Trigger.oldMap,Trigger.newMap);
        }
        if(Trigger.isDelete) {
            TaskTriggerHandler.handleAfterDelete(Trigger.oldMap);
        }
        if(Trigger.isUndelete) {
            TaskTriggerHandler.handleAfterUndelete(Trigger.newMap);
        }
    }

}