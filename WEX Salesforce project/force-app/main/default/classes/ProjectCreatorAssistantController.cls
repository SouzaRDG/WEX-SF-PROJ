
public with sharing class ProjectCreatorAssistantController {
    @AuraEnabled
    public static void saveRecords(String data) {
        Map<String, Object> parsedData = (Map<String, Object>) JSON.deserializeUntyped(data);
        String projectName = (String) parsedData.get('projectName');
        List<Object> milestones = (List<Object>) parsedData.get('milestones');
        
        Project__c project = new Project__c(Name = projectName);

        insert project;
        List<Project_Milestone__c> milestonesList = new List<Project_Milestone__c>();
        List<List<Task>> taskListList = new List<List<Task>>();
        Integer auxIndex = 0;

        for (Object milestoneObj : milestones) {
            Map<String, Object> milestoneMap = (Map<String, Object>) milestoneObj;
            Project_Milestone__c milestone = new Project_Milestone__c(
                Name = (String) milestoneMap.get('name'),
                Project__c = project.Id
            );

            milestonesList.add(milestone);
            List<Task> auxTaskList = new List<Task>();

            List<Object> tasks = (List<Object>) milestoneMap.get('tasks');
            for (Object taskObj : tasks) {
                Map<String, Object> taskMap = (Map<String, Object>) taskObj;
                Task task = new Task(
                    Subject = (String) taskMap.get('name'),
                    WhatId = milestone.Id
                );
                auxTaskList.add(task);
            }
            taskListList.add(auxTaskList);
        }

        if(!milestonesList.isEmpty()) insert milestonesList;

        List<Task> taskToInsertList = new List<Task>();
        
        for(Integer index = 0; index < taskListList.size(); index++){
            for(Task task : taskListList[index]){
                task.WhatId = milestonesList[index].Id;
                taskToInsertList.add(task);
            }
        }

        if(!taskToInsertList.isEmpty()) insert taskToInsertList;
    }
}