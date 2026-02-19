# Exemple De Processus De Bout En Bout (Cross-Repo)

Ce document decrit le flux complet, avec:
- quoi lancer
- ou lancer (cross-repo ou repo de travail)
- ce qui est genere automatiquement
- quand valider manuellement

## Pre-requis
- Repo cross-repo: `C:\Users\ronan\Desktop\Cross-repo-coordination\Cross-repo-coordination`
- Repo Angular: `C:\Users\ronan\Desktop\Angular-Front-Financial\Angular-Financial-Project`
- Repo Spring: `C:\Users\ronan\Desktop\Projet Finance\spring\Financial-Project`
- Repo Python: `C:\Users\ronan\Desktop\Quant-Engine-Python\Quant-Python-Engine`

## Feature fictive
- "Strategy launcher: afficher Not implemented yet pour options non supportees"

## Step 0 (optionnel) - Bootstrap automatique
Where to run: CROSS-REPO

```powershell
./scripts/bootstrap-initiative.ps1 -InitId "INIT-002" -Slug "strategy-launcher-backtest-not-implemented" -Title "Strategy launcher backtest not implemented" -CreateLocalTicketStubs
```

Ce que ca genere automatiquement:
- `initiatives/INIT-002-strategy-launcher-backtest-not-implemented.md`
- `context-packs/CP-002-strategy-launcher-backtest-not-implemented.md`
- mise a jour `initiatives/index.md`
- stubs tickets locaux (Angular/Spring/Python)

Note:
- Cette etape est optionnelle.
- Si tu ne la fais pas, Step 1 peut creer/mettre a jour les memes artefacts.

## Step 1 - Generation coordonnee des tickets (PM)
Where to run: CROSS-REPO
Prompt source: `docs/PROMPT_ORCHESTRATE_FEATURE.md`

Exemple de prompt:
```txt
Applique docs/PROMPT_ORCHESTRATE_FEATURE.md.

Input type: JIRA
Feature: "Strategy launcher backtest not implemented"

Actions attendues:
1) Creer/mettre a jour INIT-002 et CP-002
2) Generer les 3 tickets locaux (Angular, Spring, Python)
3) Fixer BMAD Stage = PM dans chaque ticket
4) Renseigner Cross-Repo Initiative, Upstream Dependencies, Contract Version, Context7 Decision
5) Stopper et me demander validation
```

Ce qui est automatique a Step 1:
- generation/maj INIT + CP
- generation/maj tickets locaux
- verification metadata si demandee

Ce que tu dois faire ensuite:
- valider artefacts (INIT, CP, tickets) avant Architect

## Step 2 - Validation manuelle avant Architect
Where to run: CROSS-REPO

Exemple de prompt:
```txt
Pour INIT-002, fais une revue de coherence de INIT + CP + 3 tickets locaux.
Donne les incoherences, dependances manquantes et ordre d execution final.
Ne code rien.
```

Commande utile:
```powershell
./scripts/validate-ticket-metadata.ps1 -InitId "INIT-002"
```

Decision humaine attendue:
- "Valide pour passage en phase Architect"

## Step 3 - Architect (sans code)
Where to run: EACH WORK REPO
Ordre recommande: Spring -> Python -> Angular

### 3A - Spring
Where: SPRING repo
```txt
Sur le ticket local INIT-002-spring-..., execute la phase Architect.
Objectif: figer endpoint/contrat et politique champs non supportes.
Ne code pas.
```

### 3B - Python
Where: PYTHON repo
```txt
Sur le ticket local INIT-002-python-..., execute la phase Architect.
Objectif: matrice supporte/non supporte + signalisation.
Ne code pas.
```

### 3C - Angular
Where: ANGULAR repo
```txt
Sur le ticket local INIT-002-angular-..., execute la phase Architect.
Objectif: alignement UX/message avec contrat backend.
Ne code pas.
```

Ce que tu dois faire ensuite:
- retourner dans le cross-repo pour consolider les decisions Architect

## Step 4 - Consolidation Architect (cross-repo)
Where to run: CROSS-REPO

Exemple de prompt:
```txt
Pour INIT-002, consolide les decisions Architect des 3 repos dans INIT + CP.
Mets a jour dependances, contrat/version et ordre final d execution.
Ne code pas.
```

Decision humaine attendue:
- "Valide pour passage en phase Dev"

## Step 5 - Dev (code)
Where to run: EACH WORK REPO
Ordre recommande: Spring -> Python -> Angular

Exemple de prompt (a adapter au repo):
```txt
Sur le ticket local INIT-002-<repo>-..., execute la phase Dev.
- respecter strictement le scope local
- Context7 seulement si Required=Yes
- produire changements + tests + resume validation
Puis passer le ticket en Review-ready.
```

## Step 6 - Reviewer (gate)
Where to run: EACH WORK REPO

Exemple de prompt:
```txt
Lance le review gate BMAD (code-review) pour le ticket <TICKET-ID>.
Je veux findings critiques/non critiques + decision finale.
```

Si corrections:
- repasser en Dev sur le meme repo
- relancer Reviewer

## Step 7 - Cloture initiative
Where to run: CROSS-REPO

Exemple de prompt:
```txt
Mets a jour INIT-002 avec:
- statuts tickets locaux
- liens PR
- dependances restantes

Si tout est vert (tickets done + PR merge + contrat aligne), passe INIT-002 en Done.
Sinon laisse Active avec blockers explicites.
```

## Resume: qui declenche quoi
- Toi (manuel): lancement step 0/1, validations intermediaires, go/no-go Architect et Dev.
- Orchestrateur (automatique quand demande): creation/maj INIT+CP+tickets et coherence metadata.
- Agents code (manuel par repo): Architect, Dev, Reviewer en local.
