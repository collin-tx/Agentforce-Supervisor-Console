/**
 * @description Test class for AgentTaskController
 * @author Bob
 * @date 2026-06-26
 */
@isTest
private class AgentTaskControllerTest {
    
    @isTest
    static void testGetAgentTasksWithoutFilter() {
        // Create test data
        List<Agent_Task__c> tasks = AgentTaskTestDataFactory.createAgentTasks(5, true);
        
        Test.startTest();
        List<Agent_Task__c> results = AgentTaskController.getAgentTasks(null, 10);
        Test.stopTest();
        
        Assert.areEqual(5, results.size(), 'Should return all 5 tasks');
        Assert.isNotNull(results[0].Name, 'Task should have a name');
    }
    
    @isTest
    static void testGetAgentTasksWithStatusFilter() {
        // Create test data with different statuses
        AgentTaskTestDataFactory.createAgentTask(true); // Pending Review
        AgentTaskTestDataFactory.createApprovedTask(true); // Approved
        AgentTaskTestDataFactory.createRejectedTask(true); // Rejected
        
        Test.startTest();
        List<Agent_Task__c> pendingTasks = AgentTaskController.getAgentTasks('Pending Review', 10);
        List<Agent_Task__c> approvedTasks = AgentTaskController.getAgentTasks('Approved', 10);
        Test.stopTest();
        
        Assert.areEqual(1, pendingTasks.size(), 'Should return 1 pending task');
        Assert.areEqual('Pending Review', pendingTasks[0].Status__c, 'Status should be Pending Review');
        Assert.areEqual(1, approvedTasks.size(), 'Should return 1 approved task');
        Assert.areEqual('Approved', approvedTasks[0].Status__c, 'Status should be Approved');
    }
    
    @isTest
    static void testGetAgentTasksWithLimit() {
        // Create 10 tasks
        AgentTaskTestDataFactory.createAgentTasks(10, true);
        
        Test.startTest();
        List<Agent_Task__c> results = AgentTaskController.getAgentTasks(null, 5);
        Test.stopTest();
        
        Assert.areEqual(5, results.size(), 'Should return only 5 tasks due to limit');
    }
    
