/**
 * @description Test class for AgentTaskService
 * @author Bob
 * @date 2026-06-26
 */
@isTest
private class AgentTaskServiceTest {
    
    @isTest
    static void testApproveTask() {
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(true);
        
        Test.startTest();
        AgentTaskService.approveTask(task, 'Approved by supervisor');
        Test.stopTest();
        
        // Verify the task was updated
        Agent_Task__c updatedTask = [
            SELECT Id, Status__c, Reviewed_By__c, Reviewed_Date__c, Supervisor_Notes__c
            FROM Agent_Task__c
            WHERE Id = :task.Id
        ];
        
        Assert.areEqual('Approved', updatedTask.Status__c, 'Status should be Approved');
        Assert.areEqual(UserInfo.getUserId(), updatedTask.Reviewed_By__c, 'Reviewed by should be current user');
        Assert.isNotNull(updatedTask.Reviewed_Date__c, 'Reviewed date should be set');
        Assert.areEqual('Approved by supervisor', updatedTask.Supervisor_Notes__c, 'Notes should be saved');
    }
    
    @isTest
    static void testApproveTaskWithoutNotes() {
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(true);
        
        Test.startTest();
        AgentTaskService.approveTask(task, null);
        Test.stopTest();
        
        Agent_Task__c updatedTask = [
            SELECT Id, Status__c, Reviewed_By__c, Reviewed_Date__c
            FROM Agent_Task__c
            WHERE Id = :task.Id
        ];
        
        Assert.areEqual('Approved', updatedTask.Status__c, 'Status should be Approved');
        Assert.areEqual(UserInfo.getUserId(), updatedTask.Reviewed_By__c, 'Reviewed by should be current user');
    }
    
