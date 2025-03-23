public with sharing class TaskTriggerHandlerUtils {
    
    public static void updateMilestoneCompletionPercentage(List<Id> milestonesIdsList){

        List<Project_Milestone__c> milestonesUpdateList = new List<Project_Milestone__c>();
        Map<Id,Integer> mapMilestoneIdToCompletedTask = new Map<Id,Integer>();
        Map<Id,Integer> mapMilestoneIdToTotalTask = new Map<Id,Integer>();

        for(Task taskRecord : [SELECT Id, WhatId, Status FROM Task WHERE WhatId IN :milestonesIdsList]){
            if (!mapMilestoneIdToTotalTask.containsKey(taskRecord.WhatId)) {
                mapMilestoneIdToTotalTask.put(taskRecord.WhatId, 0);
                mapMilestoneIdToCompletedTask.put(taskRecord.WhatId, 0);
            }

            mapMilestoneIdToTotalTask.put(taskRecord.WhatId, mapMilestoneIdToTotalTask.get(taskRecord.WhatId) + 1);
            if (taskRecord.Status == 'Completed') {
                mapMilestoneIdToCompletedTask.put(taskRecord.WhatId, (mapMilestoneIdToCompletedTask.get(taskRecord.WhatId) + 1));
            }
        }

        Project_Milestone__c auxMilestone  = new Project_Milestone__c();

        for(Id milestoneId : milestonesIdsList){
            auxMilestone.Id = milestoneId;
            auxMilestone.Percentage_of_Completion__c = mapMilestoneIdToTotalTask.containsKey(milestoneId) ? 
                mapMilestoneIdToCompletedTask.get(milestoneId) * 100 / mapMilestoneIdToTotalTask.get(milestoneId) : 0;
            milestonesUpdateList.add(auxMilestone);
        }

        Set<Project_Milestone__c> projectMilestoneSet = new Set<Project_Milestone__c>(milestonesUpdateList);
        milestonesUpdateList = new List<Project_Milestone__c>(projectMilestoneSet);
        
        if(!milestonesUpdateList.isEmpty()){
            update milestonesUpdateList;
        }
    }
}