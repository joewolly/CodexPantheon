Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Pantheon = Join-Path $Root 'pantheon.ps1'
$PowerShellExe = (Get-Process -Id $PID).Path
$Pass = 0

function Pass([string]$Message) {
    $script:Pass++
    Write-Output "ok $script:Pass - $Message"
}

function Fail([string]$Message) {
    [Console]::Error.WriteLine("not ok - $Message")
    exit 1
}

function Assert-True([bool]$Condition, [string]$Message) {
    if (-not $Condition) { Fail $Message }
}

function Assert-File([string]$Path) {
    Assert-True (Test-Path -LiteralPath $Path -PathType Leaf) "expected file: $Path"
}

function Assert-NoPath([string]$Path) {
    Assert-True (-not (Test-Path -LiteralPath $Path)) "expected missing path: $Path"
}

function Assert-Contains([string]$Path, [string]$Text) {
    Assert-File $Path
    Assert-True ([System.IO.File]::ReadAllText($Path).Contains($Text)) "expected '$Text' in $Path"
}

function Assert-NotContains([string]$Path, [string]$Text) {
    if (-not (Test-Path -LiteralPath $Path -PathType Leaf)) { return }
    Assert-True (-not [System.IO.File]::ReadAllText($Path).Contains($Text)) "did not expect '$Text' in $Path"
}

function Assert-EqualFiles([string]$Left, [string]$Right) {
    Assert-File $Left
    Assert-File $Right
    $leftHash = (Get-FileHash -LiteralPath $Left -Algorithm SHA256).Hash
    $rightHash = (Get-FileHash -LiteralPath $Right -Algorithm SHA256).Hash
    Assert-True ($leftHash -ceq $rightHash) "files differ: $Left $Right"
}

function Invoke-Pantheon([string[]]$Arguments) {
    $output = & $PowerShellExe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $Pantheon @Arguments 2>&1
    $exitCode = $LASTEXITCODE
    return [PSCustomObject]@{
        ExitCode = $exitCode
        Output = (@($output | ForEach-Object { [string]$_ }) -join [Environment]::NewLine)
    }
}

Assert-File $Pantheon
Assert-File (Join-Path $Root 'install.ps1')
Assert-Contains (Join-Path $Root 'VERSION') '0.6.1'
Assert-Contains $Pantheon '$Version = "0.6.1"'
$versionResult = Invoke-Pantheon @('version')
Assert-True ($versionResult.ExitCode -eq 0) 'version command should succeed'
Assert-True ($versionResult.Output.Contains('Codex Pantheon 0.6.1')) 'version command should print v0.6.1'
Pass 'PowerShell entrypoints and release version'

$Explorer = Join-Path (Join-Path $Root 'agents') 'luna-explorer.toml'
$Librarian = Join-Path (Join-Path $Root 'agents') 'luna-librarian.toml'
$Fixer = Join-Path (Join-Path $Root 'agents') 'luna-fixer.toml'
foreach ($agent in @($Explorer, $Librarian, $Fixer)) {
    Assert-File $agent
    Assert-Contains $agent 'model = "gpt-5.6-luna"'
    Assert-Contains $agent 'model_reasoning_effort = "high"'
}
Pass 'Windows frontend consumes the shared Luna payload'

$Temp = Join-Path ([System.IO.Path]::GetTempPath()) ('pantheon-windows-tests-' + [Guid]::NewGuid().ToString('N'))
New-Item -ItemType Directory -Path $Temp -Force | Out-Null

$OriginalCodeHome = $env:CODEX_HOME
$OriginalSkillsHome = $env:PANTHEON_SKILLS_HOME
$OriginalUserProfile = $env:USERPROFILE
$OriginalPath = $env:PATH

