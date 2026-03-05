# Blocking Gates (CP + INIT + Tickets)

This file defines mandatory go/no-go checks for cross-repo execution.

## Gate A - Pre-Architect (mandatory)
You CANNOT start Architect in work repos until all checks pass.

Checks:
1. `INIT-xxx` exists and is `Active`.
2. `CP-xxx` exists and is linked from INIT.
3. 3 local source tickets exist (Angular/Spring/Python).
4. Every source ticket includes:
   - `Cross-Repo Initiative`
   - `Upstream Dependencies`
   - `Contract Version`
   - `Context7 Decision`
5. Contract version is identical in INIT + CP + 3 local tickets.
6. Dependency order is explicit in INIT or CP.

If any check fails:
- Status = `NO-GO`
- Stop and fix artifacts before Architect.

## Gate B - Pre-Dev (mandatory)
You CANNOT start Dev until all checks pass.

Checks:
1. Architect decisions are consolidated in INIT + CP.
2. For audit-heavy initiatives, follow-up sub-tickets are generated and linked.
3. Every implementation ticket/sub-ticket has BMAD Stage `PM` or `Architect-ready`.
4. Upstream dependencies for each implementation ticket are explicit.
5. Final execution order is explicit and dependency-safe.

If any check fails:
- Status = `NO-GO`
- Stop and fix planning artifacts before Dev.

## Gate C - Pre-Close (mandatory)
You CANNOT close initiative until all checks pass.

Checks:
1. All linked implementation tickets are `Done`.
2. Reviewer gates are approved.
3. Contract/version alignment is still valid across repos.
4. Open blockers are empty or explicitly accepted residual risks.

If any check fails:
- Status = `NO-GO`
- Keep INIT `Active`.
