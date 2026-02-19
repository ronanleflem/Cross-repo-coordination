# Exemple De Processus De Bout En Bout (Cross-Repo)

Cet exemple montre exactement quoi faire et ce qui est genere automatiquement.

## Exemple de feature
- Demande: "Ajouter un score de risque global visible dans Angular, calcule dans Python, expose par Spring."

## Deux points d'entree valides

### Option A - Script d'abord (recommande)
1. Executer:
```powershell
./scripts/bootstrap-initiative.ps1 -InitId "INIT-002" -Slug "global-risk-score" -Title "Add global risk score" -CreateLocalTicketStubs
```

2. Sorties automatiques:
- `initiatives/INIT-002-global-risk-score.md`
- `context-packs/CP-002-global-risk-score.md`
- `initiatives/index.md` mis a jour
- stubs de tickets locaux:
  - Angular: `C:\Users\ronan\Desktop\Angular-Front-Financial\Angular-Financial-Project\tickets\active\INIT-002-angular-global-risk-score.md`
  - Spring: `C:\Users\ronan\Desktop\Projet Finance\spring\Financial-Project\tickets\active\INIT-002-spring-global-risk-score.md`
  - Python: `C:\Users\ronan\Desktop\Quant-Engine-Python\Quant-Python-Engine\tickets\active\INIT-002-python-global-risk-score.md`

3. Ensuite demander a l'orchestrateur de continuer avec:
- `docs/PROMPT_ORCHESTRATE_FEATURE.md`

### Option B - Prompt d'abord
1. Demander:
- "Utilise `docs/PROMPT_ORCHESTRATE_FEATURE.md` pour la feature: Add global risk score"

2. Actions attendues de l'orchestrateur:
- creer/mettre a jour `INIT-002` et `CP-002`
- creer ou affiner les tickets locaux dans chaque repo impacte
- renseigner les dependances et la version du contrat

## Sequence BMAD par ticket local
Pour chaque ticket local au repo:
1. Stage PM (workflow `tech-spec` ou `prd` selon la taille)
2. Stage Architect (workflow `architecture`)
3. Stage Dev (workflow `dev-story`)
4. Stage Reviewer (workflow `code-review`)

## Utilisation de Context7
Utiliser uniquement si necessaire:
- comportement d'une API/lib externe inconnu
- detail d'implementation sensible a la version
- documentation manquante ou contradictoire

Sinon definir:
- `Context7 Decision: Required = No`

## Ce que tu declenches manuellement vs automatiquement

Manuel:
1. Lancer le script bootstrap OU appeler le prompt d'orchestration.
2. Confirmer les choix produit et les priorites.
3. Demander l'implementation/la review quand c'est pret.

Automatique (par script/orchestrateur):
1. Creation des fichiers initiative/context pack.
2. Generation ou mise a jour des tickets locaux.
3. Remplissage et maintien des liens/dependances cross-repo.
4. Suivi de la progression BMAD dans les artefacts.

## Commandes minimales operateur
```powershell
# 1) Bootstrap
./scripts/bootstrap-initiative.ps1 -InitId "INIT-002" -Slug "global-risk-score" -Title "Add global risk score" -CreateLocalTicketStubs

# 2) Demander a l'orchestrateur
# "Applique docs/PROMPT_ORCHESTRATE_FEATURE.md pour INIT-002"

# 3) Suivre l'avancement
Get-Content initiatives/INIT-002-global-risk-score.md
Get-Content context-packs/CP-002-global-risk-score.md
```
