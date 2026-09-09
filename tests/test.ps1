Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Pantheon = Join-Path $Root 'pantheon.ps1'
$PowerShellExe = (Get-Process -Id $PID).Path
$Pass = 0

function Pass([string]$Message) { $script:Pass++; Write-Output "ok $script:Pass - $Message" }
function Fail([string]$Message) { [Console]::Error.WriteLine("not ok - $Message"); exit 1 }
function Assert-True([bool]$Condition, [string]$Message) { if (-not $Condition) { Fail $Message } }
function Assert-File([string]$Path) { Assert-True (Test-Path -LiteralPath $Path -PathType Leaf) "expected file: $Path" }
function Assert-NoPath([string]$Path) { Assert-True (-not (Test-Path -LiteralPath $Path)) "expected missing path: $Path" }
function Assert-Contains([string]$Path, [string]$Text) {
    Assert-File $Path
    Assert-True ([System.IO.File]::ReadAllText($Path).Contains($Text)) "expected '$Text' in $Path"
}
function Assert-NotContains([string]$Path, [string]$Text) {
    if (Test-Path -LiteralPath $Path -PathType Leaf) {
        Assert-True (-not [System.IO.File]::ReadAllText($Path).Contains($Text)) "did not expect '$Text' in $Path"
    }
}
function Assert-EqualFiles([string]$Left, [string]$Right) {
    Assert-File $Left; Assert-File $Right
    Assert-True ((Get-FileHash -LiteralPath $Left -Algorithm SHA256).Hash -ceq (Get-FileHash -LiteralPath $Right -Algorithm SHA256).Hash) "files differ: $Left $Right"
}
function Invoke-Pantheon([string[]]$Arguments) {
    $previousErrorActionPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = & $PowerShellExe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $Pantheon @Arguments 2>&1
        $exitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }
    [PSCustomObject]@{
        ExitCode = $exitCode
        Output = (@($output | ForEach-Object { [string]$_ }) -join [Environment]::NewLine)
    }
}

Assert-File $Pantheon
Assert-File (Join-Path $Root 'install.ps1')
Assert-Contains (Join-Path $Root 'VERSION') '0.7.0'
Assert-Contains $Pantheon '$Version = ''0.7.0'''
$version = Invoke-Pantheon @('version')
Assert-True ($version.ExitCode -eq 0 -and $version.Output.Contains('Codex Pantheon 0.7.0')) 'version command mismatch'
Pass 'PowerShell entrypoints match current release metadata'

$Explorer = Join-Path (Join-Path $Root 'agents') 'luna-explorer.toml'
$Librarian = Join-Path (Join-Path $Root 'agents') 'luna-librarian.toml'
$Fixer = Join-Path (Join-Path $Root 'agents') 'luna-fixer.toml'
foreach ($agent in @($Explorer, $Librarian, $Fixer)) {
    Assert-File $agent
    Assert-Contains $agent 'model = "gpt-5.6-luna"'
    Assert-Contains $agent 'model_reasoning_effort = "high"'
}
Pass 'Windows consumes the shared Luna payload'

