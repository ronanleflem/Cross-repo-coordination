# CP-003 - Audit decommission progressif ta4j et calculs Java vers Python

## Initiative
- `INIT-003`

## Objective summary
- Produire une cartographie complete "Java legacy ta4j -> Python engine", identifier les ecarts et dependances, puis preparer un plan de decommission pas a pas sans rupture de contrat Angular/Spring/Python.

## Source references (pin revisions)
### Angular
- Repo/path: C:\Users\ronan\Desktop\Angular-Front-Financial\Angular-Financial-Project
- Branch/commit: a figer en phase Architect
- Key docs/files:
- `docs/GENERATE_TICKET_FROM_JIRA.md`
- `tickets/_templates/TICKET_TEMPLATE.md`
- `tickets/_templates/AUDIT_PROMPT.md`
- composants strategy launcher et mapping erreurs/capabilities

### Spring
- Repo/path: C:\Users\ronan\Desktop\Projet Finance\spring\Financial-Project
- Branch/commit: a figer en phase Architect
- Key docs/files:
- `docs/GENERATE_TICKET_FROM_JIRA.md`
- `tickets/_templates/TICKET_TEMPLATE.md`
- `tickets/_templates/AUDIT_PROMPT.md`
- services/controllers qui orchestrent aujourd'hui les calculs ou delegations

### Python
- Repo/path: C:\Users\ronan\Desktop\Quant-Engine-Python\Quant-Python-Engine
- Branch/commit: a figer en phase Architect
- Key docs/files:
- `docs/GENERATE_TICKET_FROM_JIRA.md`
- `tickets/_templates/TICKET_TEMPLATE.md`
- `tickets/_templates/AUDIT_PROMPT.md`
- modules execution/signals/filters/strategies deja en production

## Shared contracts
- Endpoints:
- Flux de lancement/suivi de runs entre Angular -> Spring -> Python.
- Publication explicite des capabilities supportees vs non supportees.
- DTO schema:
- Payload strategy launcher couvrant filtres, strategies, parametres et metadonnees d'execution.
- Contrat d'erreurs pour capacite non supportee (structure + semantics) afin d'unifier le message Angular.
- Version/tag/commit:
- `STRAT-CALC-DECOMMISSION-V1-2026-03-05`

## Context7 decision matrix
- Angular: Required `No`, Reason: audit base sur code local + contrats internes.
- Spring: Required `No`, Reason: audit architecture interne Java/Spring sans API externe incertaine.
- Python: Required `No`, Reason: audit modules internes existants, pas de comportement externe version-sensitive identifie.

## Constraints
- Technical constraints:
- Ne pas casser les contrats payload/reponse existants pendant la phase audit.
- Pas de suppression immediate ta4j sans inventaire et plan rollback.
- Chaque ecart doit etre trace en item actionnable (owner, priorite, impact).
- Product constraints:
- Les utilisateurs ne doivent pas perdre de fonctionnalite "supportee" pendant la transition.
- Le message "not implemented" doit refleter la realite Python, pas une heuristique UI.
- Deployment constraints:
- Sequencer l'implementation future: Spring guardrails -> Python parity -> Angular cleanup.
- Autoriser un mode transitoire (shadow/feature flags) si necessaire.

## Risks
- Inventaire incomplet des dependances ta4j cachees -> scan code + revue architect + checklist par couche.
- Contrat ambigu sur "supporte/non supporte" -> formaliser schema d'erreur + capabilities versionnees.
- Divergence Angular vs backend sur options exposees -> source de verite backend + tests contractuels.
- Decommission trop rapide -> plan par lots avec rollback et telemetry.

## Proposed split (local tickets)
- Angular ticket scope:
- Auditer ecrans/forms/services qui exposent filtres/strategies herites de la logique Java.
- Dresser la matrice "option UI -> capacite Python reelle".
- Proposer plan de nettoyage progressif UI apres stabilisation contrat backend.
- Spring ticket scope:
- Auditer tous les points d'entree et couches qui executent encore ta4j/logique calculatoire Java.
- Isoler ce qui doit devenir pass-through vers Python vs ce qui reste orchestration technique.
- Definir checkpoints de decommission avec compatibilite backward.
- Python ticket scope:
- Auditer la couverture calculatoire effective (filtres/strategies/indicateurs) et les ecarts avec legacy Java.
- Produire mapping "legacy Java capability -> Python equivalent / gap / N/A".
- Definir prerequis techniques pour absorber completement la responsabilite calculatoire.

## Architect decisions consolidation
1. Ownership des responsabilites
   - Spring: owner contrat transport/API.
   - Python: owner verite calculatoire et classification de parite legacy.
   - Angular: owner rendu UX base sur signaux backend uniquement.
2. Contrat/version canonique
   - Contract Version unique: `STRAT-CALC-DECOMMISSION-V1-2026-03-05`.
   - Taxonomie de migration: `SUPPORTED`, `GAP`, `DEPRECATED`, `OBSOLETE`.
3. Regles de transition
   - Pas de suppression ta4j avant preuve de parite Python sur lot concerne.
   - Chaque lot doit inclure rollback explicite et criteres de verification.
4. Context7
   - Non requis a ce stade sur les 3 repos.

## Dependencies (finales)
- Spring
  - Upstream: None
  - Downstream: Python, Angular
- Python
  - Upstream: Spring (contrat transport, validation payload)
  - Downstream: Angular (capacities/errors coherentes)
- Angular
  - Upstream: Spring + Python
  - Downstream: None
- Blockers transverses
  - Matrice canonique legacy->python non finalisee.
  - Validation finale du schema d'erreur/capabilities a figer en Architect.

## Suggested execution order (final)
1. Spring Architect/Dev: guardrails contrat + inventaire decommission ta4j.
2. Python Architect/Dev: matrice de parite + fermeture des gaps prioritaires.
3. Angular Architect/Dev: alignement UI et suppression progressive des options non supportees.
4. Reviewer gates: Spring/Python, puis Angular, puis consolidation finale INIT.
