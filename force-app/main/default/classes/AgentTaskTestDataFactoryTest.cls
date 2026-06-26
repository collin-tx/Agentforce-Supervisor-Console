/**
 * @description Test class for AgentTaskTestDataFactory
 * @author Bob
 * @date 2026-06-25
 */
@isTest
private class AgentTaskTestDataFactoryTest {
    
    @isTest
    static void testCreateSingleAgentTaskWithInsert() {
        Test.startTest();
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(true);
        Test.stopTest();
        
        // Verify the task was inserted
        Agent_Task__c insertedTask = [
            SELECT Id, Description__c, Proposed_Action__c, Status__c, 
                   Confidence_Score__c, Agent_Name__c
            FROM Agent_Task__c
            WHERE Id = :task.Id
        ];
        
        Assert.isNotNull(insertedTask.Id, 'Task should have an Id');
        Assert.areEqual('Test agent task description', insertedTask.Description__c, 'Description should match');
        Assert.areEqual('Test proposed action payload', insertedTask.Proposed_Action__c, 'Proposed action should match');
        Assert.areEqual('Pending Review', insertedTask.Status__c, 'Status should be Pending Review');
        Assert.areEqual(85.5, insertedTask.Confidence_Score__c, 'Confidence score should match');
        Assert.areEqual('TestAgent', insertedTask.Agent_Name__c, 'Agent name should match');
    }
    
    @isTest
    static void testCreateSingleAgentTaskWithoutInsert() {
        Test.startTest();
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(false);
        Test.stopTest();
        
        // Verify the task was not inserted
        Assert.isNull(task.Id, 'Task should not have an Id');
        Assert.areEqual('Test agent task description', task.Description__c, 'Description should match');
        Assert.areEqual('Pending Review', task.Status__c, 'Status should be Pending Review');
    }
    
    @isTest
    static void testCreateAgentTaskWithCustomValues() {
        Test.startTest();
        Agent_Task__c task = AgentTaskTestDataFactory.createAgentTask(
            'Custom description',
            'Custom action',
            'Approved',
            92.5,
            'CustomAgent',
            true
        );
        Test.stopTest();
        
        // Verify custom values
        Agent_Task__c insertedTask = [
            SELECT Id, Description__c, Proposed_Action__c, Status__c, 
                   Confidence_Score__c, Agent_Name__c
            FROM Agent_Task__c
            WHERE Id = :task.Id
        ];
        
        Assert.areEqual('Custom description', insertedTask.Description__c, 'Custom description should match');
        Assert.areEqual('Custom action', insertedTask.Proposed_Action__c, 'Custom action should match');
        Assert.areEqual('Approved', insertedTask.Status__c, 'Status should be Approved');
        Assert.areEqual(92.5, insertedTask.Confidence_Score__c, 'Confidence score should match');
        Assert.areEqual('CustomAgent', insertedTask.Agent_Name__c, 'Agent name should match');
    }
    
    @isTest
    static void testCreateMultipleAgentTasksWithInsert() {
        Integer taskCount = 5;
        
        Test.startTest();
        List<Agent_Task__c> tasks = AgentTaskTestDataFactory.createAgentTasks(taskCount, true);
        Test.stopTest();
        
        // Verify the correct number of tasks were created
        Assert.areEqual(taskCount, tasks.size(), 'Should create correct number of tasks');
        
        // Verify all tasks were inserted
        List<Agent_Task__c> insertedTasks = [
            SELECT Id, Description__c, Agent_Name__c, Confidence_Score__c
            FROM Agent_Task__c
        ];
        
        Assert.areEqual(taskCount, insertedTasks.size(), 'All tasks should be inserted');
        
        // Verify unique values for each task
        for (Integer i = 0; i < taskCount; i++) {
            Assert.isTrue(
                tasks[i].Description__c.contains(String.valueOf(i)),
                'Description should contain index'
            );
            Assert.isTrue(
                tasks[i].Agent_Name__c.contains(String.valueOf(i)),
                'Agent name should contain index'
            );
        }
    }
    
    @isTest
    static void testCreateMultipleAgentTasksWithoutInsert() {
        Integer taskCount = 3;
        
        Test.startTest();
        List<Agent_Task__c> tasks = AgentTaskTestDataFactory.createAgentTasks(taskCount, false);
        Test.stopTest();
        
        // Verify the correct number of tasks were created
        Assert.areEqual(taskCount, tasks.size(), 'Should create correct number of tasks');
        
        // Verify none were inserted
        for (Agent_Task__c task : tasks) {
            Assert.isNull(task.Id, 'Task should not have an Id');
        }
    }
    
