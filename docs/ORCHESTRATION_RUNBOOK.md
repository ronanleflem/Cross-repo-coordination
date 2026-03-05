# Orchestration Runbook (BMAD + Context7)

## Scope
This runbook is the single operational entry point for any new feature.

## Precedence
1. Cross-repo orchestration first
2. Local JIRA or EIC ticket generation second
3. Audit expansion into sub-tickets third (if audit flow is used)
4. Local implementation last

## Inputs required
- Feature title and objective
- Initial constraints/non-goals
- Candidate impacted repos
- Input type: `JIRA` or `EIC`

## Step 1 - Bootstrap coordination artifacts
Run from coordination repo:

```powershell
./scripts/bootstrap-initiative.ps1 -InitId "INIT-002" -Slug "feature-short-name" -Title "Feature title" -CreateLocalTicketStubs
```

Outputs:
- `initiatives/INIT-002-feature-short-name.md`
- `context-packs/CP-002-feature-short-name.md`
- Optional local ticket stubs in each repo

## Step 2 - Trigger local ticket generation
For each impacted repo:
- If input type is JIRA: use local `docs/GENERATE_TICKET_FROM_JIRA.md`
- If input type is EIC: use local `docs/GENERATE_TICKET_FROM_EIC.md`
- Always enforce local `TICKET_TEMPLATE` + `AUDIT_PROMPT`

## Step 3 - BMAD stages per local ticket
1. PM framing
2. Architect validation
3. Dev execution
4. Reviewer gate

## Step 4 - Context7 decision
Use Context7 only if needed:
- new/uncertain external API
- version-sensitive behavior
- conflicting docs

Record decision in local tickets and context pack.

## Step 5 - Validate metadata consistency
Run:

```powershell
./scripts/validate-ticket-metadata.ps1
```

## Step 6 - Expand audits into sub-tickets (optional but recommended for decommission work)
When local tickets are audit-heavy and validated, run cross-repo prompt:

- `docs/PROMPT_EXPLODE_AUDIT_TO_SUBTICKETS.md`

Expected outputs:
- Multiple concrete sub-tickets in impacted repos (`tickets/active/*.md`)
- Updated `INIT-xxx` and `CP-xxx` with dependency graph and execution order

Rule:
- Do not start Dev on broad audit tickets when follow-up implementation tickets are expected.
- First generate and approve sub-tickets, then run BMAD Architect -> Dev -> Reviewer on those sub-tickets.

## Step 7 - Coordination closure
Update `INIT-xxx`:
- local ticket links
- PR links
- dependency status

Mark initiative `Done` only when all linked tickets are done and contracts are aligned.