$Temp = Join-Path ([System.IO.Path]::GetTempPath()) ('pantheon-windows-' + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $Temp -Force | Out-Null
$Original = @{
    CODEX_HOME = $env:CODEX_HOME
    PANTHEON_SKILLS_HOME = $env:PANTHEON_SKILLS_HOME
    USERPROFILE = $env:USERPROFILE
    PATH = $env:PATH
}

$LegacyAgents = @(
    'pantheon-worker.toml', 'pantheon-explorer.toml', 'pantheon-librarian.toml',
    'pantheon-oracle.toml', 'pantheon-fixer.toml', 'pantheon-designer.toml',
    'pantheon-reviewer.toml', 'pantheon-verifier.toml'
)

try {
    $env:CODEX_HOME = Join-Path $Temp 'codex'
    $env:PANTHEON_SKILLS_HOME = Join-Path $Temp 'skills'
    New-Item -ItemType Directory -Path (Join-Path $env:CODEX_HOME 'agents') -Force | Out-Null
    New-Item -ItemType Directory -Path $env:PANTHEON_SKILLS_HOME -Force | Out-Null

    $AgentsFile = Join-Path $env:CODEX_HOME 'AGENTS.md'
    [System.IO.File]::WriteAllText($AgentsFile, "# User instructions`r`n`r`nKeep this exact user-owned line.`r`n")
    [System.IO.File]::WriteAllText((Join-Path (Join-Path $env:CODEX_HOME 'agents') 'user-custom.toml'), "do-not-touch`r`n")
    $UserSkill = Join-Path $env:PANTHEON_SKILLS_HOME 'user-skill'
    New-Item -ItemType Directory -Path $UserSkill -Force | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $UserSkill 'SKILL.md'), "user skill`r`n")

    foreach ($legacy in $LegacyAgents) {
        [System.IO.File]::WriteAllText((Join-Path (Join-Path $env:CODEX_HOME 'agents') $legacy), "legacy`r`n")
    }
    $LegacyTeam = Join-Path $env:PANTHEON_SKILLS_HOME 'pantheon-team'
    New-Item -ItemType Directory -Path $LegacyTeam -Force | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $LegacyTeam 'SKILL.md'), "legacy team`r`n")

    $FakeBin = Join-Path $Temp 'bin'
    New-Item -ItemType Directory -Path $FakeBin -Force | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $FakeBin 'codex.cmd'), "@echo codex-cli windows-test`r`n")
    $env:PATH = $FakeBin + [System.IO.Path]::PathSeparator + $Original.PATH

    $install = Invoke-Pantheon @('install')
    Assert-True ($install.ExitCode -eq 0) "install failed: $($install.Output)"
    Assert-Contains $AgentsFile 'Keep this exact user-owned line.'
    Assert-Contains (Join-Path $env:CODEX_HOME '.pantheon-version') '0.7.0'
    Assert-File (Join-Path (Join-Path $env:CODEX_HOME 'agents') 'user-custom.toml')
    Assert-File (Join-Path $UserSkill 'SKILL.md')
    Assert-True ((@([System.IO.File]::ReadAllLines($AgentsFile) | Where-Object { $_ -ceq '<!-- PANTHEON:START -->' }).Count) -eq 1) 'expected one start marker'
    Assert-True ((@([System.IO.File]::ReadAllLines($AgentsFile) | Where-Object { $_ -ceq '<!-- PANTHEON:END -->' }).Count) -eq 1) 'expected one end marker'

    foreach ($agent in @('luna-explorer.toml', 'luna-librarian.toml', 'luna-fixer.toml')) {
        Assert-EqualFiles (Join-Path (Join-Path $Root 'agents') $agent) (Join-Path (Join-Path $env:CODEX_HOME 'agents') $agent)
    }
    foreach ($legacy in $LegacyAgents) { Assert-NoPath (Join-Path (Join-Path $env:CODEX_HOME 'agents') $legacy) }
    Assert-NoPath $LegacyTeam
    foreach ($skill in @('pantheon', 'pantheon-daily', 'pantheon-plan', 'pantheon-review')) {
        Assert-EqualFiles (Join-Path (Join-Path (Join-Path $Root 'skills') $skill) 'SKILL.md') (Join-Path (Join-Path $env:PANTHEON_SKILLS_HOME $skill) 'SKILL.md')
    }
    Pass 'install migrates legacy state and preserves user-owned Windows configuration'

    $before = (Get-FileHash -LiteralPath $AgentsFile -Algorithm SHA256).Hash
    $repeat = Invoke-Pantheon @('install')
    Assert-True ($repeat.ExitCode -eq 0) "repeat install failed: $($repeat.Output)"
    Assert-True ($before -ceq (Get-FileHash -LiteralPath $AgentsFile -Algorithm SHA256).Hash) 'install is not idempotent'
    Pass 'install is idempotent'

    $InstalledFixer = Join-Path (Join-Path $env:CODEX_HOME 'agents') 'luna-fixer.toml'
    Add-Content -LiteralPath $InstalledFixer -Value 'drift'
    Assert-True ((Invoke-Pantheon @('doctor')).ExitCode -ne 0) 'doctor should fail on drifted Fixer'
    Assert-True ((Invoke-Pantheon @('update')).ExitCode -eq 0) 'update should repair drift'
    Assert-EqualFiles $Fixer $InstalledFixer
    $doctor = Invoke-Pantheon @('doctor')
    Assert-True ($doctor.ExitCode -eq 0) "doctor failed after repair: $($doctor.Output)"
    Assert-True ($doctor.Output.Contains('Codex executable:')) 'doctor did not discover codex on PATH'
    Pass 'doctor detects drift, update repairs it, and Codex discovery works'

    $goodAgents = [System.IO.File]::ReadAllText($AgentsFile)
    [System.IO.File]::AppendAllText($AgentsFile, "`r`n<!-- PANTHEON:START -->`r`ncorrupt duplicate`r`n")
    $brokenBefore = (Get-FileHash -LiteralPath $AgentsFile -Algorithm SHA256).Hash
    $broken = Invoke-Pantheon @('update')
    Assert-True ($broken.ExitCode -ne 0) 'update should refuse malformed markers'
    Assert-True ($brokenBefore -ceq (Get-FileHash -LiteralPath $AgentsFile -Algorithm SHA256).Hash) 'failed update modified malformed AGENTS.md'
    [System.IO.File]::WriteAllText($AgentsFile, $goodAgents)
    Pass 'malformed markers fail closed'

    [System.IO.File]::AppendAllText($AgentsFile, "`r`nLegacy Codex Pantheon note outside managed block.`r`n")
    $warning = Invoke-Pantheon @('doctor')
    Assert-True ($warning.ExitCode -eq 0 -and $warning.Output.Contains('legacy/unmanaged Pantheon instructions')) 'doctor should warn about unmanaged Pantheon text'
    Pass 'doctor warns without deleting unmanaged text'

    $uninstall = Invoke-Pantheon @('uninstall')
    Assert-True ($uninstall.ExitCode -eq 0) "uninstall failed: $($uninstall.Output)"
    Assert-NotContains $AgentsFile '<!-- PANTHEON:START -->'
    Assert-Contains $AgentsFile 'Keep this exact user-owned line.'
    Assert-Contains $AgentsFile 'Legacy Codex Pantheon note outside managed block.'
    Assert-File (Join-Path (Join-Path $env:CODEX_HOME 'agents') 'user-custom.toml')
    Assert-File (Join-Path $UserSkill 'SKILL.md')
    Assert-NoPath (Join-Path $env:CODEX_HOME '.pantheon-version')
    Pass 'uninstall removes only Pantheon-owned state'

    $env:CODEX_HOME = Join-Path $Temp 'bootstrap-codex'
    $env:PANTHEON_SKILLS_HOME = Join-Path $Temp 'bootstrap-skills'
    $bootstrap = Invoke-Pantheon @('bootstrap')
    Assert-True ($bootstrap.ExitCode -eq 0) "bootstrap failed: $($bootstrap.Output)"
    Assert-True ($bootstrap.Output.Contains('Pantheon-owned files synchronized to v0.7.0.') -and $bootstrap.Output.Contains('Status: HEALTHY')) 'bootstrap did not install and run doctor'
    Pass 'bootstrap installs and verifies Windows state'

    $env:USERPROFILE = Join-Path $Temp 'profile'
    New-Item -ItemType Directory -Path $env:USERPROFILE -Force | Out-Null
    Remove-Item Env:CODEX_HOME -ErrorAction SilentlyContinue
    Remove-Item Env:PANTHEON_SKILLS_HOME -ErrorAction SilentlyContinue
    $defaults = Invoke-Pantheon @('install')
    Assert-True ($defaults.ExitCode -eq 0) "default-path install failed: $($defaults.Output)"
    Assert-File (Join-Path (Join-Path $env:USERPROFILE '.codex') '.pantheon-version')
    Assert-File (Join-Path (Join-Path (Join-Path (Join-Path $env:USERPROFILE '.agents') 'skills') 'pantheon') 'SKILL.md')
    Assert-True ((Invoke-Pantheon @('uninstall')).ExitCode -eq 0) 'default-path uninstall failed'
    Pass 'Windows defaults resolve under USERPROFILE'
}
finally {
    foreach ($name in @('CODEX_HOME', 'PANTHEON_SKILLS_HOME', 'USERPROFILE')) {
        $value = $Original[$name]
        if ($null -eq $value) { Remove-Item "Env:$name" -ErrorAction SilentlyContinue } else { Set-Item "Env:$name" $value }
    }
    $env:PATH = $Original.PATH
    Remove-Item -LiteralPath $Temp -Recurse -Force -ErrorAction SilentlyContinue
}

Assert-Contains (Join-Path $Root 'README.md') 'v0.7.0'
Assert-Contains (Join-Path $Root 'README.md') 'Windows'
Assert-Contains (Join-Path (Join-Path $Root 'docs') 'CODEX_INSTALL.md') '.\pantheon.ps1 bootstrap'
Assert-Contains (Join-Path (Join-Path $Root 'docs') 'CLI_REFERENCE.md') 'pantheon.ps1'
Assert-Contains (Join-Path $Root 'CHANGELOG.md') '## 0.7.0 — 2026-09-09'
Pass 'Windows documentation and release metadata coverage'

Write-Output "1..$Pass"
