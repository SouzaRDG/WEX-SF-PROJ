public with sharing class TaskTriggerHandler {
    
    public static void handleAfterInsert(Map<Id,Task> newMap){

        List<Id> milestonesToUpdateList = extractMilestonesIdsFromTasks(newMap, null);
        TaskTriggerHandlerUtils.updateMilestoneCompletionPercentage(milestonesToUpdateList);
    }

    public static void handleAfterUpdate(Map<Id,Task> newMap,Map<Id,Task> oldMap){

        List<Id> milestonesToUpdateList = extractMilestonesIdsFromTasks(newMap, oldMap);
        TaskTriggerHandlerUtils.updateMilestoneCompletionPercentage(milestonesToUpdateList);
    }

    public static void handleAfterDelete(Map<Id,Task> oldMap){

        List<Id> milestonesToUpdateList = extractMilestonesIdsFromTasks(oldMap, null);
        TaskTriggerHandlerUtils.updateMilestoneCompletionPercentage(milestonesToUpdateList);
    }

    public static void handleAfterUndelete(Map<Id,Task> newMap){

        List<Id> milestonesToUpdateList = extractMilestonesIdsFromTasks(newMap, null);
        TaskTriggerHandlerUtils.updateMilestoneCompletionPercentage(milestonesToUpdateList);
    }


    public static List<Id> extractMilestonesIdsFromTasks (Map<Id, Task> tasksMap, Map<Id, Task> comparisonTasksMap){
        
        List<Id> milestonesIdsList = new List<Id>();
        for(Task task : tasksMap.values()){
            if (task.WhatId != null && task.WhatId.getSObjectType() == Project_Milestone__c.sObjectType) {
                if(comparisonTasksMap == null || task.Status != comparisonTasksMap.get(task.Id).Status){
                    milestonesIdsList.add(task.WhatId);
                }
            }
        }
        return milestonesIdsList;
    }
}