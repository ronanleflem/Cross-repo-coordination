# CP-002 - Align strategy-launcher backtest payload with Python support

## Initiative
- `INIT-002`

## Objective summary
- Harmoniser la partie Backtest de `strategy-launcher` entre Angular, Spring et Python: conserver les champs deja emis par Angular, mais marquer explicitement en `Not implemented yet` ceux qui ne sont pas implementes cote Python afin d'eviter la confusion produit et les ambiguities de contrat.

## Source references (pin revisions)
### Angular
- Repo/path: C:\Users\ronan\Desktop\Angular-Front-Financial\Angular-Financial-Project
- Branch/commit: a renseigner en phase Architect
- Key docs/files:
  - docs/GENERATE_TICKET_FROM_JIRA.md
  - tickets/_templates/TICKET_TEMPLATE.md
  - tickets/_templates/AUDIT_PROMPT.md
  - strategy-launcher page/components (a confirmer)

### Spring
- Repo/path: C:\Users\ronan\Desktop\Projet Finance\spring\Financial-Project
- Branch/commit: a renseigner en phase Architect
- Key docs/files:
  - docs/GENERATE_TICKET_FROM_JIRA.md
  - docs/CROSS_REPO_COORDINATION.md
  - tickets/_templates/TICKET_TEMPLATE.md
  - tickets/_templates/AUDIT_PROMPT.md

### Python
- Repo/path: C:\Users\ronan\Desktop\Quant-Engine-Python\Quant-Python-Engine
- Branch/commit: a renseigner en phase Architect
- Key docs/files:
  - docs/GENERATE_TICKET_FROM_JIRA.md
  - tickets/_templates/TICKET_TEMPLATE.md
  - tickets/_templates/AUDIT_PROMPT.md
  - modules backtest parser/execution (a confirmer)

## Shared contracts
- Endpoints:
  - `POST /api/runs` (Spring) -> `/runs` (Python) comme chemin canonical de lancement.
  - `GET /api/runs/{requestId}` et `GET /api/runs/{requestId}/result` pour suivi/lecture.
- DTO schema:
  - Payload de contrainte fourni:
    - `spec_type: backtest`
    - `catalog_version: 2026-02-02`
    - `data`, `strategy.params.tp_sl`, `strategy.params.screening`, `signal`, `filters`
  - Decision Architect:
    - `NON_SUPPORTE_CONTRAT` -> HTTP `422` avec `errors[].field`, `errors[].code`, `errors[].message`
    - `NON_SUPPORTE_RUNTIME` -> run `FAILED` avec `error.code=not_implemented_feature` et details champ
- Version/tag/commit:
  - `catalog_version=2026-02-02`

## Context7 decision matrix
- Angular: Required `No` - besoin couvert par code/docs locaux et contrat fourni.
- Spring: Required `No` - pas d'API externe nouvelle identifiee.
- Python: Required `No` - analyse centree sur implementation interne existante.

## Constraints
- Technical constraints:
  - Ne pas inventer de nouveau contrat API hors payload fourni.
  - Eviter les breaking changes sur champs deja supportes.
  - Les champs non supportes doivent etre explicitement traces.
- Product constraints:
  - Afficher clairement `Not implemented yet` pour les options backtest non disponibles cote Python.
  - Preserver l'experience actuelle pour les cas deja fonctionnels.
- Deployment constraints:
  - Execution en sequence cross-repo pour limiter les regressions de contrat.

## Risks
- Derive de schema entre Angular et Python -> figer la reference `catalog_version=2026-02-02` dans chaque ticket.
- Mauvaise interpretation produit de "non supporte" -> standardiser le libelle `Not implemented yet`.
- Regressions silencieuses sur payload existant -> imposer validation contractuelle au reviewer gate.
- Divergence field paths TP/SL (`strategy.tp_sl.*` vs `strategy.params.tp_sl.*`) -> harmoniser mapping canonical avant Dev Angular.

## Proposed split (local tickets)
- Angular ticket scope:
  - Mapper les erreurs backend (`field/code/message`) vers les controles de `strategy-launcher`.
  - Afficher `Not implemented yet` pour champs non supportes (contrat/runtime) sans regression sur flux supporte.
  - Ne pas classifier localement le support; utiliser la reponse backend comme autorite.
- Spring ticket scope:
  - Figer `POST /api/runs` comme source de verite transport canonical.
  - Proteger la propagation transparente des statuts/body Python (notamment 422 structure).
  - Conserver mode `LEGACY` hors scope metier de ce ticket.
- Python ticket scope:
  - Figer la matrice supporte vs non supporte (contrat/runtime) pour `catalog_version=2026-02-02`.
  - Standardiser `error.code=not_implemented_feature` sur non support runtime.
  - Garder `422` pour non support contrat (schema/champs invalides).

## Architect decisions consolidation
1. Source de verite contrat
   - Spring est source de verite de transport canonical; Python est source de verite metier de support fonctionnel.
2. Taxonomie non supporte
   - `NON_SUPPORTE_CONTRAT`: rejete en 422 structure.
   - `NON_SUPPORTE_RUNTIME`: accepte au submit mais echoue en run `FAILED` avec code explicite.
3. UX front
   - Angular affiche `Not implemented yet` en se basant sur la signalisation backend, pas sur heuristique locale.
4. Context7
   - Non requis dans les trois repos pour cette phase.

## Dependencies (finales)
- Spring
  - Upstream: None
  - Downstream: Python, Angular
- Python
  - Upstream: Spring
  - Downstream: Angular
- Angular
  - Upstream: Spring + Python
  - Downstream: None

## Suggested execution order (final)
1. Spring Dev: verrouiller contrat de transport et propagation status/body.
2. Python Dev: implementer signalisation runtime standardisee.
3. Angular Dev: brancher affichage `Not implemented yet` + mapping erreurs.
4. Reviewer gates: Python/Spring puis Angular, puis validation cross-repo.

## Open questions
- Endpoint source de verite confirme: `POST /api/runs`.
- Signalisation `Not implemented yet` confirmee: backend (`422` structure ou `error.code=not_implemented_feature`).
- Point restant a trancher avant Dev Angular:
  - forme canonical unique du chemin TP/SL (`strategy.tp_sl.*` vs `strategy.params.tp_sl.*`) pour mapping champ->controle stable.
