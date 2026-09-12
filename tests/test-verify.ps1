Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Root = Split-Path -Parent (Split-Path -Parent $MyInvocation.MyCommand.Path)
$Pantheon = Join-Path $Root 'pantheon.ps1'
$PowerShellExe = (Get-Process -Id $PID).Path
$Temp = Join-Path ([System.IO.Path]::GetTempPath()) ('pantheon-verify-' + [Guid]::NewGuid().ToString('N'))
$Original = @{
    CODEX_HOME = $env:CODEX_HOME
    PANTHEON_SKILLS_HOME = $env:PANTHEON_SKILLS_HOME
    USERPROFILE = $env:USERPROFILE
    PATH = $env:PATH
}

try {
    $env:USERPROFILE = Join-Path $Temp 'home'
    $env:CODEX_HOME = Join-Path $Temp 'codex'
    $env:PANTHEON_SKILLS_HOME = Join-Path $Temp 'skills'
    $FakeBin = Join-Path $Temp 'bin'
    New-Item -ItemType Directory -Path $env:USERPROFILE, $env:CODEX_HOME, $env:PANTHEON_SKILLS_HOME, $FakeBin -Force | Out-Null

    $FakeExe = Join-Path $FakeBin 'codex.exe'
    $Source = @'
using System;
using System.IO;
using System.Text.RegularExpressions;

public static class Program
{
    public static int Main(string[] args)
    {
        if (args.Length == 1 && args[0] == "--version")
        {
            Console.WriteLine("codex-cli pantheon-verify-test");
            return 0;
        }

        var joined = string.Join("\n", args);
        var match = Regex.Match(joined, @"Pantheon verify nonce:\s*([^\.\s]+)");
        if (!match.Success)
        {
            Console.Error.WriteLine("fake codex could not find verify nonce");
            return 2;
        }

        var nonce = match.Groups[1].Value;
        var codexHome = Environment.GetEnvironmentVariable("CODEX_HOME");
        var sessionDir = Path.Combine(codexHome, "sessions", "fake");
        Directory.CreateDirectory(sessionDir);

        File.WriteAllText(
            Path.Combine(sessionDir, "parent.jsonl"),
            "{\"nonce\":\"" + nonce + "\",\"tool\":\"spawn_agent\",\"agent_type\":\"luna_explorer\",\"task_name\":\"explorer_pantheon_verify\",\"fork_turns\":\"none\"}\n"
        );
        File.WriteAllText(
            Path.Combine(sessionDir, "child.jsonl"),
            "{\"nonce\":\"" + nonce + "\",\"type\":\"subagent.thread_spawn\",\"agent_path\":\"luna-explorer.toml\",\"model\":\"gpt-5.6-luna\",\"message\":\"PANTHEON_CHILD_OK_" + nonce + "_NO_PARENT_SECRET\"}\n"
        );
        Console.WriteLine("{\"type\":\"item.completed\",\"text\":\"PANTHEON_VERIFY_OK_" + nonce + "\"}");
        return 0;
    }
}
'@
    Add-Type -TypeDefinition $Source -Language CSharp -OutputAssembly $FakeExe -OutputType ConsoleApplication
    $env:PATH = $FakeBin + [System.IO.Path]::PathSeparator + $Original.PATH

    & $PowerShellExe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $Pantheon install *> $null
    if ($LASTEXITCODE -ne 0) { throw 'Pantheon install failed in verify test.' }

    $Output = @(& $PowerShellExe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $Pantheon verify 2>&1)
    $ExitCode = $LASTEXITCODE
    $Text = (@($Output | ForEach-Object { [string]$_ }) -join [Environment]::NewLine)
    if ($ExitCode -ne 0) { throw "Pantheon verify failed:`n$Text" }

    foreach ($Expected in @(
        'Parent received and reconciled the child result',
        'V2 spawn used luna_explorer, fork_turns none, and explorer_pantheon_verify',
        'Configured Explorer resolved to GPT-5.6 Luna',
        'fork_turns none kept the parent-only secret out of the child context',
        'Status: VERIFIED'
    )) {
        if (-not $Text.Contains($Expected)) { throw "Missing verify output: $Expected`n$Text" }
    }

    Write-Output 'ok - pantheon verify proves the live V2 routing/isolation round-trip contract on Windows'
}
finally {
    $env:CODEX_HOME = $Original.CODEX_HOME
    $env:PANTHEON_SKILLS_HOME = $Original.PANTHEON_SKILLS_HOME
    $env:USERPROFILE = $Original.USERPROFILE
    $env:PATH = $Original.PATH
    if (Test-Path -LiteralPath $Temp) { Remove-Item -LiteralPath $Temp -Recurse -Force -ErrorAction SilentlyContinue }
}
