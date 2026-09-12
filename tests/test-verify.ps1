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
    TEMP = $env:TEMP
    TMP = $env:TMP
    PANTHEON_VERIFY_FAKE_MODE = $env:PANTHEON_VERIFY_FAKE_MODE
}

function Invoke-PantheonVerify([string]$Mode) {
    $env:PANTHEON_VERIFY_FAKE_MODE = $Mode
    $previousErrorActionPreference = $ErrorActionPreference
    try {
        $ErrorActionPreference = 'Continue'
        $output = @(& $PowerShellExe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $Pantheon verify 2>&1)
        $exitCode = $LASTEXITCODE
    }
    finally {
        $ErrorActionPreference = $previousErrorActionPreference
    }
    [PSCustomObject]@{
        ExitCode = $exitCode
        Text = (@($output | ForEach-Object { [string]$_ }) -join [Environment]::NewLine)
    }
}

try {
    $env:USERPROFILE = Join-Path $Temp 'home'
    $env:CODEX_HOME = Join-Path $Temp 'codex'
    $env:PANTHEON_SKILLS_HOME = Join-Path $Temp 'skills'
    $RuntimeTemp = Join-Path $Temp 'runtime-tmp'
    $env:TEMP = $RuntimeTemp
    $env:TMP = $RuntimeTemp
    $FakeBin = Join-Path $Temp 'bin'
    New-Item -ItemType Directory -Path $env:USERPROFILE, $env:CODEX_HOME, $env:PANTHEON_SKILLS_HOME, $RuntimeTemp, $FakeBin -Force | Out-Null

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

        var mode = Environment.GetEnvironmentVariable("PANTHEON_VERIFY_FAKE_MODE") ?? "success";
        var joined = string.Join("\n", args);
        var nonceMatch = Regex.Match(joined, @"Pantheon verify nonce:\s*([^\.\s]+)");
        var secretMatch = Regex.Match(joined, @"Parent-only secret:\s*(\S+)");
        if (!nonceMatch.Success)
        {
            Console.Error.WriteLine("fake codex could not find verify nonce");
            return 2;
        }

        string lastMessage = null;
        for (var i = 0; i + 1 < args.Length; i++)
        {
            if (args[i] == "--output-last-message")
            {
                lastMessage = args[i + 1];
                break;
            }
        }
        if (String.IsNullOrWhiteSpace(lastMessage))
        {
            Console.Error.WriteLine("fake codex missing --output-last-message");
            return 2;
        }

        var nonce = nonceMatch.Groups[1].Value;
        var secret = secretMatch.Success ? secretMatch.Groups[1].Value : "";
        var parentId = "parent-" + nonce;
        var childId = "child-" + nonce;
        var callId = "call-" + nonce;
        var waitCallId = "wait-" + nonce;
        var codexHome = Environment.GetEnvironmentVariable("CODEX_HOME");
        var sessionDir = Path.Combine(codexHome, "sessions", "fake");
        Directory.CreateDirectory(sessionDir);
        var parentFile = Path.Combine(sessionDir, "rollout-" + parentId + ".jsonl");
        var childFile = Path.Combine(sessionDir, "rollout-" + childId + ".jsonl");

        Console.Error.WriteLine("fake codex harmless diagnostic on stderr");
        Console.WriteLine("{\"type\":\"thread.started\",\"thread_id\":\"" + parentId + "\"}");
        Console.WriteLine("{\"type\":\"turn.started\"}");

        using (var parent = new StreamWriter(parentFile, false))
        {
            parent.WriteLine("{\"type\":\"session_meta\",\"payload\":{\"id\":\"" + parentId + "\",\"source\":\"cli\"}}");
            parent.WriteLine("{\"type\":\"event_msg\",\"payload\":{\"type\":\"user_message\",\"message\":\"spawn_agent luna_explorer explorer_pantheon_verify fork_turns none PANTHEON_VERIFY_OK_" + nonce + "\"}}");

            if (mode != "prompt-only")
            {
                var arguments = "{\\\"message\\\":\\\"Pantheon verify nonce: " + nonce + ". Return evidence.\\\",\\\"agent_type\\\":\\\"luna_explorer\\\",\\\"fork_turns\\\":\\\"none\\\",\\\"task_name\\\":\\\"explorer_pantheon_verify\\\"}";
                parent.WriteLine("{\"type\":\"response_item\",\"payload\":{\"type\":\"function_call\",\"name\":\"spawn_agent\",\"arguments\":\"" + arguments + "\",\"call_id\":\"" + callId + "\"}}");
                if (mode != "missing-output")
                {
                    parent.WriteLine("{\"type\":\"response_item\",\"payload\":{\"type\":\"function_call_output\",\"call_id\":\"" + callId + "\",\"output\":\"{\\\"task_name\\\":\\\"/root/explorer_pantheon_verify\\\"}\"}}");
                }
            }

            if (mode == "multiple-spawn")
            {
                var arguments = "{\\\"message\\\":\\\"Pantheon verify nonce: " + nonce + ". Duplicate.\\\",\\\"agent_type\\\":\\\"luna_explorer\\\",\\\"fork_turns\\\":\\\"none\\\",\\\"task_name\\\":\\\"explorer_pantheon_verify\\\"}";
                parent.WriteLine("{\"type\":\"response_item\",\"payload\":{\"type\":\"function_call\",\"name\":\"spawn_agent\",\"arguments\":\"" + arguments + "\",\"call_id\":\"duplicate-" + nonce + "\"}}");
            }
            if (mode == "extra-spawn")
            {
                var arguments = "{\\\"message\\\":\\\"Unrelated extra child.\\\",\\\"agent_type\\\":\\\"luna_explorer\\\",\\\"fork_turns\\\":\\\"none\\\",\\\"task_name\\\":\\\"explorer_unrelated_extra\\\"}";
                parent.WriteLine("{\"type\":\"response_item\",\"payload\":{\"type\":\"function_call\",\"name\":\"spawn_agent\",\"arguments\":\"" + arguments + "\",\"call_id\":\"extra-" + nonce + "\"}}");
            }

            if (mode != "missing-wait")
            {
                parent.WriteLine("{\"type\":\"response_item\",\"payload\":{\"type\":\"function_call\",\"name\":\"wait_agent\",\"arguments\":\"{\\\"timeout_ms\\\":120000}\",\"call_id\":\"" + waitCallId + "\"}}");
                var timedOut = mode == "timed-out-wait" ? "true" : "false";
                var waitMessage = mode == "timed-out-wait" ? "Timed out waiting for agent updates." : "Mailbox update received.";
                parent.WriteLine("{\"type\":\"response_item\",\"payload\":{\"type\":\"function_call_output\",\"call_id\":\"" + waitCallId + "\",\"output\":\"{\\\"message\\\":\\\"" + waitMessage + "\\\",\\\"timed_out\\\":" + timedOut + "}\"}}");
            }
        }

        if (mode == "ambiguous-parent")
        {
            File.Copy(parentFile, Path.Combine(sessionDir, "duplicate-" + parentId + ".jsonl"), true);
        }

        if (mode != "no-child")
        {
            using (var child = new StreamWriter(childFile, false))
            {
                child.WriteLine("{\"type\":\"session_meta\",\"payload\":{\"id\":\"" + childId + "\",\"source\":{\"subagent\":{\"thread_spawn\":{\"parent_thread_id\":\"" + parentId + "\",\"depth\":1,\"agent_path\":\"/root/explorer_pantheon_verify\",\"agent_role\":\"luna_explorer\"}}}}}");
                var effort = mode == "wrong-effort" ? "medium" : "high";
                child.WriteLine("{\"type\":\"turn_context\",\"payload\":{\"model\":\"gpt-5.6-luna\",\"effort\":\"" + effort + "\"}}");
                child.WriteLine("{\"type\":\"response_item\",\"payload\":{\"type\":\"message\",\"role\":\"assistant\",\"content\":[{\"type\":\"input_text\",\"text\":\"PANTHEON_CHILD_OK_" + nonce + "_NO_PARENT_SECRET\"}]}}");
                if (mode == "secret-leak")
                {
                    child.WriteLine("{\"type\":\"event_msg\",\"payload\":{\"type\":\"debug\",\"message\":\"" + secret + "\"}}");
                }
                var childReply = mode == "child-prompt-only"
                    ? "PANTHEON_CHILD_FAIL_" + nonce + "_PARENT_SECRET_SEEN"
                    : "PANTHEON_CHILD_OK_" + nonce + "_NO_PARENT_SECRET";
                child.WriteLine("{\"type\":\"response_item\",\"payload\":{\"type\":\"message\",\"role\":\"assistant\",\"content\":[{\"type\":\"output_text\",\"text\":\"" + childReply + "\"}]}}");
                if (mode != "missing-task-complete")
                {
                    child.WriteLine("{\"type\":\"event_msg\",\"payload\":{\"type\":\"task_complete\",\"last_agent_message\":\"" + childReply + "\"}}");
                }
            }
            if (mode == "old-child-mtime")
            {
                File.SetLastWriteTimeUtc(childFile, new DateTime(2000, 1, 1, 0, 0, 0, DateTimeKind.Utc));
            }
        }

        var parentReply = mode == "misleading-parent"
            ? "Expected PANTHEON_VERIFY_OK_" + nonce + ", but child failed"
            : "PANTHEON_VERIFY_OK_" + nonce;
        File.WriteAllText(lastMessage, parentReply + Environment.NewLine);
        Console.WriteLine("{\"type\":\"item.completed\",\"item\":{\"id\":\"item_1\",\"type\":\"agent_message\",\"text\":\"" + parentReply + "\"}}");
        Console.WriteLine("{\"type\":\"turn.completed\",\"usage\":{\"input_tokens\":1,\"cached_input_tokens\":0,\"output_tokens\":1}}");
        return 0;
    }
}
'@
    Add-Type -TypeDefinition $Source -Language CSharp -OutputAssembly $FakeExe -OutputType ConsoleApplication
    $env:PATH = $FakeBin + [System.IO.Path]::PathSeparator + $Original.PATH

    & $PowerShellExe -NoLogo -NoProfile -ExecutionPolicy Bypass -File $Pantheon install *> $null
    if ($LASTEXITCODE -ne 0) { throw 'Pantheon install failed in verify test.' }

    $success = Invoke-PantheonVerify 'success'
    if ($success.ExitCode -ne 0) { throw "Pantheon verify failed on success case:`n$($success.Text)" }
    foreach ($expected in @(
        'V2 spawn used luna_explorer, fork_turns none, and explorer_pantheon_verify',
        'Parent waited for a non-timeout V2 child mailbox update',
        'Configured Explorer resolved to GPT-5.6 Luna High and completed normally',
        'fork_turns none kept the parent-only secret out of the child context',
        'Parent received and reconciled the terminal child result',
        'Status: VERIFIED'
    )) {
        if (-not $success.Text.Contains($expected)) { throw "Missing verify output: $expected`n$($success.Text)" }
    }

    $oldMtime = Invoke-PantheonVerify 'old-child-mtime'
    if ($oldMtime.ExitCode -ne 0 -or -not $oldMtime.Text.Contains('Status: VERIFIED')) { throw "Pantheon verify failed with an old child mtime:`n$($oldMtime.Text)" }

    foreach ($mode in @('misleading-parent', 'prompt-only', 'missing-output', 'multiple-spawn', 'extra-spawn', 'ambiguous-parent', 'missing-wait', 'timed-out-wait', 'child-prompt-only', 'missing-task-complete', 'wrong-effort', 'secret-leak', 'no-child')) {
        $result = Invoke-PantheonVerify $mode
        if ($result.ExitCode -eq 0) { throw "Pantheon verify unexpectedly passed in mode '$mode':`n$($result.Text)" }
    }

    $leakedVerifyTemp = @(Get-ChildItem -LiteralPath $RuntimeTemp -Directory -Filter 'pantheon-verify-*' -ErrorAction SilentlyContinue)
    if ($leakedVerifyTemp.Count -ne 0) {
        throw "Pantheon verify leaked temporary directories after a failure: $($leakedVerifyTemp.FullName -join ', ')"
    }

    $global:LASTEXITCODE = 0
    Write-Output 'ok - pantheon verify proves spawn/wait/terminal-child flow, cleans state, and tolerates harmless native stderr'
}
finally {
    $env:CODEX_HOME = $Original.CODEX_HOME
    $env:PANTHEON_SKILLS_HOME = $Original.PANTHEON_SKILLS_HOME
    $env:USERPROFILE = $Original.USERPROFILE
    $env:PATH = $Original.PATH
    $env:TEMP = $Original.TEMP
    $env:TMP = $Original.TMP
    $env:PANTHEON_VERIFY_FAKE_MODE = $Original.PANTHEON_VERIFY_FAKE_MODE
    if (Test-Path -LiteralPath $Temp) { Remove-Item -LiteralPath $Temp -Recurse -Force -ErrorAction SilentlyContinue }
}
