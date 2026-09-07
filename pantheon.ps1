[CmdletBinding()]
param(
    [Parameter(Position = 0)]
    [string]$Command = "help"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$Version = "0.6.1"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$StartMarker = '<!-- PANTHEON:START -->'
$EndMarker = '<!-- PANTHEON:END -->'
$Utf8NoBom = New-Object -TypeName System.Text.UTF8Encoding -ArgumentList $false

$AgentFiles = @(
    'luna-explorer.toml',
    'luna-librarian.toml',
    'luna-fixer.toml'
)

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

$SkillDirs = @(
    'pantheon',
    'pantheon-daily',
    'pantheon-plan',
    'pantheon-review'
)

$LegacySkillDirs = @('pantheon-team')

function Resolve-UserHome {
    if (-not [string]::IsNullOrWhiteSpace($env:USERPROFILE)) {
        return $env:USERPROFILE
    }
    if (-not [string]::IsNullOrWhiteSpace($HOME)) {
        return $HOME
    }
    throw 'Unable to resolve the current user profile directory.'
}

$UserHome = Resolve-UserHome
$CodexHomeDir = if (-not [string]::IsNullOrWhiteSpace($env:CODEX_HOME)) { $env:CODEX_HOME } else { Join-Path $UserHome '.codex' }
$AgentDestDir = Join-Path $CodexHomeDir 'agents'
$SkillsDestRoot = if (-not [string]::IsNullOrWhiteSpace($env:PANTHEON_SKILLS_HOME)) { $env:PANTHEON_SKILLS_HOME } else { Join-Path (Join-Path $UserHome '.agents') 'skills' }
$AgentsFile = Join-Path $CodexHomeDir 'AGENTS.md'
$VersionFile = Join-Path $CodexHomeDir '.pantheon-version'
$BlockFile = Join-Path (Join-Path $ScriptDir 'policy') 'managed-block.md'

function Say([string]$Message = '') {
    Write-Output $Message
}

function Ok([string]$Message) {
    Write-Output "✓ $Message"
}

function Warn([string]$Message) {
    [Console]::Error.WriteLine("! $Message")
}

function Fail([string]$Message) {
    [Console]::Error.WriteLine("✗ $Message")
    exit 1
}

function Get-UsageText {
    return @"
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
        return Get-Item -LiteralPath $Path -Force -ErrorAction Stop
    }
    catch {
        $parent = Split-Path -Parent $Path
        $leaf = Split-Path -Leaf $Path
        if (-not [string]::IsNullOrWhiteSpace($parent) -and (Test-Path -LiteralPath $parent -PathType Container)) {
            return Get-ChildItem -LiteralPath $parent -Force -ErrorAction SilentlyContinue |
                Where-Object { $_.Name -ceq $leaf } |
                Select-Object -First 1
        }
        return $null
    }
}

function Test-ReparsePointItem($Item) {
    if ($null -eq $Item) { return $false }
    return (($Item.Attributes -band [System.IO.FileAttributes]::ReparsePoint) -ne 0)
}

function Test-RegularFile([string]$Path) {
    $item = Get-PathItem $Path
    return ($null -ne $item -and -not $item.PSIsContainer -and -not (Test-ReparsePointItem $item))
}

function Test-RegularDirectory([string]$Path) {
    $item = Get-PathItem $Path
    return ($null -ne $item -and $item.PSIsContainer -and -not (Test-ReparsePointItem $item))
}

function Remove-PathSafely([string]$Path) {
    $item = Get-PathItem $Path
    if ($null -eq $item) { return }

    if (Test-ReparsePointItem $item) {
        Remove-Item -LiteralPath $Path -Force
    }
    else {
        Remove-Item -LiteralPath $Path -Recurse -Force
    }
}

