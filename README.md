# Cross-Repo Coordination

This repository is the coordination layer for multi-repo initiatives.

It does not replace local repo tickets.
Local execution tickets remain in each project repository.

## Absolute Paths
- Coordination repo: `C:\Users\ronan\Desktop\Cross-repo-coordination\Cross-repo-coordination`
- Angular repo: `C:\Users\ronan\Desktop\Angular-Front-Financial\Angular-Financial-Project`
- Spring repo: `C:\Users\ronan\Desktop\Projet Finance\spring\Financial-Project`
- Python repo: `C:\Users\ronan\Desktop\Quant-Engine-Python\Quant-Python-Engine`

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