    @isTest
    static void testCreateApprovedTask() {
        Test.startTest();
        Agent_Task__c task = AgentTaskTestDataFactory.createApprovedTask(true);
        Test.stopTest();
        
        // Verify approved task properties
        Agent_Task__c insertedTask = [
            SELECT Id, Description__c, Status__c, Confidence_Score__c, 
                   Agent_Name__c, Reviewed_By__c, Reviewed_Date__c, Supervisor_Notes__c
            FROM Agent_Task__c
            WHERE Id = :task.Id
        ];
        
        Assert.areEqual('Approved', insertedTask.Status__c, 'Status should be Approved');
        Assert.areEqual(95.0, insertedTask.Confidence_Score__c, 'Confidence score should be high');
        Assert.areEqual('ApprovedAgent', insertedTask.Agent_Name__c, 'Agent name should match');
        Assert.areEqual(UserInfo.getUserId(), insertedTask.Reviewed_By__c, 'Reviewed by should be current user');
        Assert.isNotNull(insertedTask.Reviewed_Date__c, 'Reviewed date should be set');
        Assert.areEqual('Looks good, approved!', insertedTask.Supervisor_Notes__c, 'Supervisor notes should match');
    }
    
    @isTest
    static void testCreateRejectedTask() {
        Test.startTest();
        Agent_Task__c task = AgentTaskTestDataFactory.createRejectedTask(true);
        Test.stopTest();
        
        // Verify rejected task properties
        Agent_Task__c insertedTask = [
            SELECT Id, Description__c, Status__c, Confidence_Score__c, 
                   Agent_Name__c, Reviewed_By__c, Reviewed_Date__c, Supervisor_Notes__c
            FROM Agent_Task__c
            WHERE Id = :task.Id
        ];
        
        Assert.areEqual('Rejected', insertedTask.Status__c, 'Status should be Rejected');
        Assert.areEqual(45.0, insertedTask.Confidence_Score__c, 'Confidence score should be low');
        Assert.areEqual('RejectedAgent', insertedTask.Agent_Name__c, 'Agent name should match');
        Assert.areEqual(UserInfo.getUserId(), insertedTask.Reviewed_By__c, 'Reviewed by should be current user');
        Assert.isNotNull(insertedTask.Reviewed_Date__c, 'Reviewed date should be set');
        Assert.areEqual('Does not meet requirements', insertedTask.Supervisor_Notes__c, 'Supervisor notes should match');
    }
    
    @isTest
    static void testCreateEscalatedTask() {
        Test.startTest();
        Agent_Task__c task = AgentTaskTestDataFactory.createEscalatedTask(true);
        Test.stopTest();
        
        // Verify escalated task properties
        Agent_Task__c insertedTask = [
            SELECT Id, Description__c, Status__c, Confidence_Score__c, 
                   Agent_Name__c, Supervisor_Notes__c
            FROM Agent_Task__c
            WHERE Id = :task.Id
        ];
        
        Assert.areEqual('Escalated', insertedTask.Status__c, 'Status should be Escalated');
        Assert.areEqual(60.0, insertedTask.Confidence_Score__c, 'Confidence score should be medium');
        Assert.areEqual('EscalatedAgent', insertedTask.Agent_Name__c, 'Agent name should match');
        Assert.areEqual('Needs senior review', insertedTask.Supervisor_Notes__c, 'Supervisor notes should match');
    }
    
    @isTest
    static void testBulkOperations() {
        // Test bulk creation to ensure no governor limits are hit
        Integer bulkCount = 200;
        
        Test.startTest();
        List<Agent_Task__c> tasks = AgentTaskTestDataFactory.createAgentTasks(bulkCount, true);
        Test.stopTest();
        
        // Verify bulk insert succeeded
        List<Agent_Task__c> insertedTasks = [
            SELECT Id
            FROM Agent_Task__c
        ];
        
        Assert.areEqual(bulkCount, insertedTasks.size(), 'All bulk tasks should be inserted');
        Assert.areEqual(bulkCount, tasks.size(), 'Should return correct number of tasks');
    }
}