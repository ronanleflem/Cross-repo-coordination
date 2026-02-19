# INIT-002 - Align strategy-launcher backtest payload with Python support

## Status
- [ ] Active
- [ ] Blocked
- [x] Done

## Goal
- Aligner le payload backtest emis par la page Angular `strategy-launcher` avec les capacites effectivement implementees cote Python, sans regression sur les champs deja supportes.

## Scope
- In scope:
  - Inventorier les champs payload backtest envoyes par Angular.
  - Declarer explicitement les champs non supportes par Python comme `Not implemented yet`.
  - Stabiliser le contrat transite via Spring pour eviter les derives de schema.
- Out of scope:
  - Implementer les fonctionnalites backtest Python manquantes.
  - Ajouter de nouveaux types de signaux/filters non deja presents dans le payload.

## Linked context pack
- `context-packs/CP-002-strategy-launcher-backtest-not-implemented.md`

## Repos impacted
1. Angular Frontend: C:\Users\ronan\Desktop\Angular-Front-Financial\Angular-Financial-Project
2. Spring Backend: C:\Users\ronan\Desktop\Projet Finance\spring\Financial-Project
3. Python Engine: C:\Users\ronan\Desktop\Quant-Engine-Python\Quant-Python-Engine

## Local tickets
- Angular: `C:\Users\ronan\Desktop\Angular-Front-Financial\Angular-Financial-Project\tickets\active\INIT-002-angular-strategy-launcher-backtest-not-implemented.md`
- Spring: `C:\Users\ronan\Desktop\Projet Finance\spring\Financial-Project\tickets\active\INIT-002-spring-strategy-launcher-backtest-not-implemented.md`
- Python: `C:\Users\ronan\Desktop\Quant-Engine-Python\Quant-Python-Engine\tickets\active\INIT-002-python-strategy-launcher-backtest-not-implemented.md`

## Dependency graph
- blocked_by:
  - None
- unblocks:
  - Standardisation du contrat backtest inter-repos pour les prochains tickets feature backtest.
  - Affichage UI fiable `Not implemented yet` base sur signaux backend.

## Contract/version references
- API/DTO contract:
  - Type: `spec_type=backtest`
  - Version: `catalog_version=2026-02-02`
  - Endpoint source de verite: `POST /api/runs` (Spring -> Python `/runs`)
  - Contrat erreur non supporte: `422` avec `errors[].field`, `errors[].code`, `errors[].message`
  - Contrat runtime non implemente: run `FAILED` avec `error.code=not_implemented_feature`
- Version/tag/commit: `catalog_version=2026-02-02`.

## Stage tracking (BMAD)
- PM: [x]
- Architect: [x]
- Dev: [x]
- Reviewer: [x]

## Architect decisions (consolidees)
1. Source de verite cross-repo
   - Spring `POST /api/runs` est l'entree canonical unique pour Strategy Launcher backtest.
   - Spring reste pass-through metier en mode canonical; Python porte la verite "supporte vs non supporte".
2. Classification standard des non-supports
   - `NON_SUPPORTE_CONTRAT`: rejet `422` structure (champ non conforme/extra au contrat).
   - `NON_SUPPORTE_RUNTIME`: champ accepte syntaxiquement mais non cable a l'execution, renvoye en run `FAILED` avec `error.code=not_implemented_feature`.
3. Politique UI
   - Angular affiche `Not implemented yet` base sur les retours backend (codes/messages/champs), pas sur une decision locale arbitraire.
4. Context7
   - Decision finale: `No` pour les 3 repos (pas d'API externe incertaine).

## Upstream/Downstream dependencies
- Spring:
  - Upstream: None (owner du contrat transport canonical)
  - Downstream: Python pour la qualification runtime; Angular pour rendu UX
- Python:
  - Upstream: Spring (contrat endpoint + transport status/body)
  - Downstream: Angular (interpretation UI des erreurs/resultats)
- Angular:
  - Upstream: Spring + Python (field/code/message et semantics `not_implemented_feature`)
  - Downstream: None

## Final execution order
1. Spring Dev
   - Figer/proteger le contrat de transport canonical (`POST /api/runs`, propagation status/body).
2. Python Dev
   - Implementer la qualification runtime et la signalisation standard (`not_implemented_feature`).
3. Angular Dev
   - Mapper les retours backend vers l'UX `Not implemented yet` et verifier non-regression submit.
4. Reviewer gates
   - Reviewer Python/Spring puis Angular, ensuite validation cross-repo finale.

## Final local ticket status
- Angular: Done (`BMAD Stage: Done`)
- Spring: Done (`BMAD Stage: Reviewer (Done)`, `Status: Done`)
- Python: Done (`BMAD Stage: Done`, `Status: Done`)

## PR tracking (merged links)
- Angular PR: Non renseigne dans les artefacts locaux
- Spring PR: Non renseigne dans les artefacts locaux
- Python PR: Non renseigne dans les artefacts locaux

## Dependencies status (final)
- Spring -> Python: Resolved (contrat canonical et propagation status/body valides)
- Python -> Angular: Resolved (`not_implemented_feature` et details exploitables)
- Angular -> Spring/Python: Resolved (mapping UI `Not implemented yet` aligne)

## Contract alignment status (final)
- `spec_type=backtest`: Aligned
- `catalog_version=2026-02-02`: Aligned dans les 3 tickets
- Endpoint source de verite `POST /api/runs`: Aligned
- Taxonomie non support (`422` contrat / `FAILED + not_implemented_feature` runtime): Aligned

## Acceptance criteria
- [x] Les 3 tickets locaux sont crees avec stage BMAD `PM`.
- [x] `Cross-Repo Initiative`, `Upstream Dependencies`, `Contract Version`, `Context7 Decision` sont renseignes dans chaque ticket.
- [x] Le contrat `catalog_version=2026-02-02` est reference de maniere coherente dans INIT/CP/tickets.
- [x] Le sequencing cross-repo est explicite pour passage en phase Architect.
- [x] Les decisions Architect des 3 repos sont consolidees dans INIT/CP.
- [x] Les 3 tickets locaux sont en `Done` avec reviewer gate valide.
- [x] Contrats cross-repo alignes.

## Notes
- Initiative closee: tickets Angular/Spring/Python termines et contrats alignes.