    @isTest
    static void testGetAgentTasksError() {
        // Test error handling by passing invalid status
        Test.startTest();
        try {
            // This should work fine, just return empty list
            List<Agent_Task__c> results = AgentTaskController.getAgentTasks('InvalidStatus', 10);
            Assert.areEqual(0, results.size(), 'Should return empty list for invalid status');
        } catch (Exception e) {
            Assert.fail('Should not throw exception for invalid status filter');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testGetAgentTaskById() {
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(true);
        
        Test.startTest();
        Agent_Task__c result = AgentTaskController.getAgentTaskById(task.Id);
        Test.stopTest();
        
        Assert.isNotNull(result, 'Should return a task');
        Assert.areEqual(task.Id, result.Id, 'Should return the correct task');
        Assert.isNotNull(result.Description__c, 'Should include description');
    }
    
    @isTest
    static void testGetAgentTaskByIdNull() {
        Test.startTest();
        try {
            AgentTaskController.getAgentTaskById(null);
            Assert.fail('Should throw exception for null Id');
        } catch (AuraHandledException e) {
            Assert.isTrue(e.getMessage().contains('Task Id cannot be null'), 'Should mention task ID cannot be null');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testGetAgentTaskByIdNotFound() {
        // Create a fake Id that doesn't exist
        Id fakeId = Agent_Task__c.SObjectType.getDescribe().getKeyPrefix() + '0'.repeat(12);
        
        Test.startTest();
        try {
            AgentTaskController.getAgentTaskById(fakeId);
            Assert.fail('Should throw exception for non-existent task');
        } catch (AuraHandledException e) {
            Assert.isTrue(
                e.getMessage().contains('not found') || e.getMessage().contains('Error'),
                'Should indicate task not found'
            );
        }
        Test.stopTest();
    }
    
    @isTest
    static void testApproveTask() {
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(true);
        
        Test.startTest();
        Agent_Task__c result = AgentTaskController.approveTask(task.Id, 'Looks good!');
        Test.stopTest();
        
        Assert.areEqual('Approved', result.Status__c, 'Status should be Approved');
        Assert.areEqual(UserInfo.getUserId(), result.Reviewed_By__c, 'Reviewed by should be current user');
        Assert.isNotNull(result.Reviewed_Date__c, 'Reviewed date should be set');
        Assert.areEqual('Looks good!', result.Supervisor_Notes__c, 'Notes should be saved');
    }
    
    @isTest
    static void testApproveTaskWithoutNotes() {
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(true);
        
        Test.startTest();
        Agent_Task__c result = AgentTaskController.approveTask(task.Id, null);
        Test.stopTest();
        
        Assert.areEqual('Approved', result.Status__c, 'Status should be Approved');
        Assert.areEqual(UserInfo.getUserId(), result.Reviewed_By__c, 'Reviewed by should be current user');
    }
    
    @isTest
    static void testApproveTaskNull() {
        Test.startTest();
        try {
            AgentTaskController.approveTask(null, 'Notes');
            Assert.fail('Should throw exception for null Id');
        } catch (AuraHandledException e) {
            Assert.isTrue(e.getMessage().contains('Task Id cannot be null'), 'Should mention task ID cannot be null');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testRejectTask() {
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(true);
        
        Test.startTest();
        Agent_Task__c result = AgentTaskController.rejectTask(task.Id, 'Does not meet requirements');
        Test.stopTest();
        
        Assert.areEqual('Rejected', result.Status__c, 'Status should be Rejected');
        Assert.areEqual(UserInfo.getUserId(), result.Reviewed_By__c, 'Reviewed by should be current user');
        Assert.isNotNull(result.Reviewed_Date__c, 'Reviewed date should be set');
        Assert.areEqual('Does not meet requirements', result.Supervisor_Notes__c, 'Notes should be saved');
    }
    
    @isTest
    static void testRejectTaskWithoutNotes() {
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(true);
        
        Test.startTest();
        try {
            AgentTaskController.rejectTask(task.Id, null);
            Assert.fail('Should throw exception when notes are missing');
        } catch (AuraHandledException e) {
            Assert.isTrue(e.getMessage().contains('Supervisor notes are required'), 'Should mention notes are required');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testRejectTaskNull() {
        Test.startTest();
        try {
            AgentTaskController.rejectTask(null, 'Notes');
            Assert.fail('Should throw exception for null Id');
        } catch (AuraHandledException e) {
            Assert.isTrue(e.getMessage().contains('Task Id cannot be null'), 'Should mention task ID cannot be null');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testEscalateTask() {
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(true);
        
        Test.startTest();
        Agent_Task__c result = AgentTaskController.escalateTask(task.Id, 'Needs senior review');
        Test.stopTest();
        
        Assert.areEqual('Escalated', result.Status__c, 'Status should be Escalated');
        Assert.areEqual('Needs senior review', result.Supervisor_Notes__c, 'Notes should be saved');
    }
    
    @isTest
    static void testEscalateTaskWithoutNotes() {
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(true);
        
        Test.startTest();
        try {
            AgentTaskController.escalateTask(task.Id, '');
            Assert.fail('Should throw exception when notes are missing');
        } catch (AuraHandledException e) {
            Assert.isTrue(e.getMessage().contains('Supervisor notes are required'), 'Should mention notes are required');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testEscalateTaskNull() {
        Test.startTest();
        try {
            AgentTaskController.escalateTask(null, 'Notes');
            Assert.fail('Should throw exception for null Id');
        } catch (AuraHandledException e) {
            Assert.isTrue(e.getMessage().contains('Task Id cannot be null'), 'Should mention task ID cannot be null');
        }
        Test.stopTest();
    }
    
    @isTest
    static void testGetTaskCountsByStatus() {
        // Create tasks with different statuses
        AgentTaskTestDataFactory.createAgentTasks(3, true); // 3 Pending Review
        AgentTaskTestDataFactory.createApprovedTask(true); // 1 Approved
        AgentTaskTestDataFactory.createRejectedTask(true); // 1 Rejected
        AgentTaskTestDataFactory.createEscalatedTask(true); // 1 Escalated
        
        Test.startTest();
        Map<String, Integer> counts = AgentTaskController.getTaskCountsByStatus();
        Test.stopTest();
        
        Assert.areEqual(3, counts.get('Pending Review'), 'Should have 3 pending tasks');
        Assert.areEqual(1, counts.get('Approved'), 'Should have 1 approved task');
        Assert.areEqual(1, counts.get('Rejected'), 'Should have 1 rejected task');
        Assert.areEqual(1, counts.get('Escalated'), 'Should have 1 escalated task');
    }
    
    @isTest
    static void testGetTaskCountsByStatusEmpty() {
        Test.startTest();
        Map<String, Integer> counts = AgentTaskController.getTaskCountsByStatus();
        Test.stopTest();
        
        Assert.isNotNull(counts, 'Should return a map');
        Assert.areEqual(0, counts.size(), 'Should return empty map when no tasks exist');
    }
}