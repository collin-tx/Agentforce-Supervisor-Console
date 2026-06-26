# Agent Supervisor Console

A human-in-the-loop Lightning Web Component (LWC) UI for reviewing and approving AI agent tasks, built on the Salesforce platform.

## Overview

This application provides a supervisory interface where human operators can review, approve, or reject tasks proposed by AI agents, maintaining oversight and control over automated processes.

## Features

- 🤖 **Agent Task Management** - Track and review AI agent proposals
- ✅ **Approval Workflow** - Human-in-the-loop decision making
- 📊 **Confidence Scoring** - Agent self-reported confidence levels
- 📝 **Audit Trail** - Complete history of all decisions
- 🔒 **Security First** - Field-level security and proper sharing rules

## Technology Stack

- **Frontend**: Lightning Web Components (LWC)
- **Backend**: Apex (Salesforce)
- **Platform**: Salesforce
- **Data Model**: Custom Objects

## AppExchange Ready

This project follows Salesforce AppExchange best practices:

- ✅ No hardcoded IDs
- ✅ Named Credentials for external calls
- ✅ 75%+ test coverage from day one
- ✅ Namespace ready
- ✅ Comprehensive documentation

## Data Model

### Agent_Task__c

| Field | Type | Description |
|-------|------|-------------|
| Name | Auto Number | Task identifier (AT-{0000}) |
| Description__c | Long Text Area | What the agent wants to do |
| Proposed_Action__c | Long Text Area | Specific action/payload |
| Status__c | Picklist | Pending Review, Approved, Rejected, Escalated |
| Confidence_Score__c | Percent | Agent's self-reported confidence |
| Agent_Name__c | Text(80) | Which agent submitted this |
| Supervisor_Notes__c | Long Text Area | Human reviewer's comments |
| Reviewed_By__c | Lookup(User) | Who approved/rejected |
| Reviewed_Date__c | DateTime | When decision was made |

## Setup

### Prerequisites

- Salesforce CLI installed
- Dev Hub enabled in your Salesforce org
- Git installed

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd supervisor-console
```

2. Authenticate with your Dev Hub:
```bash
sf org login web --set-default-dev-hub
```

3. Create a scratch org:
```bash
sf org create scratch --definition-file config/project-scratch-def.json --alias supervisor-dev --set-default
```

4. Deploy the metadata:
```bash
sf project deploy start
```

5. Open the scratch org:
```bash
sf org open
```

## Development

### Running Tests

Run all tests:
```bash
sf apex run test --result-format human --code-coverage
```

Run specific test class:
```bash
sf apex run test --class-names AgentTaskTestDataFactoryTest --result-format human --code-coverage
```

### Project Structure

```
force-app/main/default/
├── classes/                    # Apex classes
│   ├── AgentTaskTestDataFactory.cls
│   └── AgentTaskTestDataFactoryTest.cls
├── lwc/                        # Lightning Web Components
│   └── agentSupervisorConsole/
└── objects/                    # Custom objects
    └── Agent_Task__c/
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Ensure tests pass and coverage is maintained
5. Submit a pull request

## License

[Add your license here]

## Contact

[Add contact information]

## Roadmap

- [ ] Enhanced LWC UI for task management
- [ ] Apex controller for data access
- [ ] Approval automation
- [ ] Permission sets
- [ ] Integration with external AI services
- [ ] Analytics and reporting

## Acknowledgments

Built with ❤️ for the Salesforce community