function Read-Text([string]$Path) {
    return [System.IO.File]::ReadAllText($Path)
}

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
        $existing = Get-PathItem $Path
        if ($null -eq $existing) {
            Move-Item -LiteralPath $temp -Destination $Path
        }
        else {
            if ($existing.PSIsContainer -or (Test-ReparsePointItem $existing)) {
                throw "Refusing to replace non-regular path: $Path"
            }
            [System.IO.File]::Replace($temp, $Path, $null)
        }
    }
    finally {
        if ($null -ne (Get-PathItem $temp)) {
            Remove-Item -LiteralPath $temp -Force -ErrorAction SilentlyContinue
        }
    }
}

function Get-MarkerCount([string]$Marker, [string]$Path) {
    if (-not (Test-RegularFile $Path)) { return 0 }
    $lines = @([System.IO.File]::ReadAllLines($Path))
    return @($lines | Where-Object { $_ -ceq $Marker }).Count
}

function Validate-MarkerState {
    $item = Get-PathItem $AgentsFile
    if ($null -eq $item) { return }
    if ($item.PSIsContainer) { Fail "$AgentsFile exists but is not a regular file. Refusing to modify it." }
    if (Test-ReparsePointItem $item) { Fail "$AgentsFile is a reparse point. Refusing to modify it." }

    $lines = @([System.IO.File]::ReadAllLines($AgentsFile))
    $starts = @($lines | Where-Object { $_ -ceq $StartMarker }).Count
    $ends = @($lines | Where-Object { $_ -ceq $EndMarker }).Count
    if ($starts -ne $ends -or $starts -gt 1) {
        Fail "Malformed or duplicate Pantheon markers in $AgentsFile. Fix them manually before install/update/uninstall."
    }
    if ($starts -eq 1) {
        $startIndex = [Array]::IndexOf($lines, $StartMarker)
        $endIndex = [Array]::IndexOf($lines, $EndMarker)
        if ($startIndex -lt 0 -or $endIndex -le $startIndex) {
            Fail "Malformed Pantheon marker order in $AgentsFile. Fix it manually before install/update/uninstall."
        }
    }
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
        $path = Join-Path (Join-Path $ScriptDir 'agents') $file
        if ($null -ne (Get-PathItem $path)) { Fail "Legacy source agent must not exist in v$Version`: agents/$file" }
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
        $path = Join-Path (Join-Path $ScriptDir 'skills') $skill
        if ($null -ne (Get-PathItem $path)) { Fail "Legacy source skill must not exist in v$Version`: skills/$skill" }
    }
}

function Replace-OrAppendBlock {
    Validate-MarkerState
    New-Item -ItemType Directory -Path $CodexHomeDir -Force | Out-Null

    if ($null -eq (Get-PathItem $AgentsFile)) {
        Copy-Item -LiteralPath $BlockFile -Destination $AgentsFile
        return
    }

    $newline = [Environment]::NewLine
    $blockLines = @([System.IO.File]::ReadAllLines($BlockFile))
    $lines = @([System.IO.File]::ReadAllLines($AgentsFile))
    $starts = @($lines | Where-Object { $_ -ceq $StartMarker }).Count

    if ($starts -eq 0) {
        $existing = Read-Text $AgentsFile
        $block = $blockLines -join $newline
        $text = if ($existing.Length -gt 0) { $existing + $newline + $block + $newline } else { $block + $newline }
        Write-TextAtomic $AgentsFile $text
        return
    }

    $startIndex = [Array]::IndexOf($lines, $StartMarker)
    $endIndex = [Array]::IndexOf($lines, $EndMarker)
    $output = New-Object 'System.Collections.Generic.List[string]'

    for ($i = 0; $i -lt $startIndex; $i++) { $output.Add($lines[$i]) }
    foreach ($line in $blockLines) { $output.Add($line) }
    for ($i = $endIndex + 1; $i -lt $lines.Count; $i++) { $output.Add($lines[$i]) }

    Write-TextAtomic $AgentsFile (($output -join $newline) + $newline)
}

