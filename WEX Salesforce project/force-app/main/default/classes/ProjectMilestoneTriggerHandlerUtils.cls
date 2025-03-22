public with sharing class ProjectMilestoneTriggerHandlerUtils {
    
    public static void updateProjectCompletion(List<Id> projectIdsList){

        List<Project__c> projectUpdateList = new List<Project__c>();
        Map<Id,Integer> mapProjectIdToCompleteMilestones = new Map<Id,Integer>();
        Map<Id,Integer> mapProjectIdToTotalMilestoneNumber = new Map<Id,Integer>();

        for(Project_Milestone__c milestone : [SELECT Id, Status__c, Project__c 
                                            FROM Project_Milestone__c
                                            WHERE Project__c IN: projectIdsList]){
            if(!mapProjectIdToTotalMilestoneNumber.containsKey(milestone.Project__c)){
                mapProjectIdToCompleteMilestones.put(milestone.Project__c, 0);
                mapProjectIdToTotalMilestoneNumber.put(milestone.Project__c, 0);
            }

            mapProjectIdToTotalMilestoneNumber.put(milestone.Project__c, 
                    mapProjectIdToTotalMilestoneNumber.get(milestone.Project__c) + 1);
            if(milestone.Status__c == 'Complete'){
                mapProjectIdToCompleteMilestones.put(milestone.Project__c, 
                        mapProjectIdToCompleteMilestones.get(milestone.Project__c) + 1);
            }
        }

        Project__c auxProject = new Project__c();
        for(Id projectId : projectIdsList){
            auxProject.Id = projectId;
            auxProject.Percentage_of_Completion__c = mapProjectIdToTotalMilestoneNumber.containsKey(projectId)
                    ? mapProjectIdToCompleteMilestones.get(projectId) * 100 / mapProjectIdToTotalMilestoneNumber.get(projectId) 
                    : 0;
            auxProject.Status__c = auxProject.Percentage_of_Completion__c >= 100 ? 'Complete' 
                    : auxProject.Percentage_of_Completion__c > 0 ? 'In Progress'
                    : 'Not Started';
            
            projectUpdateList.add(auxProject);
        }

        if(!projectUpdateList.isEmpty()){
            update projectUpdateList;
        }
    }
}