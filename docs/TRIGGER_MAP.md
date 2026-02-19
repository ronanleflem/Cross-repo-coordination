# Trigger Map

This file defines which markdown files must be triggered for each input type.

## Entry point (always)
- Trigger: `docs/PROMPT_ORCHESTRATE_FEATURE.md`
- Scope: cross-repo orchestration
- Outputs: `INIT`, `CP`, local tickets list, dependency graph

## Input type mapping

### Case A: vague idea / jira-like sentence
1. Orchestrator creates or updates `INIT` + `CP`.
2. In each impacted repo, trigger local:
   - `docs/GENERATE_TICKET_FROM_JIRA.md`
   - `tickets/_templates/TICKET_TEMPLATE.md`
   - `tickets/_templates/AUDIT_PROMPT.md`

### Case B: external contract available (EIC)
1. Orchestrator creates or updates `INIT` + `CP`.
2. In each impacted repo, trigger local:
   - `docs/GENERATE_TICKET_FROM_EIC.md`
   - `tickets/_templates/TICKET_TEMPLATE.md`
   - `tickets/_templates/AUDIT_PROMPT.md`

## BMAD stage triggering
For each local ticket:
1. PM stage
2. Architect stage
3. Dev stage
4. Reviewer stage

## Context7 triggering
Context7 can be used only when at least one is true:
- New/uncertain external API or library
- Version-sensitive behavior
- Missing/conflicting docs
Otherwise set `Context7 Decision` to `No`.