function Remove-ManagedBlock {
    Validate-MarkerState
    if (-not (Test-RegularFile $AgentsFile)) { return }

    $lines = @([System.IO.File]::ReadAllLines($AgentsFile))
    if (@($lines | Where-Object { $_ -ceq $StartMarker }).Count -ne 1) { return }

    $startIndex = [Array]::IndexOf($lines, $StartMarker)
    $endIndex = [Array]::IndexOf($lines, $EndMarker)
    $output = New-Object 'System.Collections.Generic.List[string]'
    for ($i = 0; $i -lt $startIndex; $i++) { $output.Add($lines[$i]) }
    for ($i = $endIndex + 1; $i -lt $lines.Count; $i++) { $output.Add($lines[$i]) }

    $remaining = $output -join [Environment]::NewLine
    if ($remaining -match '\S') {
        Write-TextAtomic $AgentsFile ($remaining + [Environment]::NewLine)
    }
    else {
        Remove-Item -LiteralPath $AgentsFile -Force
    }
}

function Copy-RegularFile([string]$Source, [string]$Destination) {
    Remove-PathSafely $Destination
    Copy-Item -LiteralPath $Source -Destination $Destination
}

function Remove-LegacyPayload {
    foreach ($file in $LegacyAgentFiles) {
        Remove-PathSafely (Join-Path $AgentDestDir $file)
    }
    foreach ($skill in $LegacySkillDirs) {
        Remove-PathSafely (Join-Path $SkillsDestRoot $skill)
    }
}

function Install-Payload {
    Require-SourceTree
    Validate-MarkerState
    New-Item -ItemType Directory -Path $AgentDestDir -Force | Out-Null
    New-Item -ItemType Directory -Path $SkillsDestRoot -Force | Out-Null

    Remove-LegacyPayload

    foreach ($file in $AgentFiles) {
        Copy-RegularFile (Join-Path (Join-Path $ScriptDir 'agents') $file) (Join-Path $AgentDestDir $file)
    }

    foreach ($skill in $SkillDirs) {
        $source = Join-Path (Join-Path $ScriptDir 'skills') $skill
        $destination = Join-Path $SkillsDestRoot $skill
        Remove-PathSafely $destination
        Copy-Item -LiteralPath $source -Destination $SkillsDestRoot -Recurse
    }

    Replace-OrAppendBlock
    Write-Utf8NoBom $VersionFile ($Version + [Environment]::NewLine)
}

function Test-FilesEqual([string]$Left, [string]$Right) {
    if (-not (Test-RegularFile $Left) -or -not (Test-RegularFile $Right)) { return $false }
    return (Get-FileHash -LiteralPath $Left -Algorithm SHA256).Hash -ceq (Get-FileHash -LiteralPath $Right -Algorithm SHA256).Hash
}

function Get-InstalledManagedBlockLines {
    if (-not (Test-RegularFile $AgentsFile)) { return @() }
    $lines = @([System.IO.File]::ReadAllLines($AgentsFile))
    $startIndex = [Array]::IndexOf($lines, $StartMarker)
    $endIndex = [Array]::IndexOf($lines, $EndMarker)
    if ($startIndex -lt 0 -or $endIndex -lt $startIndex) { return @() }
    return @($lines[$startIndex..$endIndex])
}

function Test-ManagedBlockMatches {
    $sourceLines = @([System.IO.File]::ReadAllLines($BlockFile))
    $installedLines = @(Get-InstalledManagedBlockLines)
    return (($sourceLines -join "`n") -ceq ($installedLines -join "`n"))
}