    @isTest
    static void testApproveTaskNull() {
        Test.startTest();
        try {
            AgentTaskService.approveTask(null, 'Notes');
            Assert.fail('Should throw exception for null task');
        } catch (AgentTaskService.AgentTaskException e) {
            Assert.isTrue(e.getMessage().contains('cannot be null'), 'Should mention task cannot be null');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testApproveAlreadyApprovedTask() {
        Agent_Task__c task = AgentTaskTestDataFactory.createApprovedTask(true);
        
        Test.startTest();
        try {
            AgentTaskService.approveTask(task, 'Try to approve again');
            Assert.fail('Should throw exception when trying to approve already approved task');
        } catch (AgentTaskService.AgentTaskException e) {
            Assert.isTrue(e.getMessage().contains('already'), 'Should mention task is already approved');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testRejectTask() {
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(true);
        
        Test.startTest();
        AgentTaskService.rejectTask(task, 'Does not meet requirements');
        Test.stopTest();
        
        Agent_Task__c updatedTask = [
            SELECT Id, Status__c, Reviewed_By__c, Reviewed_Date__c, Supervisor_Notes__c
            FROM Agent_Task__c
            WHERE Id = :task.Id
        ];
        
        Assert.areEqual('Rejected', updatedTask.Status__c, 'Status should be Rejected');
        Assert.areEqual(UserInfo.getUserId(), updatedTask.Reviewed_By__c, 'Reviewed by should be current user');
        Assert.isNotNull(updatedTask.Reviewed_Date__c, 'Reviewed date should be set');
        Assert.areEqual('Does not meet requirements', updatedTask.Supervisor_Notes__c, 'Notes should be saved');
    }
    
    @isTest
    static void testRejectTaskWithoutNotes() {
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(true);
        
        Test.startTest();
        try {
            AgentTaskService.rejectTask(task, null);
            Assert.fail('Should throw exception when notes are missing');
        } catch (AgentTaskService.AgentTaskException e) {
            Assert.isTrue(e.getMessage().contains('required'), 'Should mention notes are required');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testRejectTaskNull() {
        Test.startTest();
        try {
            AgentTaskService.rejectTask(null, 'Notes');
            Assert.fail('Should throw exception for null task');
        } catch (AgentTaskService.AgentTaskException e) {
            Assert.isTrue(e.getMessage().contains('cannot be null'), 'Should mention task cannot be null');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testRejectAlreadyRejectedTask() {
        Agent_Task__c task = AgentTaskTestDataFactory.createRejectedTask(true);
        
        Test.startTest();
        try {
            AgentTaskService.rejectTask(task, 'Try to reject again');
            Assert.fail('Should throw exception when trying to reject already rejected task');
        } catch (AgentTaskService.AgentTaskException e) {
            Assert.isTrue(e.getMessage().contains('already'), 'Should mention task is already rejected');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testEscalateTask() {
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(true);
        
        Test.startTest();
        AgentTaskService.escalateTask(task, 'Needs senior review');
        Test.stopTest();
        
        Agent_Task__c updatedTask = [
            SELECT Id, Status__c, Supervisor_Notes__c, Reviewed_By__c, Reviewed_Date__c
            FROM Agent_Task__c
            WHERE Id = :task.Id
        ];
        
        Assert.areEqual('Escalated', updatedTask.Status__c, 'Status should be Escalated');
        Assert.areEqual('Needs senior review', updatedTask.Supervisor_Notes__c, 'Notes should be saved');
        Assert.isNull(updatedTask.Reviewed_By__c, 'Reviewed by should not be set for escalation');
        Assert.isNull(updatedTask.Reviewed_Date__c, 'Reviewed date should not be set for escalation');
    }
    
    @isTest
    static void testEscalateTaskWithoutNotes() {
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(true);
        
        Test.startTest();
        try {
            AgentTaskService.escalateTask(task, '');
            Assert.fail('Should throw exception when notes are missing');
        } catch (AgentTaskService.AgentTaskException e) {
            Assert.isTrue(e.getMessage().contains('required'), 'Should mention notes are required');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testEscalateTaskNull() {
        Test.startTest();
        try {
            AgentTaskService.escalateTask(null, 'Notes');
            Assert.fail('Should throw exception for null task');
        } catch (AgentTaskService.AgentTaskException e) {
            Assert.isTrue(e.getMessage().contains('cannot be null'), 'Should mention task cannot be null');
        }
        Test.stopTest();
    }
    @isTest
    static void testEscalateAlreadyEscalatedTask() {
        Agent_Task__c task = AgentTaskTestDataFactory.createEscalatedTask(true);
        
        Test.startTest();
        try {
            AgentTaskService.escalateTask(task, 'Try to escalate again');
            Assert.fail('Should throw exception when trying to escalate already escalated task');
        } catch (AgentTaskService.AgentTaskException e) {
            Assert.isTrue(e.getMessage().contains('already escalated'), 'Should mention task is already escalated');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testApproveEscalatedTask() {
        Agent_Task__c task = AgentTaskTestDataFactory.createEscalatedTask(true);
        
        Test.startTest();
        AgentTaskService.approveTask(task, 'Approved after escalation');
        Test.stopTest();
        
        Agent_Task__c updatedTask = [
            SELECT Id, Status__c, Reviewed_By__c, Reviewed_Date__c
            FROM Agent_Task__c
            WHERE Id = :task.Id
        ];
        
        Assert.areEqual('Approved', updatedTask.Status__c, 'Escalated task should be approvable');
        Assert.areEqual(UserInfo.getUserId(), updatedTask.Reviewed_By__c, 'Reviewed by should be set');
    }
    
    @isTest
    static void testApproveRejectedTask() {
        Agent_Task__c task = AgentTaskTestDataFactory.createRejectedTask(true);
        
        Test.startTest();
        try {
            AgentTaskService.approveTask(task, 'Trying to approve rejected task');
            Assert.fail('Should throw exception when trying to approve rejected task');
        } catch (AgentTaskService.AgentTaskException e) {
            Assert.isTrue(e.getMessage().contains('already Rejected'), 'Should mention task is already rejected');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testRejectApprovedTask() {
        Agent_Task__c task = AgentTaskTestDataFactory.createApprovedTask(true);
        
        Test.startTest();
        try {
            AgentTaskService.rejectTask(task, 'Trying to reject approved task');
            Assert.fail('Should throw exception when trying to reject approved task');
        } catch (AgentTaskService.AgentTaskException e) {
            Assert.isTrue(e.getMessage().contains('already Approved'), 'Should mention task is already approved');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testValidateTasksSuccess() {
        List<Agent_Task__c> tasks = new List<Agent_Task__c>{
            new Agent_Task__c(
                Description__c = 'Valid description',
                Proposed_Action__c = 'Valid action',
                Agent_Name__c = 'ValidAgent',
                Confidence_Score__c = 85.5
            )
        };
        
        Test.startTest();
        try {
            AgentTaskService.validateTasks(tasks);
            // Should not throw exception
            Assert.isTrue(true, 'Validation should pass');
        } catch (Exception e) {
            Assert.fail('Should not throw exception for valid tasks: ' + e.getMessage());
        }
        Test.stopTest();
    }
    
    @isTest
    static void testValidateTasksMissingDescription() {
        List<Agent_Task__c> tasks = new List<Agent_Task__c>{
            new Agent_Task__c(
                Proposed_Action__c = 'Valid action',
                Agent_Name__c = 'ValidAgent'
            )
        };
        
        Test.startTest();
        try {
            AgentTaskService.validateTasks(tasks);
            Assert.fail('Should throw exception for missing description');
        } catch (AgentTaskService.AgentTaskException e) {
            Assert.isTrue(e.getMessage().contains('Description'), 'Should mention description is required');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testValidateTasksMissingProposedAction() {
        List<Agent_Task__c> tasks = new List<Agent_Task__c>{
            new Agent_Task__c(
                Description__c = 'Valid description',
                Agent_Name__c = 'ValidAgent'
            )
        };
        
        Test.startTest();
        try {
            AgentTaskService.validateTasks(tasks);
            Assert.fail('Should throw exception for missing proposed action');
        } catch (AgentTaskService.AgentTaskException e) {
            Assert.isTrue(e.getMessage().contains('Proposed Action'), 'Should mention proposed action is required');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testValidateTasksMissingAgentName() {
        List<Agent_Task__c> tasks = new List<Agent_Task__c>{
            new Agent_Task__c(
                Description__c = 'Valid description',
                Proposed_Action__c = 'Valid action'
            )
        };
        
        Test.startTest();
        try {
            AgentTaskService.validateTasks(tasks);
            Assert.fail('Should throw exception for missing agent name');
        } catch (AgentTaskService.AgentTaskException e) {
            Assert.isTrue(e.getMessage().contains('Agent Name'), 'Should mention agent name is required');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testValidateTasksInvalidConfidenceScore() {
        List<Agent_Task__c> tasks = new List<Agent_Task__c>{
            new Agent_Task__c(
                Description__c = 'Valid description',
                Proposed_Action__c = 'Valid action',
                Agent_Name__c = 'ValidAgent',
                Confidence_Score__c = 150.0 // Invalid: > 100
            )
        };
        
        Test.startTest();
        try {
            AgentTaskService.validateTasks(tasks);
            Assert.fail('Should throw exception for invalid confidence score');
        } catch (AgentTaskService.AgentTaskException e) {
            Assert.isTrue(e.getMessage().contains('Confidence Score'), 'Should mention confidence score range');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testValidateTasksDefaultStatus() {
        List<Agent_Task__c> tasks = new List<Agent_Task__c>{
            new Agent_Task__c(
                Description__c = 'Valid description',
                Proposed_Action__c = 'Valid action',
                Agent_Name__c = 'ValidAgent'
            )
        };
        
        Test.startTest();
        AgentTaskService.validateTasks(tasks);
        Test.stopTest();
        
        Assert.areEqual('Pending Review', tasks[0].Status__c, 'Should default to Pending Review');
    }
    
    @isTest
    static void testGetTasksNeedingReview() {
        // Create tasks with different statuses
        AgentTaskTestDataFactory.createAgentTasks(2, true); // Pending Review
        AgentTaskTestDataFactory.createEscalatedTask(true); // Escalated
        AgentTaskTestDataFactory.createApprovedTask(true); // Approved (should not be included)
        AgentTaskTestDataFactory.createRejectedTask(true); // Rejected (should not be included)
        
        Test.startTest();
        List<Agent_Task__c> tasksNeedingReview = AgentTaskService.getTasksNeedingReview(10);
        Test.stopTest();
        
        Assert.areEqual(3, tasksNeedingReview.size(), 'Should return 3 tasks needing review');
        
        // Verify only Pending Review and Escalated tasks are returned
        for (Agent_Task__c task : tasksNeedingReview) {
            Assert.isTrue(
                task.Status__c == 'Pending Review' || task.Status__c == 'Escalated',
                'Should only return tasks needing review'
            );
        }
    }
    
    @isTest
    static void testGetTasksNeedingReviewWithLimit() {
        AgentTaskTestDataFactory.createAgentTasks(5, true);
        
        Test.startTest();
        List<Agent_Task__c> tasksNeedingReview = AgentTaskService.getTasksNeedingReview(3);
        Test.stopTest();
        
        Assert.areEqual(3, tasksNeedingReview.size(), 'Should respect limit parameter');
    }
    
    @isTest
    static void testGetTasksNeedingReviewEmpty() {
        // Create only approved and rejected tasks
        AgentTaskTestDataFactory.createApprovedTask(true);
        AgentTaskTestDataFactory.createRejectedTask(true);
        
        Test.startTest();
        List<Agent_Task__c> tasksNeedingReview = AgentTaskService.getTasksNeedingReview(10);
        Test.stopTest();
        
        Assert.areEqual(0, tasksNeedingReview.size(), 'Should return empty list when no tasks need review');
    }
}