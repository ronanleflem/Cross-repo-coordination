param(
  [Parameter(Mandatory=$true)][string]$InitId,
  [Parameter(Mandatory=$true)][string]$Slug,
  [Parameter(Mandatory=$true)][string]$Title,
  [switch]$CreateLocalTicketStubs
)

$ErrorActionPreference = 'Stop'

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$root = Split-Path -Parent $scriptDir
$repos = Get-Content "$root\config\repos.json" -Raw | ConvertFrom-Json

$initFile = "$root\initiatives\$InitId-$Slug.md"
$cpFile = "$root\context-packs\CP-$($InitId.Replace('INIT-',''))-$Slug.md"

if (Test-Path $initFile) { throw "Initiative already exists: $initFile" }
if (Test-Path $cpFile) { throw "Context pack already exists: $cpFile" }

$initContent = @"
# $InitId - $Title

## Status
- [x] Active
- [ ] Blocked
- [ ] Done

## Goal
- [$Title]

## Scope
- In scope:
- Out of scope:

## Linked context pack
- `context-packs/$(Split-Path -Leaf $cpFile)`

## Repos impacted
1. Angular Frontend: $($repos.angular)
2. Spring Backend: $($repos.spring)
3. Python Engine: $($repos.python)

## Local tickets
- Angular: <set ticket path>
- Spring: <set ticket path>
- Python: <set ticket path>

## Dependency graph
- blocked_by:
- unblocks:

## Contract/version references
- API/DTO contract:
- Version/tag/commit:

## Stage tracking (BMAD)
- PM: [ ]
- Architect: [ ]
- Dev: [ ]
- Reviewer: [ ]

## Acceptance criteria
- [ ] All local tickets are Done
- [ ] Required PRs merged
- [ ] Contract/version references aligned
- [ ] Cross-repo review complete
"@

$cpContent = @"
# CP-$($InitId.Replace('INIT-','')) - $Title

## Initiative
- `$InitId`

## Objective summary
- [$Title]

## Source references (pin revisions)
### Angular
- Repo/path: $($repos.angular)
- Branch/commit:
- Key docs/files:

### Spring
- Repo/path: $($repos.spring)
- Branch/commit:
- Key docs/files:

### Python
- Repo/path: $($repos.python)
- Branch/commit:
- Key docs/files:

## Shared contracts
- Endpoints:
- DTO schema:
- Version/tag/commit:

## Context7 decision matrix
- Angular: Required [Yes/No], Reason
- Spring: Required [Yes/No], Reason
- Python: Required [Yes/No], Reason

## Constraints
- Technical constraints:
- Product constraints:
- Deployment constraints:

## Risks
- [risk] -> mitigation

## Proposed split (local tickets)
- Angular ticket scope:
- Spring ticket scope:
- Python ticket scope:

## Suggested execution order
1. [step]
2. [step]
3. [step]
"@

$initContent | Set-Content $initFile
$cpContent | Set-Content $cpFile

$index = "$root\initiatives\index.md"
if (Test-Path $index) {
  $current = Get-Content $index -Raw
  $line = "- [ ] [$InitId - $Title](./$(Split-Path -Leaf $initFile))"
  if ($current -notmatch [regex]::Escape($line)) {
    $current = $current -replace "## Active\r?\n", "## Active`r`n$line`r`n"
    $current | Set-Content $index
  }
}

if ($CreateLocalTicketStubs) {
  $targets = @(
    @{ name='angular'; path=$repos.angular },
    @{ name='spring'; path=$repos.spring },
    @{ name='python'; path=$repos.python }
  )

  foreach ($t in $targets) {
    $ticketDir = Join-Path $t.path 'tickets\active'
    if (-not (Test-Path $ticketDir)) { New-Item -ItemType Directory -Path $ticketDir -Force | Out-Null }

    $ticketFile = Join-Path $ticketDir ("$InitId-$($t.name)-$Slug.md")
    if (-not (Test-Path $ticketFile)) {
      @"
# $InitId - $Title ($($t.name))

## BMAD Stage
- PM

## Cross-Repo Coordination
- Cross-Repo Initiative: $InitId
- Repo Owner: $($t.name)
- Upstream Dependencies:
- Contract Version:

## Goal
- [local goal for $($t.name)]

## Notes
- Generated from coordination bootstrap script.
"@ | Set-Content $ticketFile
    }
  }
}

Write-Output "Created: $initFile"
Write-Output "Created: $cpFile"
if ($CreateLocalTicketStubs) { Write-Output "Created local ticket stubs in Angular/Spring/Python repos" }
