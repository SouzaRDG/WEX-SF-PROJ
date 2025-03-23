public with sharing class ProjectMilestoneTriggerHandler {
    
    public static void handleBeforeUpdate(Map<Id,Project_Milestone__c> newMap, Map<Id,Project_Milestone__c> oldMap){
        updateMilestoneFields(newMap.values());
    }

    public static void handleBeforeInsert(List<Project_Milestone__c> newList){
        updateMilestoneFields(newList);
    }

    public static void handleAfterUpdate(Map<Id,Project_Milestone__c> newMap, Map<Id,Project_Milestone__c> oldMap){
        List<Id> projectIdList = extractProjectIdsFromMilestones(newMap, oldMap);
        ProjectMilestoneTriggerHandlerUtils.updateProjectCompletion(projectIdList);
    }

    public static void handleAfterInsert(Map<Id,Project_Milestone__c> newMap){
        List<Id> projectIdList = extractProjectIdsFromMilestones(newMap, null);
        ProjectMilestoneTriggerHandlerUtils.updateProjectCompletion(projectIdList);
    }

    public static void handleAfterDelete(Map<Id,Project_Milestone__c> oldMap){
        List<Id> projectIdList = extractProjectIdsFromMilestones(oldMap, null);
        ProjectMilestoneTriggerHandlerUtils.updateProjectCompletion(projectIdList);
    }

    public static void handleAfterUndelete(Map<Id,Project_Milestone__c> newMap){
        List<Id> projectIdList = extractProjectIdsFromMilestones(newMap, null);
        ProjectMilestoneTriggerHandlerUtils.updateProjectCompletion(projectIdList);
    }

    public static void updateMilestoneFields(List<Project_Milestone__c> milestoneList){
        for(Project_Milestone__c milestone : milestoneList){
            milestone.Status__c = milestone.Percentage_of_Completion__c >= 100 ? 'Complete' 
                    : milestone.Percentage_of_Completion__c > 0 ? 'In Progress'
                    : 'Not Started';
        }
    }

    public static List<Id> extractProjectIdsFromMilestones(Map<Id,Project_Milestone__c> milestoneMap, Map<Id,Project_Milestone__c> comparisonMap){
        List<Id> projectIdList = new List<Id>();
        for(Project_Milestone__c milestone : milestoneMap.values()){
            if(comparisonMap == null || milestone.Status__c != comparisonMap.get(milestone.Id).Status__c){
                projectIdList.add(milestone.Project__c);
            }
        }
        return projectIdList;
    }
}