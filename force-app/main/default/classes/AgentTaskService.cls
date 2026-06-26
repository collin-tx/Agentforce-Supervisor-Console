/**
 * @description Service class for Agent Task business logic
 * Handles task approval, rejection, escalation, and validation
 * @author Bob
 * @date 2026-06-26
 */
public with sharing class AgentTaskService {
    
    /**
     * @description Approves an Agent Task
     * @param task The Agent Task to approve
     * @param supervisorNotes Optional notes from the supervisor
     */
    public static void approveTask(Agent_Task__c task, String supervisorNotes) {
        validateTaskForStatusChange(task, 'Approved');
        
        task.Status__c = 'Approved';
        task.Reviewed_By__c = UserInfo.getUserId();
        task.Reviewed_Date__c = System.now();
        
        if (String.isNotBlank(supervisorNotes)) {
            task.Supervisor_Notes__c = supervisorNotes;
        }
        
        update task;
    }
    
    /**
     * @description Rejects an Agent Task
     * @param task The Agent Task to reject
     * @param supervisorNotes Required notes explaining rejection
     */
    public static void rejectTask(Agent_Task__c task, String supervisorNotes) {
        if (String.isBlank(supervisorNotes)) {
            throw new AgentTaskException('Supervisor notes are required when rejecting a task');
        }
        
        validateTaskForStatusChange(task, 'Rejected');
        
        task.Status__c = 'Rejected';
        task.Reviewed_By__c = UserInfo.getUserId();
        task.Reviewed_Date__c = System.now();
        task.Supervisor_Notes__c = supervisorNotes;
        
        update task;
    }
    
    /**
     * @description Escalates an Agent Task
     * @param task The Agent Task to escalate
     * @param supervisorNotes Required notes explaining escalation
     */
    public static void escalateTask(Agent_Task__c task, String supervisorNotes) {
        if (String.isBlank(supervisorNotes)) {
            throw new AgentTaskException('Supervisor notes are required when escalating a task');
        }
        
        validateTaskForStatusChange(task, 'Escalated');
        
        task.Status__c = 'Escalated';
        task.Supervisor_Notes__c = supervisorNotes;
        // Note: Escalated tasks don't set Reviewed_By/Reviewed_Date until final decision
        
        update task;
    }
    
    /**
     * @description Validates that a task can transition to a new status
     * @param task The Agent Task to validate
     * @param newStatus The proposed new status
     */
    private static void validateTaskForStatusChange(Agent_Task__c task, String newStatus) {
        if (task == null) {
            throw new AgentTaskException('Task cannot be null');
        }
        
        if (String.isBlank(newStatus)) {
            throw new AgentTaskException('New status cannot be blank');
        }
        
        // Validate status transitions
        String currentStatus = task.Status__c;
        
        // Can't change status if already approved or rejected
        if (currentStatus == 'Approved' || currentStatus == 'Rejected') {
            throw new AgentTaskException(
                'Cannot change status of a task that is already ' + currentStatus
            );
        }
        
        // Escalated tasks can be approved or rejected
        if (currentStatus == 'Escalated' && newStatus == 'Escalated') {
            throw new AgentTaskException('Task is already escalated');
        }
    }
    
    /**
     * @description Validates Agent Task data before insert/update
     * @param tasks List of Agent Tasks to validate
     */
    public static void validateTasks(List<Agent_Task__c> tasks) {
        for (Agent_Task__c task : tasks) {
            // Validate required fields
            if (String.isBlank(task.Description__c)) {
                throw new AgentTaskException('Description is required');
            }
            
            if (String.isBlank(task.Proposed_Action__c)) {
                throw new AgentTaskException('Proposed Action is required');
            }
            
            if (String.isBlank(task.Agent_Name__c)) {
                throw new AgentTaskException('Agent Name is required');
            }
            
            // Validate confidence score range
            if (task.Confidence_Score__c != null) {
                if (task.Confidence_Score__c < 0 || task.Confidence_Score__c > 100) {
                    throw new AgentTaskException('Confidence Score must be between 0 and 100');
                }
            }
            
            // Validate status
            if (String.isBlank(task.Status__c)) {
                task.Status__c = 'Pending Review'; // Default status
            }
        }
    }
    
    /**
     * @description Gets tasks that need review (Pending Review or Escalated)
     * @param limitCount Maximum number of records to return
     * @return List<Agent_Task__c> List of tasks needing review
     */
    public static List<Agent_Task__c> getTasksNeedingReview(Integer limitCount) {
        String query = 'SELECT Id, Name, Description__c, Proposed_Action__c, Status__c, ' +
                      'Confidence_Score__c, Agent_Name__c, Supervisor_Notes__c, ' +
                      'CreatedDate, LastModifiedDate ' +
                      'FROM Agent_Task__c ' +
                      'WHERE Status__c IN (\'Pending Review\', \'Escalated\') ' +
                      'ORDER BY CreatedDate ASC';
        
        if (limitCount != null && limitCount > 0) {
            query += ' LIMIT :limitCount';
        }
        
        return Database.query(query);
    }
    
    /**
     * @description Custom exception class for Agent Task errors
     */
    public class AgentTaskException extends Exception {}
}