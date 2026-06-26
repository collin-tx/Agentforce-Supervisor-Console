/**
 * @description Test data factory for Agent_Task__c records
 * @author Bob
 * @date 2026-06-25
 */
@isTest
public class AgentTaskTestDataFactory {
    
    /**
     * @description Creates a single Agent_Task__c record with default values
     * @param doInsert Whether to insert the record or just return it
     * @return Agent_Task__c The created record
     */
    public static Agent_Task__c createAgentTask(Boolean doInsert) {
        Agent_Task__c task = new Agent_Task__c(
            Description__c = 'Test agent task description',
            Proposed_Action__c = 'Test proposed action payload',
            Status__c = 'Pending Review',
            Confidence_Score__c = 85.5,
            Agent_Name__c = 'TestAgent'
        );
        
        if (doInsert) {
            insert task;
        }
        
        return task;
    }
    
    /**
     * @description Creates a single Agent_Task__c record with custom values
     * @param description Task description
     * @param proposedAction Proposed action payload
     * @param status Task status
     * @param confidenceScore Agent confidence score
     * @param agentName Name of the agent
     * @param doInsert Whether to insert the record or just return it
     * @return Agent_Task__c The created record
     */
    public static Agent_Task__c createAgentTask(
        String description,
        String proposedAction,
        String status,
        Decimal confidenceScore,
        String agentName,
        Boolean doInsert
    ) {
        Agent_Task__c task = new Agent_Task__c(
            Description__c = description,
            Proposed_Action__c = proposedAction,
            Status__c = status,
            Confidence_Score__c = confidenceScore,
            Agent_Name__c = agentName
        );
        
        if (doInsert) {
            insert task;
        }
        
        return task;
    }
    
    /**
     * @description Creates multiple Agent_Task__c records with default values
     * @param count Number of records to create
     * @param doInsert Whether to insert the records or just return them
     * @return List<Agent_Task__c> The created records
     */
    public static List<Agent_Task__c> createAgentTasks(Integer count, Boolean doInsert) {
        List<Agent_Task__c> tasks = new List<Agent_Task__c>();
        
        for (Integer i = 0; i < count; i++) {
            tasks.add(new Agent_Task__c(
                Description__c = 'Test agent task description ' + i,
                Proposed_Action__c = 'Test proposed action payload ' + i,
                Status__c = 'Pending Review',
                Confidence_Score__c = 80.0 + i,
                Agent_Name__c = 'TestAgent' + i
            ));
        }
        
        if (doInsert) {
            insert tasks;
        }
        
        return tasks;
    }
    
    /**
     * @description Creates an approved Agent_Task__c record
     * @param doInsert Whether to insert the record or just return it
     * @return Agent_Task__c The created record
     */
    public static Agent_Task__c createApprovedTask(Boolean doInsert) {
        Agent_Task__c task = new Agent_Task__c(
            Description__c = 'Approved task description',
            Proposed_Action__c = 'Approved action payload',
            Status__c = 'Approved',
            Confidence_Score__c = 95.0,
            Agent_Name__c = 'ApprovedAgent',
            Reviewed_By__c = UserInfo.getUserId(),
            Reviewed_Date__c = System.now(),
            Supervisor_Notes__c = 'Looks good, approved!'
        );
        
        if (doInsert) {
            insert task;
        }
        
        return task;
    }
    
    /**
     * @description Creates a rejected Agent_Task__c record
     * @param doInsert Whether to insert the record or just return it
     * @return Agent_Task__c The created record
     */
    public static Agent_Task__c createRejectedTask(Boolean doInsert) {
        Agent_Task__c task = new Agent_Task__c(
            Description__c = 'Rejected task description',
            Proposed_Action__c = 'Rejected action payload',
            Status__c = 'Rejected',
            Confidence_Score__c = 45.0,
            Agent_Name__c = 'RejectedAgent',
            Reviewed_By__c = UserInfo.getUserId(),
            Reviewed_Date__c = System.now(),
            Supervisor_Notes__c = 'Does not meet requirements'
        );
        
        if (doInsert) {
            insert task;
        }
        
        return task;
    }
    
    /**
     * @description Creates an escalated Agent_Task__c record
     * @param doInsert Whether to insert the record or just return it
     * @return Agent_Task__c The created record
     */
    public static Agent_Task__c createEscalatedTask(Boolean doInsert) {
        Agent_Task__c task = new Agent_Task__c(
            Description__c = 'Escalated task description',
            Proposed_Action__c = 'Escalated action payload',
            Status__c = 'Escalated',
            Confidence_Score__c = 60.0,
            Agent_Name__c = 'EscalatedAgent',
            Supervisor_Notes__c = 'Needs senior review'
        );
        
        if (doInsert) {
            insert task;
        }
        
        return task;
    }
}