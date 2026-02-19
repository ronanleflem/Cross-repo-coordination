# Prompt Examples Workflow

Use this file as copy/paste templates.
All prompts are in French, ASCII-only.

## Step 0 - Bootstrap initiative (command)
Where to run: CROSS-REPO
Path: C:\Users\ronan\Desktop\Cross-repo-coordination\Cross-repo-coordination

```powershell
./scripts/bootstrap-initiative.ps1 -InitId "INIT-003" -Slug "global-risk-score" -Title "Add global risk score" -CreateLocalTicketStubs
```

---

## Step 1 - Orchestrate full ticket generation
Where to run: CROSS-REPO
File used: docs/PROMPT_ORCHESTRATE_FEATURE.md

Prompt template:
```txt
Applique docs/PROMPT_ORCHESTRATE_FEATURE.md.

Input type: JIRA
Feature: "<idee vague ici>"

Contraintes:
- <contrainte 1>
- <contrainte 2>

Repos potentiellement impactes:
- Angular
- Spring
- Python

Actions attendues:
1) Creer ou mettre a jour INIT-<XXX> et CP-<XXX>
2) Generer les tickets locaux dans les repos impactes
3) Fixer BMAD Stage = PM dans chaque ticket genere
4) Renseigner Cross-Repo Initiative, Upstream Dependencies, Contract Version, Context7 Decision
5) Proposer l'ordre d'execution
6) Stopper apres generation des tickets et me demander validation
```

---

## Step 2 - Validate artifacts before coding
Where to run: CROSS-REPO

Prompt template:
```txt
Pour INIT-<XXX>, fais une revue de coherence:
- INIT
- CP
- tickets locaux Angular/Spring/Python

Donne-moi:
1) incoherences
2) dependances manquantes
3) risques contrats/version
4) proposition finale de sequencing
5) BMAD Stage cible pour la suite (Architect)

Ne code rien a ce stade.
```

Optional command:
```powershell
./scripts/validate-ticket-metadata.ps1 -InitId "INIT-003"
```

---

## Step 3 - Start implementation in one repo
Where to run: REPO DE TRAVAIL (Angular OR Spring OR Python)

### 3.0 - Architect validation before coding (required)
Where: EACH WORK REPO

Prompt template:
```txt
Sur le ticket local <TICKET-ID> lie a INIT-<XXX>, execute la phase Architect.

Regles:
- stage BMAD: Architect
- valider approche technique, risques, rollback
- confirmer ou ajuster dependances/contrat
- ne pas coder a ce stade

Puis bascule le ticket vers Dev-ready.
```

### 3A - Spring first (example)
Where: SPRING repo

Prompt template:
```txt
Execute le ticket local lie a INIT-<XXX> cote Spring.

Regles:
- stage BMAD: Dev
- respecter le ticket scope uniquement
- Context7 seulement si requis dans le ticket
- produire: changements + tests + resume des validations

Puis bascule le ticket en Review-ready.
```

### 3B - Python second (example)
Where: PYTHON repo

Prompt template:
```txt
Execute le ticket local lie a INIT-<XXX> cote Python.

Regles:
- stage BMAD: Dev
- scope local uniquement
- Context7 seulement si requis
- produire: changements + tests + resume des validations

Puis bascule le ticket en Review-ready.
```

### 3C - Angular last (example)
Where: ANGULAR repo

Prompt template:
```txt
Execute le ticket local lie a INIT-<XXX> cote Angular.

Regles:
- stage BMAD: Dev
- scope local uniquement
- Context7 seulement si requis
- produire: changements + tests + resume des validations

Puis bascule le ticket en Review-ready.
```

---

## Step 4 - Review gates per repo
Where to run: EACH WORK REPO

Prompt template:
```txt
Lance le review gate BMAD (code-review) pour le ticket <TICKET-ID>.

Je veux:
0) confirmer stage BMAD: Reviewer
1) findings critiques
2) findings non critiques
3) decision: Approved / Changes required
4) liste exacte des corrections a faire
```

---

## Step 5 - Update coordination and close
Where to run: CROSS-REPO

Prompt template:
```txt
Mets a jour INIT-<XXX> et CP-<XXX> avec:
- statut tickets locaux
- liens PR
- statut dependances
- decisions Context7

Si tout est vert (tickets done + PR merge + contrats alignes), passe INIT-<XXX> a Done.
Sinon laisse en Active avec blockers explicites.
```

---

## Step 6 - EIC-specific generation (when contract already exists)
Where to run: CROSS-REPO first, then each impacted WORK REPO

Cross-repo prompt:
```txt
Input type: EIC
Applique docs/PROMPT_ORCHESTRATE_FEATURE.md pour INIT-<XXX> avec ce contrat:
<EIC ici>

Genere les tickets locaux via GENERATE_TICKET_FROM_EIC.md dans chaque repo impacte.
Fixe BMAD Stage = PM dans les tickets generes.
Stop apres generation pour validation.
```

Work repo prompt (if needed manually):
```txt
Applique docs/GENERATE_TICKET_FROM_EIC.md avec ce contrat:
<EIC ici>

Sortie attendue: 1 ticket local dans tickets/active, conforme template + audit prompt.
```
