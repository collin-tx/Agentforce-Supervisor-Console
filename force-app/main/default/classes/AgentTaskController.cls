/**
 * @description Controller class for Agent Task Lightning Web Components
 * Provides @AuraEnabled methods for CRUD operations on Agent_Task__c records
 * @author Bob
 * @date 2026-06-26
 */
public with sharing class AgentTaskController {
    
    /**
     * @description Retrieves Agent Tasks with optional filtering
     * @param statusFilter Optional status to filter by (null returns all)
     * @param limitCount Maximum number of records to return
     * @return List<Agent_Task__c> List of Agent Task records
     */
    @AuraEnabled(cacheable=true)
    public static List<Agent_Task__c> getAgentTasks(String statusFilter, Integer limitCount) {
        try {
            String query = 'SELECT Id, Name, Description__c, Proposed_Action__c, Status__c, ' +
                          'Confidence_Score__c, Agent_Name__c, Supervisor_Notes__c, ' +
                          'Reviewed_By__c, Reviewed_By__r.Name, Reviewed_Date__c, ' +
                          'CreatedDate, LastModifiedDate ' +
                          'FROM Agent_Task__c ';
            
            if (String.isNotBlank(statusFilter)) {
                query += 'WHERE Status__c = :statusFilter ';
            }
            
            query += 'ORDER BY CreatedDate DESC ';
            
            if (limitCount != null && limitCount > 0) {
                query += 'LIMIT :limitCount';
            }
            
            return Database.query(query);
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving Agent Tasks: ' + e.getMessage());
        }
    }
    
    /**
     * @description Retrieves a single Agent Task by Id
     * @param taskId The Id of the Agent Task to retrieve
     * @return Agent_Task__c The Agent Task record
     */
    @AuraEnabled(cacheable=true)
    public static Agent_Task__c getAgentTaskById(Id taskId) {
        try {
            if (taskId == null) {
                throw new IllegalArgumentException('Task Id cannot be null');
            }
            
            return [
                SELECT Id, Name, Description__c, Proposed_Action__c, Status__c,
                       Confidence_Score__c, Agent_Name__c, Supervisor_Notes__c,
                       Reviewed_By__c, Reviewed_By__r.Name, Reviewed_Date__c,
                       CreatedDate, LastModifiedDate
                FROM Agent_Task__c
                WHERE Id = :taskId
                LIMIT 1
            ];
        } catch (QueryException e) {
            throw new AuraHandledException('Agent Task not found: ' + e.getMessage());
        } catch (Exception e) {
            throw new AuraHandledException('Error retrieving Agent Task: ' + e.getMessage());
        }
    }
    
    /**
     * @description Approves an Agent Task
     * @param taskId The Id of the Agent Task to approve
     * @param supervisorNotes Optional notes from the supervisor
     * @return Agent_Task__c The updated Agent Task record
     */
    @AuraEnabled
    public static Agent_Task__c approveTask(Id taskId, String supervisorNotes) {
        try {
            if (taskId == null) {
                throw new IllegalArgumentException('Task Id cannot be null');
            }
            
            Agent_Task__c task = [
                SELECT Id, Status__c
                FROM Agent_Task__c
                WHERE Id = :taskId
                LIMIT 1
            ];
            
            // Use service layer for business logic
            AgentTaskService.approveTask(task, supervisorNotes);
            
            // Return updated record
            return getAgentTaskById(taskId);
        } catch (Exception e) {
            throw new AuraHandledException('Error approving task: ' + e.getMessage());
        }
    }
    
    /**
     * @description Rejects an Agent Task
     * @param taskId The Id of the Agent Task to reject
     * @param supervisorNotes Required notes explaining rejection
     * @return Agent_Task__c The updated Agent Task record
     */
    @AuraEnabled
    public static Agent_Task__c rejectTask(Id taskId, String supervisorNotes) {
        try {
            if (taskId == null) {
                throw new IllegalArgumentException('Task Id cannot be null');
            }
            
            if (String.isBlank(supervisorNotes)) {
                throw new IllegalArgumentException('Supervisor notes are required for rejection');
            }
            
            Agent_Task__c task = [
                SELECT Id, Status__c
                FROM Agent_Task__c
                WHERE Id = :taskId
                LIMIT 1
            ];
            
            // Use service layer for business logic
            AgentTaskService.rejectTask(task, supervisorNotes);
            
            // Return updated record
            return getAgentTaskById(taskId);
        } catch (Exception e) {
            throw new AuraHandledException('Error rejecting task: ' + e.getMessage());
        }
    }
    
    /**
     * @description Escalates an Agent Task
     * @param taskId The Id of the Agent Task to escalate
     * @param supervisorNotes Required notes explaining escalation
     * @return Agent_Task__c The updated Agent Task record
     */
    @AuraEnabled
    public static Agent_Task__c escalateTask(Id taskId, String supervisorNotes) {
        try {
            if (taskId == null) {
                throw new IllegalArgumentException('Task Id cannot be null');
            }
            
            if (String.isBlank(supervisorNotes)) {
                throw new IllegalArgumentException('Supervisor notes are required for escalation');
            }
            
            Agent_Task__c task = [
                SELECT Id, Status__c
                FROM Agent_Task__c
                WHERE Id = :taskId
                LIMIT 1
            ];
            
            // Use service layer for business logic
            AgentTaskService.escalateTask(task, supervisorNotes);
            
            // Return updated record
            return getAgentTaskById(taskId);
        } catch (Exception e) {
            throw new AuraHandledException('Error escalating task: ' + e.getMessage());
        }
    }
    
    /**
     * @description Gets count of tasks by status
     * @return Map<String, Integer> Map of status to count
     */
    @AuraEnabled(cacheable=true)
    public static Map<String, Integer> getTaskCountsByStatus() {
        try {
            Map<String, Integer> countMap = new Map<String, Integer>();
            
            for (AggregateResult ar : [
                SELECT Status__c, COUNT(Id) taskCount
                FROM Agent_Task__c
                GROUP BY Status__c
            ]) {
                String status = (String) ar.get('Status__c');
                Integer count = (Integer) ar.get('taskCount');
                countMap.put(status, count);
            }
            
            return countMap;
        } catch (Exception e) {
            throw new AuraHandledException('Error getting task counts: ' + e.getMessage());
        }
    }
}