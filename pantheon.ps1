[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Command = 'help'
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Version = '0.6.0'
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$StartMarker = '<!-- PANTHEON:START -->'
$EndMarker = '<!-- PANTHEON:END -->'
$Utf8NoBom = New-Object -TypeName System.Text.UTF8Encoding -ArgumentList $false

$AgentFiles = @('luna-explorer.toml', 'luna-librarian.toml', 'luna-fixer.toml')
$LegacyAgentFiles = @(
    'pantheon-worker.toml',
    'pantheon-explorer.toml',
    'pantheon-librarian.toml',
    'pantheon-oracle.toml',
    'pantheon-fixer.toml',
    'pantheon-designer.toml',
    'pantheon-reviewer.toml',
    'pantheon-verifier.toml'
)
$SkillDirs = @('pantheon', 'pantheon-daily', 'pantheon-plan', 'pantheon-review')
$LegacySkillDirs = @('pantheon-team')

function Resolve-UserHome {
    if (-not [string]::IsNullOrWhiteSpace($env:USERPROFILE)) { return $env:USERPROFILE }
    if (-not [string]::IsNullOrWhiteSpace($HOME)) { return $HOME }
    throw 'Unable to resolve the current user profile directory.'
}

$UserHome = Resolve-UserHome
$CodexHomeDir = if (-not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) { $env:CODEX_HOME } else { Join-Path $UserHome '.codex' }
$AgentDestDir = Join-Path $CodexHomeDir 'agents'
$SkillsDestRoot = if (-not [string]::IsNullOrWhiteSpace($env:PANTHEON_SKILLS_HOME)) { $env:PANTHEON_SKILLS_HOME } else { Join-Path (Join-Path $UserHome '.agents') 'skills' }
$AgentsFile = Join-Path $CodexHomeDir 'AGENTS.md'
$VersionFile = Join-Path $CodexHomeDir '.pantheon-version'
$BlockFile = Join-Path (Join-Path $ScriptDir 'policy') 'managed-block.md'

function Say([string]$Message = '') { Write-Output $Message }
function Ok([string]$Message) { Write-Output "✓ $Message" }
function Warn([string]$Message) { [Console]::Error.WriteLine("! $Message") }
function Fail([string]$Message) { [Console]::Error.WriteLine("✗ $Message"); exit 1 }

function Get-UsageText {
    @"
Codex Pantheon $Version

Usage:
  .\pantheon.ps1 bootstrap
  .\pantheon.ps1 install
  .\pantheon.ps1 update
  .\pantheon.ps1 doctor
  .\pantheon.ps1 uninstall
  .\pantheon.ps1 version
  .\pantheon.ps1 help

Environment:
  CODEX_HOME              Codex home (default: %USERPROFILE%\.codex)
  PANTHEON_SKILLS_HOME    Skill root (default: %USERPROFILE%\.agents\skills)
"@
}

function Get-PathItem([string]$Path) {
    try {
        Get-Item -LiteralPath $Path -Force -ErrorAction Stop
        return
    }
    catch {
        $parent = Split-Path -Parent $Path
        $leaf = Split-Path -Leaf $Path
        if (-not [string]::IsNullOrWhiteSpace($parent) -and (Test-Path -LiteralPath $parent -PathType Container)) {
            Get-ChildItem -LiteralPath $parent -Force -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -ceq $leaf } |
                Select-Object -First 1
        }
    }
}