try {
    $env:CODEX_HOME = Join-Path $Temp 'codex-home'
    $env:PANTHEON_SKILLS_HOME = Join-Path $Temp 'skills'
    New-Item -ItemType Directory -Path (Join-Path $env:CODEX_HOME 'agents') -Force | Out-Null
    New-Item -ItemType Directory -Path $env:PANTHEON_SKILLS_HOME -Force | Out-Null

    $agentsFile = Join-Path $env:CODEX_HOME 'AGENTS.md'
    [System.IO.File]::WriteAllText($agentsFile, "# User instructions`r`n`r`nKeep this exact user-owned line.`r`n")
    [System.IO.File]::WriteAllText((Join-Path (Join-Path $env:CODEX_HOME 'agents') 'user-custom.toml'), "do-not-touch`r`n")
    $userSkill = Join-Path $env:PANTHEON_SKILLS_HOME 'user-skill'
    New-Item -ItemType Directory -Path $userSkill -Force | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $userSkill 'SKILL.md'), "user skill`r`n")

    $legacyAgents = @(
        'pantheon-worker.toml',
        'pantheon-explorer.toml',
        'pantheon-librarian.toml',
        'pantheon-oracle.toml',
        'pantheon-fixer.toml',
        'pantheon-designer.toml',
        'pantheon-reviewer.toml',
        'pantheon-verifier.toml'
    )
    foreach ($legacy in $legacyAgents) {
        [System.IO.File]::WriteAllText((Join-Path (Join-Path $env:CODEX_HOME 'agents') $legacy), "legacy`r`n")
    }
    $legacyTeam = Join-Path $env:PANTHEON_SKILLS_HOME 'pantheon-team'
    New-Item -ItemType Directory -Path $legacyTeam -Force | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $legacyTeam 'SKILL.md'), "legacy team`r`n")

    $fakeBin = Join-Path $Temp 'fake-bin'
    New-Item -ItemType Directory -Path $fakeBin -Force | Out-Null
    [System.IO.File]::WriteAllText((Join-Path $fakeBin 'codex.cmd'), "@echo codex-cli windows-test`r`n")
    $env:PATH = $fakeBin + [System.IO.Path]::PathSeparator + $OriginalPath

    $install = Invoke-Pantheon @('install')
    Assert-True ($install.ExitCode -eq 0) "install failed: $($install.Output)"
    Assert-Contains $agentsFile 'Keep this exact user-owned line.'
    Assert-True ((@([System.IO.File]::ReadAllLines($agentsFile) | Where-Object { $_ -ceq '<!-- PANTHEON:START -->' }).Count) -eq 1) 'expected one Pantheon start marker'
    Assert-True ((@([System.IO.File]::ReadAllLines($agentsFile) | Where-Object { $_ -ceq '<!-- PANTHEON:END -->' }).Count) -eq 1) 'expected one Pantheon end marker'
    Assert-Contains (Join-Path $env:CODEX_HOME '.pantheon-version') '0.6.1'
    Assert-File (Join-Path (Join-Path $env:CODEX_HOME 'agents') 'user-custom.toml')
    Assert-File (Join-Path $userSkill 'SKILL.md')

    foreach ($agent in @('luna-explorer.toml', 'luna-librarian.toml', 'luna-fixer.toml')) {
        Assert-EqualFiles (Join-Path (Join-Path $Root 'agents') $agent) (Join-Path (Join-Path $env:CODEX_HOME 'agents') $agent)
    }
    foreach ($legacy in $legacyAgents) {
        Assert-NoPath (Join-Path (Join-Path $env:CODEX_HOME 'agents') $legacy)
    }
    Assert-NoPath $legacyTeam
    foreach ($skill in @('pantheon', 'pantheon-daily', 'pantheon-plan', 'pantheon-review')) {
        Assert-EqualFiles (Join-Path (Join-Path (Join-Path $Root 'skills') $skill) 'SKILL.md') (Join-Path (Join-Path $env:PANTHEON_SKILLS_HOME $skill) 'SKILL.md')
    }
    Pass 'install migrates legacy payload and preserves unrelated Windows configuration'

    $before = (Get-FileHash -LiteralPath $agentsFile -Algorithm SHA256).Hash
    $repeat = Invoke-Pantheon @('install')
    Assert-True ($repeat.ExitCode -eq 0) "repeated install failed: $($repeat.Output)"
    $after = (Get-FileHash -LiteralPath $agentsFile -Algorithm SHA256).Hash
    Assert-True ($before -ceq $after) 'repeated install changed managed AGENTS.md unexpectedly'
    Pass 'install is idempotent on Windows'

    $installedFixer = Join-Path (Join-Path $env:CODEX_HOME 'agents') 'luna-fixer.toml'
    Add-Content -LiteralPath $installedFixer -Value 'drift'
    $driftDoctor = Invoke-Pantheon @('doctor')
    Assert-True ($driftDoctor.ExitCode -ne 0) 'doctor should fail on drifted Fixer'
    $repair = Invoke-Pantheon @('update')
    Assert-True ($repair.ExitCode -eq 0) "update failed: $($repair.Output)"
    Assert-EqualFiles $Fixer $installedFixer
    $healthyDoctor = Invoke-Pantheon @('doctor')
    Assert-True ($healthyDoctor.ExitCode -eq 0) "doctor should pass after repair: $($healthyDoctor.Output)"
    Assert-True ($healthyDoctor.Output.Contains('Codex executable:')) 'doctor should discover codex on PATH'
    Pass 'doctor detects drift, update repairs it, and Windows Codex discovery works'

    $goodAgents = [System.IO.File]::ReadAllText($agentsFile)
    [System.IO.File]::AppendAllText($agentsFile, "`r`n<!-- PANTHEON:START -->`r`ncorrupt duplicate`r`n")
    $brokenBefore = (Get-FileHash -LiteralPath $agentsFile -Algorithm SHA256).Hash
    $brokenUpdate = Invoke-Pantheon @('update')
    Assert-True ($brokenUpdate.ExitCode -ne 0) 'update should refuse duplicate markers'
    $brokenAfter = (Get-FileHash -LiteralPath $agentsFile -Algorithm SHA256).Hash
    Assert-True ($brokenBefore -ceq $brokenAfter) 'failed update modified malformed AGENTS.md'
    [System.IO.File]::WriteAllText($agentsFile, $goodAgents)
    Pass 'malformed markers fail closed without modifying AGENTS.md'

    [System.IO.File]::AppendAllText($agentsFile, "`r`nLegacy Codex Pantheon note outside managed block.`r`n")
    $warningDoctor = Invoke-Pantheon @('doctor')
    Assert-True ($warningDoctor.ExitCode -eq 0) "doctor warning state should remain healthy: $($warningDoctor.Output)"
    Assert-True ($warningDoctor.Output.Contains('legacy/unmanaged Pantheon instructions')) 'doctor should warn about unmanaged Pantheon text'
    Pass 'doctor warns about possible unmanaged Pantheon text'

    $uninstall = Invoke-Pantheon @('uninstall')
    Assert-True ($uninstall.ExitCode -eq 0) "uninstall failed: $($uninstall.Output)"
    Assert-NotContains $agentsFile '<!-- PANTHEON:START -->'
    Assert-Contains $agentsFile 'Keep this exact user-owned line.'
    Assert-Contains $agentsFile 'Legacy Codex Pantheon note outside managed block.'
    Assert-File (Join-Path (Join-Path $env:CODEX_HOME 'agents') 'user-custom.toml')
    Assert-File (Join-Path $userSkill 'SKILL.md')
    Assert-NoPath (Join-Path $env:CODEX_HOME '.pantheon-version')
    foreach ($agent in @('luna-explorer.toml', 'luna-librarian.toml', 'luna-fixer.toml')) {
        Assert-NoPath (Join-Path (Join-Path $env:CODEX_HOME 'agents') $agent)
    }
    Pass 'uninstall removes only Pantheon-owned Windows state'

    $bootstrapRoot = Join-Path $Temp 'bootstrap'
    $env:CODEX_HOME = Join-Path $bootstrapRoot 'codex'
    $env:PANTHEON_SKILLS_HOME = Join-Path $bootstrapRoot 'skills'
    $bootstrap = Invoke-Pantheon @('bootstrap')
    Assert-True ($bootstrap.ExitCode -eq 0) "bootstrap failed: $($bootstrap.Output)"
    Assert-True ($bootstrap.Output.Contains('Pantheon-owned files synchronized to v0.6.1.')) 'bootstrap should report v0.6.1 synchronization'
    Assert-True ($bootstrap.Output.Contains('Status: HEALTHY')) 'bootstrap should run doctor'
    Assert-File (Join-Path $env:CODEX_HOME '.pantheon-version')
    Pass 'bootstrap performs install/update plus doctor on Windows'

    $env:USERPROFILE = Join-Path $Temp 'profile-defaults'
    New-Item -ItemType Directory -Path $env:USERPROFILE -Force | Out-Null
    Remove-Item Env:CODEX_HOME -ErrorAction SilentlyContinue
    Remove-Item Env:PANTHEON_SKILLS_HOME -ErrorAction SilentlyContinue
    $defaultInstall = Invoke-Pantheon @('install')
    Assert-True ($defaultInstall.ExitCode -eq 0) "default-path install failed: $($defaultInstall.Output)"
    Assert-File (Join-Path (Join-Path $env:USERPROFILE '.codex') '.pantheon-version')
    Assert-File (Join-Path (Join-Path (Join-Path $env:USERPROFILE '.agents') 'skills\pantheon') 'SKILL.md')
    $defaultUninstall = Invoke-Pantheon @('uninstall')
    Assert-True ($defaultUninstall.ExitCode -eq 0) "default-path uninstall failed: $($defaultUninstall.Output)"
    Pass 'Windows defaults resolve under USERPROFILE'
}
finally {
    if ($null -eq $OriginalCodeHome) { Remove-Item Env:CODEX_HOME -ErrorAction SilentlyContinue } else { $env:CODEX_HOME = $OriginalCodeHome }
    if ($null -eq $OriginalSkillsHome) { Remove-Item Env:PANTHEON_SKILLS_HOME -ErrorAction SilentlyContinue } else { $env:PANTHEON_SKILLS_HOME = $OriginalSkillsHome }
    if ($null -eq $OriginalUserProfile) { Remove-Item Env:USERPROFILE -ErrorAction SilentlyContinue } else { $env:USERPROFILE = $OriginalUserProfile }
    $env:PATH = $OriginalPath
    Remove-Item -LiteralPath $Temp -Recurse -Force -ErrorAction SilentlyContinue
}

Assert-Contains (Join-Path $Root 'README.md') 'Windows'
Assert-Contains (Join-Path (Join-Path $Root 'docs') 'CODEX_INSTALL.md') '.\pantheon.ps1 bootstrap'
Assert-Contains (Join-Path (Join-Path $Root 'docs') 'CLI_REFERENCE.md') 'pantheon.ps1'
Pass 'Windows installation documentation is present'

Write-Output "1..$Pass"
