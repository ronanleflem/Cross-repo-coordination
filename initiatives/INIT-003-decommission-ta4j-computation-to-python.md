# INIT-003 - Audit decommission progressif ta4j et calculs Java vers Python

## Status
- [x] Active
- [ ] Blocked
- [ ] Done

## Goal
- Auditer l'ensemble des usages ta4j/couches calculatoires historiques cote Java et definir un plan de decommission progressif, en transferant explicitement la responsabilite calculatoire vers Python sans rupture de contrat inter-repos.

## Scope
- In scope:
- Identifier les classes, endpoints, DTO et jobs Spring encore relies a ta4j ou a des calculs techniques Java.
- Identifier les points Python deja equivalentes, partielles, ou absentes pour chaque capacite (filtres, strategies, indicateurs, execution).
- Identifier les impacts Angular (payloads, options UI, messages, validations) lies a la decommission.
- Proposer un plan par etapes (deprecate -> shadow -> cutover -> remove) avec rollback.
- Out of scope:
- Implementer la decommission dans cette initiative PM.
- Ajouter de nouvelles strategies/filtres non demandes.
- Refonte UX complete du strategy launcher.

## Linked context pack
- `context-packs/CP-003-decommission-ta4j-computation-to-python.md`

## Repos impacted
1. Angular Frontend: C:\Users\ronan\Desktop\Angular-Front-Financial\Angular-Financial-Project
2. Spring Backend: C:\Users\ronan\Desktop\Projet Finance\spring\Financial-Project
3. Python Engine: C:\Users\ronan\Desktop\Quant-Engine-Python\Quant-Python-Engine

## Local tickets
- Angular: `C:\Users\ronan\Desktop\Angular-Front-Financial\Angular-Financial-Project\tickets\active\INIT-003-angular-decommission-ta4j-computation-to-python.md`
- Spring: `C:\Users\ronan\Desktop\Projet Finance\spring\Financial-Project\tickets\active\INIT-003-spring-decommission-ta4j-computation-to-python.md`
- Python: `C:\Users\ronan\Desktop\Quant-Engine-Python\Quant-Python-Engine\tickets\active\INIT-003-python-decommission-ta4j-computation-to-python.md`

## Dependency graph
- blocked_by:
- Finalisation de la matrice canonique `legacy_java_capability -> python_capability` (owner: Python).
- Validation Architect du contrat transport Spring (owner: Spring).
- unblocks:
- INIT futur de migration implementable (Architect/Dev) pour suppression progressive ta4j cote Java.
- Alignement durable du contrat Spring <-> Python pour strategies/filtres.
- Rationalisation des options Angular afin de n'exposer que les capacites reelles.

## Contract/version references
- API/DTO contract:
- Contrat fonctionnel de reference: `STRAT-CALC-DECOMMISSION-V1-2026-03-05`.
- Surface concernee: payload strategy launcher (filtres/strategies), APIs Spring de lancement/suivi runs, et contrats d'erreurs/capabilities vers Angular.
- Le principe "Python source of truth for computation" devient la regle cible.
- Version/tag/commit:
  - Contract Version: `STRAT-CALC-DECOMMISSION-V1-2026-03-05`.

## Stage tracking (BMAD)
- PM: [x]
- Architect: [x]
- Dev: [ ]
- Reviewer: [ ]

## BMAD sequence per repo ticket
1. PM: ticket de cadrage/audit genere (fait).
2. Architect: figer l'architecture de decommission et les contrats cibles (fait, consolide ci-dessous).
3. Dev: executer les etapes de migration/decommission validees.
4. Reviewer: gate final par repo + consolidation cross-repo.

## Architect decisions (consolidees)
1. Responsabilites cross-repo
   - Spring est owner du contrat transport/API (validation schema, propagation status/body, compat backward).
   - Python est owner de la verite calculatoire (supporte/non supporte, equivalence legacy ta4j).
   - Angular consomme uniquement les signaux backend (capabilities + erreurs), sans heuristique locale de support.
2. Contrat de transition
   - Version canonique unique: `STRAT-CALC-DECOMMISSION-V1-2026-03-05`.
   - Toute capacite legacy ta4j doit etre classee: `SUPPORTED`, `GAP`, `DEPRECATED`, `OBSOLETE`.
   - Les erreurs de non-support doivent rester stables et exploitables pour le mapping UI.
3. Strategie de decommission
   - Etape 1: inventaire et guardrails (pas de suppression physique ta4j).
   - Etape 2: cutover progressif vers Python sur lots priorises.
   - Etape 3: suppression ta4j apres preuve de parite et rollback planifie.
4. Context7
   - Decision confirmee: `No` pour Angular/Spring/Python a ce stade.

## Upstream/Downstream dependencies (finales)
- Spring
  - Upstream: None
  - Downstream: Python (parite calcul), Angular (consommation contrat)
- Python
  - Upstream: Spring (contrat transport et payload valide)
  - Downstream: Angular (capacities/errors coherentes)
- Angular
  - Upstream: Spring + Python
  - Downstream: None

## Final execution order
1. Spring Architect/Dev: verrouiller contrat transport et inventaire points ta4j.
2. Python Architect/Dev: produire parite capability et combler gaps prioritaires.
3. Angular Architect/Dev: nettoyer options UI et mapping erreurs/capabilities.
4. Reviewer gates: Spring + Python, puis Angular, puis consolidation cross-repo.

## Acceptance criteria
- [x] 1 ticket local PM genere pour Angular, Spring, Python.
- [x] Chaque ticket contient `Cross-Repo Initiative`, `Upstream Dependencies`, `Contract Version`, `Context7 Decision`.
- [x] `INIT-003` et `CP-003` sont crees et relies.
- [x] Le sequencing initial cross-repo est defini.
- [ ] Les 3 tickets locaux sont en Done apres phases Architect/Dev/Reviewer.
- [ ] Les PR de migration/decommission sont merges.
- [ ] Les contrats sont alignes apres execution.

## Open risks and blockers
- Risque de couverture incomplete ta4j: usage indirect via wrappers/utilitaires potentiellement non references.
- Risque de derive contractuelle: Spring peut encore transformer des champs calculatoires au lieu de passer-through Python.
- Risque produit: Angular peut afficher des options plus larges que les capacites Python reelles.
- Blocage potentiel: absence de matrice unique "feature Java legacy -> equivalent Python".
