# CP-001 - Bootstrap Coordination Context

## Initiative
- `INIT-001`

## Objective summary
- Align ticket generation and dependency tracking across Angular, Spring, and Python repos.

## Source references (pin revisions)
### Angular
- Repo/path: C:\Users\ronan\Desktop\Angular-Front-Financial\Angular-Financial-Project
- Branch/commit:
- Key docs/files:
  - docs/AI_WORKFLOW.md
  - docs/CROSS_REPO_COORDINATION.md
  - tickets/_templates/TICKET_TEMPLATE.md

### Spring
- Repo/path: C:\Users\ronan\Desktop\Projet Finance\spring\Financial-Project
- Branch/commit:
- Key docs/files:
  - docs/AI_WORKFLOW.md
  - docs/CROSS_REPO_COORDINATION.md
  - tickets/_templates/TICKET_TEMPLATE.md

### Python
- Repo/path: C:\Users\ronan\Desktop\Quant-Engine-Python\Quant-Python-Engine
- Branch/commit:
- Key docs/files:
  - docs/AI_WORKFLOW.md
  - docs/CROSS_REPO_COORDINATION.md
  - tickets/_templates/TICKET_TEMPLATE.md

## Shared contracts
- Endpoints:
- DTO schema:
- Version/tag/commit:

## Constraints
- Technical constraints:
- Product constraints:
- Deployment constraints:

## Risks
- Ticket drift between repos -> enforce INIT links.

## Proposed split (local tickets)
- Angular ticket scope: local UI/consumer responsibilities.
- Spring ticket scope: local API/backend responsibilities.
- Python ticket scope: local compute/engine responsibilities.

## Suggested execution order
1. Confirm source of truth for contracts.
2. Create linked local tickets.
3. Track status in initiative file.

## Open questions
- Which repository owns final contract publication?
