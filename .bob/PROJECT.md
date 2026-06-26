# Agent Supervisor Console

## Project Overview

A human-in-the-loop Lightning Web Component (LWC) UI for reviewing and approving AI agent tasks, built on the Salesforce platform.

## Purpose

This application provides a supervisory interface where human operators can:
- Review tasks proposed or executed by AI agents
- Approve or reject agent actions
- Monitor agent activity and decision-making
- Maintain oversight and control over automated processes

## Technology Stack

- **Frontend**: Lightning Web Components (LWC)
- **Backend**: Apex (Salesforce)
- **Platform**: Salesforce (Scratch Org)
- **Data Model**: Custom Objects for Agent Tasks

## Architecture

### Components
1. **Custom Objects**
   - `Agent_Task__c` - Stores agent task proposals and execution records

2. **Apex Classes**
   - Mock agent implementation for testing
   - Task management and approval logic
   - Data access layer

3. **Lightning Web Components**
   - Supervisor dashboard
   - Task review interface
   - Approval/rejection controls

## Development Environment

- **Project Name**: supervisor-console
- **Scratch Org**: supervisor-dev (see local CLI auth)
- **Dev Hub**: [configured locally]

## Key Features

- Real-time task monitoring
- Human approval workflow
- Agent task history
- Audit trail for all decisions
- Intuitive UI for supervisors

## Goals

1. Provide transparency into AI agent operations
2. Enable human oversight and intervention
3. Build trust in automated systems
4. Maintain compliance and control
5. Create a scalable supervision framework

## AppExchange/Packaging Requirements

This project is designed for distribution via Salesforce AppExchange or as a managed/unlocked package. To ensure package readiness:

### Best Practices
- **No Hardcoded IDs**: All references use dynamic queries, custom metadata, or custom settings
- **Named Credentials**: External API calls use Named Credentials for secure, configurable authentication
- **Test Coverage**: Maintain 75%+ code coverage from day one, not bolted on at the end
- **Namespace Ready**: Code structure supports namespace prefixes for managed packages
- **Security First**: Field-level security, sharing rules, and permission sets properly configured
- **Documentation**: Comprehensive inline documentation and user guides

## Data Model

### Agent_Task__c
| Field | API Name | Type | Notes |
|-------|----------|------|-------|
| Task Name | Name | Auto Number | AT-{0000} |
| Description | Description__c | Long Text Area | What the agent wants to do |
| Proposed Action | Proposed_Action__c | Long Text Area | Specific action/payload |
| Status | Status__c | Picklist | Pending Review, Approved, Rejected, Escalated |
| Confidence Score | Confidence_Score__c | Percent | Agent's self-reported confidence |
| Agent Name | Agent_Name__c | Text(80) | Which agent submitted this |
| Supervisor Notes | Supervisor_Notes__c | Long Text Area | Human reviewer's comments |
| Reviewed By | Reviewed_By__c | Lookup(User) | Who approved/rejected |
| Reviewed Date | Reviewed_Date__c | DateTime | When decision was made |