function Test-OutsideBlockContainsPantheon {
    if (-not (Test-RegularFile $AgentsFile)) { return $false }
    $lines = @([System.IO.File]::ReadAllLines($AgentsFile))
    $startIndex = [Array]::IndexOf($lines, $StartMarker)
    $endIndex = [Array]::IndexOf($lines, $EndMarker)
    $outside = New-Object 'System.Collections.Generic.List[string]'

    for ($i = 0; $i -lt $lines.Count; $i++) {
        if ($startIndex -ge 0 -and $i -ge $startIndex -and $i -le $endIndex) { continue }
        $outside.Add($lines[$i])
    }

    $text = $outside -join "`n"
    return [regex]::IsMatch($text, '(?i)codex\s+pantheon|\$pantheon|pantheon_(worker|explorer|librarian|oracle|fixer|designer|reviewer|verifier)|luna_(explorer|librarian|fixer)')
}

function Find-Codex {
    $commandInfo = Get-Command -Name @('codex.exe', 'codex.cmd', 'codex') -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($null -ne $commandInfo) {
        if (-not [string]::IsNullOrWhiteSpace($commandInfo.Source)) { return $commandInfo.Source }
        if ($commandInfo.PSObject.Properties.Name -contains 'Path' -and -not [string]::IsNullOrWhiteSpace($commandInfo.Path)) { return $commandInfo.Path }
    }

    if (-not [string]::IsNullOrWhiteSpace($env:LOCALAPPDATA)) {
        $candidates = @(
            (Join-Path $env:LOCALAPPDATA 'Programs\OpenAI\Codex\bin\codex.exe'),
            (Join-Path $env:LOCALAPPDATA 'OpenAI\Codex\bin\codex.exe'),
            (Join-Path $env:LOCALAPPDATA 'Packages\OpenAI.Codex_2p2nqsd0c76g0\LocalCache\Local\OpenAI\Codex\bin\codex.exe')
        )
        foreach ($candidate in $candidates) {
            if (Test-Path -LiteralPath $candidate -PathType Leaf) { return $candidate }
        }

        $runtimeRoots = @(
            (Join-Path $env:LOCALAPPDATA 'OpenAI\Codex\bin'),
            (Join-Path $env:LOCALAPPDATA 'Packages\OpenAI.Codex_2p2nqsd0c76g0\LocalCache\Local\OpenAI\Codex\bin')
        )
        foreach ($root in $runtimeRoots) {
            if (-not (Test-Path -LiteralPath $root -PathType Container)) { continue }
            $dirs = Get-ChildItem -LiteralPath $root -Directory -Force -ErrorAction SilentlyContinue | Sort-Object LastWriteTimeUtc -Descending
            foreach ($dir in $dirs) {
                $candidate = Join-Path $dir.FullName 'codex.exe'
                if (Test-Path -LiteralPath $candidate -PathType Leaf) { return $candidate }
            }
        }
    }

    return $null
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
        if (Test-RegularFile $VersionFile -or (Get-MarkerCount $StartMarker $AgentsFile) -gt 0) {
            $priorState = 'existing/partial installation'
        }
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
        try {
            $codexVersion = (& $codexBin --version 2>$null | Select-Object -First 1)
        }
        catch {
            $codexVersion = ''
        }
        $suffix = if ([string]::IsNullOrWhiteSpace([string]$codexVersion)) { '' } else { " ($codexVersion)" }
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
        if ($null -ne $item -and (Test-ReparsePointItem $item)) {
            [Console]::Error.WriteLine("✗ $file is a reparse point; Pantheon custom agents must be regular files")
            $errors++
        }
        elseif (-not (Test-RegularFile $destination)) {
            [Console]::Error.WriteLine("✗ $file is missing")
            $errors++
        }
        elseif (Test-FilesEqual $source $destination) {
            Ok $file
        }
        else {
            [Console]::Error.WriteLine("✗ $file differs from the v$Version source package")
            $errors++
        }
    }

    Say
    Say 'Legacy cleanup'
    $legacyErrors = 0
    foreach ($file in $LegacyAgentFiles) {
        $destination = Join-Path $AgentDestDir $file
        if ($null -ne (Get-PathItem $destination)) {
            [Console]::Error.WriteLine("✗ legacy Pantheon agent still installed: $file")
            $errors++
            $legacyErrors++
        }
    }
    foreach ($skill in $LegacySkillDirs) {
        $destination = Join-Path $SkillsDestRoot $skill
        if ($null -ne (Get-PathItem $destination)) {
            [Console]::Error.WriteLine("✗ legacy Pantheon skill still installed: $skill")
            $errors++
            $legacyErrors++
        }
    }
    if ($legacyErrors -eq 0) { Ok 'Legacy v0.4/v0.5 Pantheon payload absent' }

    Say
    Say 'Skills'
    foreach ($skill in $SkillDirs) {
        $source = Join-Path (Join-Path (Join-Path $ScriptDir 'skills') $skill) 'SKILL.md'
        $destination = Join-Path (Join-Path $SkillsDestRoot $skill) 'SKILL.md'
        $item = Get-PathItem $destination
        if ($null -ne $item -and (Test-ReparsePointItem $item)) {
            [Console]::Error.WriteLine("✗ $skill/SKILL.md is a reparse point")
            $errors++
        }
        elseif (-not (Test-RegularFile $destination)) {
            [Console]::Error.WriteLine("✗ $skill is missing")
            $errors++
        }
        elseif (Test-FilesEqual $source $destination) {
            Ok $skill
        }
        else {
            [Console]::Error.WriteLine("✗ $skill differs from the v$Version source package")
            $errors++
        }
    }

    Say
    Say 'Policy'
    $agentsItem = Get-PathItem $AgentsFile
    if ($null -eq $agentsItem -or $agentsItem.PSIsContainer) {
        [Console]::Error.WriteLine("✗ $AgentsFile is missing")
        $errors++
    }
    elseif (Test-ReparsePointItem $agentsItem) {
        [Console]::Error.WriteLine("✗ $AgentsFile is a reparse point; Pantheon refuses to manage it")
        $errors++
    }
    else {
        $starts = Get-MarkerCount $StartMarker $AgentsFile
        $ends = Get-MarkerCount $EndMarker $AgentsFile
        if ($starts -ne 1 -or $ends -ne 1) {
            [Console]::Error.WriteLine('✗ Managed Pantheon marker pair is missing, malformed, or duplicated')
            $errors++
        }
        else {
            $lines = @([System.IO.File]::ReadAllLines($AgentsFile))
            if ([Array]::IndexOf($lines, $EndMarker) -le [Array]::IndexOf($lines, $StartMarker)) {
                [Console]::Error.WriteLine('✗ Managed Pantheon marker order is malformed')
                $errors++
            }
            elseif (Test-ManagedBlockMatches) {
                Ok "Managed AGENTS.md block matches v$Version"
            }
            else {
                [Console]::Error.WriteLine("✗ Managed AGENTS.md block differs from v$Version")
                $errors++
            }

            if (Test-OutsideBlockContainsPantheon) {
                Warn 'Possible legacy/unmanaged Pantheon instructions exist outside the managed block; review them manually before deleting anything.'
                $warnings++
            }
        }
    }

    Say
    if ($errors -eq 0 -and $warnings -eq 0) {
        Say 'Status: HEALTHY'
        return
    }
    if ($errors -eq 0) {
        Say "Status: HEALTHY WITH WARNINGS ($warnings)"
        return
    }

    Say "Status: UNHEALTHY ($errors error(s), $warnings warning(s))"
    Say 'Repair Pantheon-owned files with: .\pantheon.ps1 update'
    exit 1
}

function Cmd-Uninstall {
    Validate-MarkerState

    foreach ($file in @($AgentFiles + $LegacyAgentFiles)) {
        Remove-PathSafely (Join-Path $AgentDestDir $file)
    }
    foreach ($skill in @($SkillDirs + $LegacySkillDirs)) {
        Remove-PathSafely (Join-Path $SkillsDestRoot $skill)
    }

    Remove-ManagedBlock
    Remove-PathSafely $VersionFile

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
    default {
        [Console]::Error.WriteLine((Get-UsageText))
        exit 2
    }
}