function Test-ReparsePoint($Item) {
    if ($null -eq $Item) { return $false }
    (($Item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0)
}

function Test-RegularFile([string]$Path) {
    $item = Get-PathItem $Path
    ($null -ne $item -and -not $item.PSIsContainer -and -not (Test-ReparsePoint $item))
}

function Test-RegularDirectory([string]$Path) {
    $item = Get-PathItem $Path
    ($null -ne $item -and $item.PSIsContainer -and -not (Test-ReparsePoint $item))
}

function Remove-OwnedPath([string]$Path) {
    $item = Get-PathItem $Path
    if ($null -eq $item) { return }
    if (Test-ReparsePoint $item) {
        Remove-Item -LiteralPath $Path -Force
    }
    else {
        Remove-Item -LiteralPath $Path -Recurse -Force
    }
}

function Read-Text([string]$Path) { [System.IO.File]::ReadAllText($Path) }

function Write-Utf8NoBom([string]$Path, [string]$Text) {
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    [System.IO.File]::WriteAllText($Path, $Text, $Utf8NoBom)
}

function Write-TextAtomic([string]$Path, [string]$Text) {
    $parent = Split-Path -Parent $Path
    if (-not (Test-Path -LiteralPath $parent -PathType Container)) {
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
    }
    $temp = Join-Path $parent ('.pantheon-' + [Guid]::NewGuid().ToString('N') + '.tmp')
    try {
        Write-Utf8NoBom $temp $Text
        Move-Item -LiteralPath $temp -Destination $Path -Force
    }
    finally {
        if ($null -ne (Get-PathItem $temp)) {
            Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue
        }
    }
}

function Get-MarkerState {
    $item = Get-PathItem $AgentsFile
    if ($null -eq $item) {
        return [PSCustomObject]@{ Lines = @(); Starts = 0; Ends = 0; StartIndex = -1; EndIndex = -1 }
    }
    if ($item.PSIsContainer) { Fail "$AgentsFile exists but is not a regular file. Refusing to modify it." }
    if (Test-ReparsePoint $item) { Fail "$AgentsFile is a reparse point. Refusing to modify it." }

    $lines = @([System.IO.File]::ReadAllLines($AgentsFile))
    $starts = @($lines | Where-Object { $_ -ceq $StartMarker }).Count
    $ends = @($lines | Where-Object { $_ -ceq $EndMarker }).Count
    $startIndex = if ($starts -eq 1) { [Array]::IndexOf($lines, $StartMarker) } else { -1 }
    $endIndex = if ($ends -eq 1) { [Array]::IndexOf($lines, $EndMarker) } else { -1 }
    [PSCustomObject]@{ Lines = $lines; Starts = $starts; Ends = $ends; StartIndex = $startIndex; EndIndex = $endIndex }
}

function Validate-MarkerState {
    $state = Get-MarkerState
    if ($state.Starts -ne $state.Ends -or $state.Starts -gt 1) {
        Fail "Malformed or duplicate Pantheon markers in $AgentsFile. Fix them manually before install/update/uninstall."
    }
    if ($state.Starts -eq 1 -and $state.EndIndex -le $state.StartIndex) {
        Fail "Malformed Pantheon marker order in $AgentsFile. Fix it manually before install/update/uninstall."
    }
    $state
}

function Require-SourceTree {
    $sourceVersion = Join-Path $ScriptDir 'VERSION'
    if (-not (Test-RegularFile $sourceVersion)) { Fail 'Missing or unsafe source VERSION file.' }
    if ((Read-Text $sourceVersion).Trim() -cne $Version) { Fail "Source VERSION does not match CLI version $Version." }
    if (-not (Test-RegularFile $BlockFile)) { Fail 'Missing or unsafe policy/managed-block.md.' }

    foreach ($file in $AgentFiles) {
        $path = Join-Path (Join-Path $ScriptDir 'agents') $file
        if (-not (Test-RegularFile $path)) { Fail "Missing or unsafe source agent: agents/$file" }
        $text = Read-Text $path
        if (-not [regex]::IsMatch($text, '(?m)^name\s*=')) { Fail "Agent missing name: agents/$file" }
        if (-not [regex]::IsMatch($text, '(?m)^description\s*=')) { Fail "Agent missing description: agents/$file" }
        if (-not [regex]::IsMatch($text, '(?m)^developer_instructions\s*=')) { Fail "Agent missing developer_instructions: agents/$file" }
    }

    foreach ($file in $LegacyAgentFiles) {
        if ($null -ne (Get-PathItem (Join-Path (Join-Path $ScriptDir 'agents') $file))) {
            Fail "Legacy source agent must not exist in v${Version}: agents/$file"
        }
    }

    foreach ($skill in $SkillDirs) {
        $dir = Join-Path (Join-Path $ScriptDir 'skills') $skill
        $path = Join-Path $dir 'SKILL.md'
        if (-not (Test-RegularDirectory $dir)) { Fail "Missing or unsafe source skill directory: skills/$skill" }
        if (-not (Test-RegularFile $path)) { Fail "Missing or unsafe source skill: skills/$skill/SKILL.md" }
        $text = Read-Text $path
        if (-not [regex]::IsMatch($text, '(?m)^name:')) { Fail "Skill missing name metadata: skills/$skill/SKILL.md" }
        if (-not [regex]::IsMatch($text, '(?m)^description:')) { Fail "Skill missing description metadata: skills/$skill/SKILL.md" }
    }

    foreach ($skill in $LegacySkillDirs) {
        if ($null -ne (Get-PathItem (Join-Path (Join-Path $ScriptDir 'skills') $skill))) {
            Fail "Legacy source skill must not exist in v${Version}: skills/$skill"
        }
    }
}

function Replace-OrAppendBlock {
    $state = Validate-MarkerState
    New-Item -ItemType Directory -Path $CodexHomeDir -Force | Out-Null

    if ($null -eq (Get-PathItem $AgentsFile)) {
        Copy-Item -LiteralPath $BlockFile -Destination $AgentsFile
        return
    }

    $newline = [Environment]::NewLine
    $blockLines = @([System.IO.File]::ReadAllLines($BlockFile))
    if ($state.Starts -eq 0) {
        $existing = Read-Text $AgentsFile
        $block = $blockLines -join $newline
        $text = if ($existing.Length -gt 0) { $existing + $newline + $block + $newline } else { $block + $newline }
        Write-TextAtomic $AgentsFile $text
        return
    }

    $output = New-Object 'System.Collections.Generic.List[string]'
    for ($i = 0; $i -lt $state.StartIndex; $i++) { $output.Add($state.Lines[$i]) }
    foreach ($line in $blockLines) { $output.Add($line) }
    for ($i = $state.EndIndex + 1; $i -lt $state.Lines.Count; $i++) { $output.Add($state.Lines[$i]) }
    Write-TextAtomic $AgentsFile (($output -join $newline) + $newline)
}

function Remove-ManagedBlock {
    $state = Validate-MarkerState
    if ($state.Starts -ne 1) { return }

    $output = New-Object 'System.Collections.Generic.List[string]'
    for ($i = 0; $i -lt $state.StartIndex; $i++) { $output.Add($state.Lines[$i]) }
    for ($i = $state.EndIndex + 1; $i -lt $state.Lines.Count; $i++) { $output.Add($state.Lines[$i]) }

    $remaining = $output -join [Environment]::NewLine
    if ($remaining -match '\S') {
        Write-TextAtomic $AgentsFile ($remaining + [Environment]::NewLine)
    }
    else {
        Remove-OwnedPath $AgentsFile
    }
}

function Remove-LegacyPayload {
    foreach ($file in $LegacyAgentFiles) { Remove-OwnedPath (Join-Path $AgentDestDir $file) }
    foreach ($skill in $LegacySkillDirs) { Remove-OwnedPath (Join-Path $SkillsDestRoot $skill) }
}

function Install-Payload {
    Require-SourceTree
    Validate-MarkerState | Out-Null
    New-Item -ItemType Directory -Path $AgentDestDir -Force | Out-Null
    New-Item -ItemType Directory -Path $SkillsDestRoot -Force | Out-Null
    Remove-LegacyPayload

    foreach ($file in $AgentFiles) {
        $source = Join-Path (Join-Path $ScriptDir 'agents') $file
        $destination = Join-Path $AgentDestDir $file
        Remove-OwnedPath $destination
        Copy-Item -LiteralPath $source -Destination $destination
    }

    foreach ($skill in $SkillDirs) {
        $source = Join-Path (Join-Path $ScriptDir 'skills') $skill
        $destination = Join-Path $SkillsDestRoot $skill
        Remove-OwnedPath $destination
        Copy-Item -LiteralPath $source -Destination $SkillsDestRoot -Recurse
    }

    Replace-OrAppendBlock
    Write-Utf8NoBom $VersionFile ($Version + [Environment]::NewLine)
}

function Test-FilesEqual([string]$Left, [string]$Right) {
    if (-not (Test-RegularFile $Left) -or -not (Test-RegularFile $Right)) { return $false }
    (Get-FileHash -LiteralPath $Left -Algorithm SHA256).Hash -ceq (Get-FileHash -LiteralPath $Right -Algorithm SHA256).Hash
}

function Test-ManagedBlockMatches {
    $state = Get-MarkerState
    if ($state.Starts -ne 1 -or $state.Ends -ne 1 -or $state.EndIndex -le $state.StartIndex) { return $false }
    $installed = @($state.Lines[$state.StartIndex..$state.EndIndex])
    $source = @([System.IO.File]::ReadAllLines($BlockFile))
    (($installed -join "`n") -ceq ($source -join "`n"))
}

function Test-OutsideBlockContainsPantheon {
    $state = Get-MarkerState
    $outside = New-Object 'System.Collections.Generic.List[string]'
    for ($i = 0; $i -lt $state.Lines.Count; $i++) {
        if ($state.Starts -eq 1 -and $i -ge $state.StartIndex -and $i -le $state.EndIndex) { continue }
        $outside.Add($state.Lines[$i])
    }
    [regex]::IsMatch(($outside -join "`n"), '(?i)codex\s+pantheon|\$pantheon|pantheon_(worker|explorer|librarian|oracle|fixer|designer|reviewer|verifier)|luna_(explorer|librarian|fixer)')
}

function Find-Codex {
    $commandInfo = Get-Command codex -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $commandInfo) {
        if (-not [string]::IsNullOrWhiteSpace($commandInfo.Source)) { return $commandInfo.Source }
        if ($commandInfo.PSObject.Properties.Name -contains 'Path' -and -not [string]::IsNullOrWhiteSpace($commandInfo.Path)) { return $commandInfo.Path }
    }

    if ([string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) { return $null }

    $candidates = @(
        (Join-Path $env:LOCALAPPDATA 'Programs\OpenAI\Codex\bin\codex.exe'),
        (Join-Path $env:LOCALAPPDATA 'OpenAI\Codex\bin\codex.exe'),
        (Join-Path $env:LOCALAPPDATA 'Packages\OpenAI.Codex_2p2nqsd0c76g0\LocalCache\Local\OpenAI\Codex\bin\codex.exe')
    )
    foreach ($candidate in $candidates) {
        if (Test-Path -LiteralPath $candidate -PathType Leaf) { return $candidate }
    }

    $roots = @(
        (Join-Path $env:LOCALAPPDATA 'OpenAI\Codex\bin'),
        (Join-Path $env:LOCALAPPDATA 'Packages\OpenAI.Codex_2p2nqsd0c76g0\LocalCache\Local\OpenAI\Codex\bin')
    )
    foreach ($root in $roots) {
        if (-not (Test-Path -LiteralPath $root -PathType Container)) { continue }
        foreach ($dir in (Get-ChildItem -LiteralPath $root -Directory -Force -ErrorAction SilentlyContinue | Sort-Object LastWriteTimeUtc -Descending)) {
            $candidate = Join-Path $dir.FullName 'codex.exe'
            if (Test-Path -LiteralPath $candidate -PathType Leaf) { return $candidate }
        }
    }
    $null
}

function Cmd-Install {
    Install-Payload
    Say "Codex Pantheon $Version installed."
    Say 'Run: .\pantheon.ps1 doctor'
}

function Cmd-Update {
    Install-Payload
    Say "Codex Pantheon updated to $Version."
    Say 'Run: .\pantheon.ps1 doctor'
}

function Cmd-Bootstrap {
    $priorState = 'new installation'
    if ($null -ne (Get-PathItem $VersionFile) -or $null -ne (Get-PathItem $AgentsFile)) {
        $state = Get-MarkerState
        if (Test-RegularFile $VersionFile -or $state.Starts -gt 0) { $priorState = 'existing/partial installation' }
    }
    Say "Codex Pantheon bootstrap ($priorState)"
    Install-Payload
    Say "Pantheon-owned files synchronized to v$Version."
    Say
    Cmd-Doctor
}

function Cmd-Doctor {
    Require-SourceTree
    $errors = 0
    $warnings = 0

    Say 'Codex Pantheon Doctor'
    Say "Version: $Version"
    Say
    Say 'Core'

    if (Test-RegularFile $VersionFile -and (Read-Text $VersionFile).Trim() -ceq $Version) {
        Ok "Installed version marker: $Version"
    }
    else {
        [Console]::Error.WriteLine("✗ Installed version marker missing or not $Version")
        $errors++
    }

    $codexBin = Find-Codex
    if ($null -ne $codexBin) {
        $codexVersion = ''
        try { $codexVersion = [string](& $codexBin --version 2>$null | Select-Object -First 1) } catch { $codexVersion = '' }
        $suffix = if ([string]::IsNullOrWhiteSpace($codexVersion)) { '' } else { " ($codexVersion)" }
        Ok "Codex executable: $codexBin$suffix"
    }
    else {
        Warn 'Codex executable not found on PATH or in known native Windows Codex locations; static Pantheon checks can still run.'
        $warnings++
    }

    Say
    Say 'Agents'
    foreach ($file in $AgentFiles) {
        $source = Join-Path (Join-Path $ScriptDir 'agents') $file
        $destination = Join-Path $AgentDestDir $file
        $item = Get-PathItem $destination
        if ($null -ne $item -and (Test-ReparsePoint $item)) {
            [Console]::Error.WriteLine("✗ $file is a reparse point; Pantheon custom agents must be regular files")
            $errors++
        }
        elseif (-not (Test-RegularFile $destination)) {
            [Console]::Error.WriteLine("✗ $file is missing")
            $errors++
        }
        elseif (Test-FilesEqual $source $destination) { Ok $file }
        else { [Console]::Error.WriteLine("✗ $file differs from the v$Version source package"); $errors++ }
    }

    Say
    Say 'Legacy cleanup'
    $legacyErrors = 0
    foreach ($file in $LegacyAgentFiles) {
        if ($null -ne (Get-PathItem (Join-Path $AgentDestDir $file))) {
            [Console]::Error.WriteLine("✗ legacy Pantheon agent still installed: $file")
            $errors++; $legacyErrors++
        }
    }
    foreach ($skill in $LegacySkillDirs) {
        if ($null -ne (Get-PathItem (Join-Path $SkillsDestRoot $skill))) {
            [Console]::Error.WriteLine("✗ legacy Pantheon skill still installed: $skill")
            $errors++; $legacyErrors++
        }
    }
    if ($legacyErrors -eq 0) { Ok 'Legacy v0.4/v0.5 Pantheon payload absent' }

    Say
    Say 'Skills'
    foreach ($skill in $SkillDirs) {
        $source = Join-Path (Join-Path (Join-Path $ScriptDir 'skills') $skill) 'SKILL.md'
        $destination = Join-Path (Join-Path $SkillsDestRoot $skill) 'SKILL.md'
        $item = Get-PathItem $destination
        if ($null -ne $item -and (Test-ReparsePoint $item)) {
            [Console]::Error.WriteLine("✗ $skill/SKILL.md is a reparse point")
            $errors++
        }
        elseif (-not (Test-RegularFile $destination)) {
            [Console]::Error.WriteLine("✗ $skill is missing")
            $errors++
        }
        elseif (Test-FilesEqual $source $destination) { Ok $skill }
        else { [Console]::Error.WriteLine("✗ $skill differs from the v$Version source package"); $errors++ }
    }

    Say
    Say 'Policy'
    $agentsItem = Get-PathItem $AgentsFile
    if ($null -eq $agentsItem -or $agentsItem.PSIsContainer) {
        [Console]::Error.WriteLine("✗ $AgentsFile is missing")
        $errors++
    }
    elseif (Test-ReparsePoint $agentsItem) {
        [Console]::Error.WriteLine("✗ $AgentsFile is a reparse point; Pantheon refuses to manage it")
        $errors++
    }
    else {
        $state = Get-MarkerState
        if ($state.Starts -ne 1 -or $state.Ends -ne 1 -or $state.EndIndex -le $state.StartIndex) {
            [Console]::Error.WriteLine('✗ Managed Pantheon marker pair is missing, malformed, duplicated, or misordered')
            $errors++
        }
        else {
            if (Test-ManagedBlockMatches) { Ok "Managed AGENTS.md block matches v$Version" }
            else { [Console]::Error.WriteLine("✗ Managed AGENTS.md block differs from v$Version"); $errors++ }

            if (Test-OutsideBlockContainsPantheon) {
                Warn 'Possible legacy/unmanaged Pantheon instructions exist outside the managed block; review them manually before deleting anything.'
                $warnings++
            }
        }
    }

    Say
    if ($errors -eq 0 -and $warnings -eq 0) { Say 'Status: HEALTHY'; return }
    if ($errors -eq 0) { Say "Status: HEALTHY WITH WARNINGS ($warnings)"; return }
    Say "Status: UNHEALTHY ($errors error(s), $warnings warning(s))"
    Say 'Repair Pantheon-owned files with: .\pantheon.ps1 update'
    exit 1
}

function Cmd-Uninstall {
    Validate-MarkerState | Out-Null
    foreach ($file in @($AgentFiles + $LegacyAgentFiles)) { Remove-OwnedPath (Join-Path $AgentDestDir $file) }
    foreach ($skill in @($SkillDirs + $LegacySkillDirs)) { Remove-OwnedPath (Join-Path $SkillsDestRoot $skill) }
    Remove-ManagedBlock
    Remove-OwnedPath $VersionFile
    Say "Codex Pantheon $Version uninstalled."
    Say 'Other Codex configuration and non-Pantheon skills were preserved.'
}

switch ($Command.ToLowerInvariant()) {
    'bootstrap' { Cmd-Bootstrap; break }
    'install' { Cmd-Install; break }
    'update' { Cmd-Update; break }
    'doctor' { Cmd-Doctor; break }
    'uninstall' { Cmd-Uninstall; break }
    'version' { Say "Codex Pantheon $Version"; break }
    '--version' { Say "Codex Pantheon $Version"; break }
    '-v' { Say "Codex Pantheon $Version"; break }
    'help' { Say (Get-UsageText); break }
    '--help' { Say (Get-UsageText); break }
    '-h' { Say (Get-UsageText); break }
    default { [Console]::Error.WriteLine((Get-UsageText)); exit 2 }
}
