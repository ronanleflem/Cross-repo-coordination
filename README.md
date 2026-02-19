# Cross-Repo Coordination

This repository is the coordination layer for multi-repo initiatives.

It does not replace local repo tickets.
Local execution tickets remain in each project repository.

## Absolute Paths
- Coordination repo: `C:\Users\ronan\Desktop\Cross-repo-coordination\Cross-repo-coordination`
- Angular repo: `C:\Users\ronan\Desktop\Angular-Front-Financial\Angular-Financial-Project`
- Spring repo: `C:\Users\ronan\Desktop\Projet Finance\spring\Financial-Project`
- Python repo: `C:\Users\ronan\Desktop\Quant-Engine-Python\Quant-Python-Engine`

## Source of truth and precedence
1. Cross-repo orchestration is always the entry point.
2. `GENERATE_TICKET_FROM_JIRA.md` is used for local ticket creation from vague idea.
3. `GENERATE_TICKET_FROM_EIC.md` is used for local contract-to-ticket translation only.
4. EIC files do not orchestrate other repositories.

## Structure
- `initiatives/index.md`: global list of initiatives
- `initiatives/INIT-xxx-*.md`: one file per cross-repo initiative
- `context-packs/CP-xxx-*.md`: normalized context for initiative planning
- `initiatives/_templates/INIT_TEMPLATE.md`: initiative template
- `context-packs/_templates/CONTEXT_PACK_TEMPLATE.md`: context pack template

## Workflow
1. Create an initiative (`INIT-xxx`).
2. Create/update a context pack (`CP-xxx`).
3. Create one local ticket per impacted repo.
4. Link tickets/PRs back to the initiative.
5. Close initiative only when all linked tickets are done.

## Quick start (orchestration)
1. Read `docs/ORCHESTRATION_RUNBOOK.md`.
2. Read `docs/TRIGGER_MAP.md`.
3. See concrete example in `docs/EXAMPLE_END_TO_END_PROCESS.md`.
4. Bootstrap initiative + context pack:
`./scripts/bootstrap-initiative.ps1 -InitId "INIT-002" -Slug "feature-short-name" -Title "Feature title" -CreateLocalTicketStubs`
5. Use `docs/PROMPT_ORCHESTRATE_FEATURE.md` as the master orchestration prompt.

## BMAD + Context7 policy
- BMAD sequence is mandatory per local ticket: PM -> Architect -> Dev -> Reviewer.
- Context7 is allowed only when uncertainty criteria are met (new/uncertain external API, version-sensitive behavior, conflicting docs).
