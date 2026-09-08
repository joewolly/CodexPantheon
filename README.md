<p align="center">
  <img src="docs/codex-pantheon-banner.png" alt="Codex Pantheon" width="100%">
</p>

# Codex Pantheon

Codex Pantheon is a slim, explicit, Codex-native orchestration layer for an Astra-led Codex session.

**v0.6.0 ports the core Orchestrator → Explorer/Librarian/Fixer behavior of [oh-my-opencode-slim](https://github.com/alvinunreal/oh-my-opencode-slim) onto Codex-native agents, makes Luna lanes glanceable in Codex, and adds native Windows PowerShell lifecycle support while preserving Pantheon's thread-scoped on/off switch.** It does not embed or depend on the OpenCode plugin runtime.

> **Astra decides. Luna specialists execute their lane.**

**Astra = Orchestrator. Luna = Explorer + Librarian + Fixer.**

<p align="center">
  <img src="docs/pantheon.png" alt="Codex Pantheon v0.6 — Astra Orchestrator with Luna Explorer, Librarian, and Fixer" width="100%">
</p>

## Architecture

- **GPT-6 Astra — main thread / Orchestrator.** Understands the request, gathers evidence when needed, makes architecture and product decisions, creates the implementation specification, delegates, reconciles, reviews, verifies, and owns the final answer.
- **GPT-5.6 Luna High — `luna_explorer`.** Read-only repository reconnaissance. Finds files, symbols, execution paths, ownership, and code evidence. It does not design the solution.
- **GPT-5.6 Luna High — `luna_librarian`.** Read-only documentation/API/upstream/reference research. It does not design the solution.
- **GPT-5.6 Luna High — `luna_fixer`.** Write-enabled implementation specialist. Executes Astra's scoped implementation specification and assigned validation. It does not independently replan or redesign the mission.

The core dependency is:

```text
Explorer/Librarian evidence → Astra plan/specification → Fixer implementation → Astra review/verification
```

Astra may directly handle one isolated, clear, low-risk action when delegation would cost more than execution. It is **not** the default implementation worker for substantive work.

### Glanceable subagent titles

Pantheon requires Astra to encode the Luna lane into every child task name. The conceptual user-facing convention is:

```text
Luna Explorer · <specific assignment>
Luna Librarian · <specific assignment>
Luna Fixer · <specific assignment>
```

Codex's current native `task_name` field accepts lowercase letters, digits, and underscores, so Pantheon sends the enforceable equivalent:

```text
luna_explorer_trace_pve_guest_lifecycle
luna_librarian_research_pve_api_behavior
luna_fixer_repair_guest_creation_flow
```

This keeps the role visible on Codex surfaces that display or humanize the task name instead of forcing the user to infer the worker from a generic title such as `physics_evidence`. Multiple workers in the same lane must use distinct assignment suffixes. Astra remains the main thread and is never spawned merely to create an `Astra` child card.

## Operating profiles

| Profile | Activation | Behavior |
| --- | --- | --- |
| Ordinary Codex | default | Pantheon does nothing; normal Codex behavior |
| Pantheon Daily | `$pantheon-daily` | Same role ownership, conservative delegation, no parallel child calls |
| Full Pantheon | `$pantheon` | Same role ownership, more aggressive specialist use and justified parallelism |

Both Pantheon profiles are sticky only inside the current thread. Invoke the other profile to switch. Say `Stop using Pantheon.` to return to ordinary Codex. Nothing persists across threads.

### Pantheon Daily

Daily protects usage by changing **how readily Astra delegates**, not by changing who owns planning or implementation. There is no numeric worker-call ceiling.

Known implementation:

```text
Astra plan → Luna Fixer → Astra review
```

Unknown implementation:

```text
Luna Explorer and/or Librarian → Astra plan → Luna Fixer → Astra review
```

Daily never parallelizes children, but a necessary sequential research/exploration pass followed by Fixer is valid. It must not burn a single allowed call on reconnaissance and then make Astra implement the substantive change; the old v0.5 `0-1` rule is gone.

### Full Pantheon

Full Pantheon uses the same ownership boundaries with fewer delegation constraints. Astra may parallelize independent Explorer/Librarian lanes and may use multiple Fixers only when write ownership is clearly non-overlapping.

There is no `$pantheon-team`, no fast/normal/deep layer, and no Oracle/Designer/Reviewer/Verifier child roster.

## Request-scoped workflows

```text
$pantheon-plan Plan the migration without implementing it.
$pantheon-review Review this branch against main and give me a merge verdict.
```

`$pantheon-plan` keeps the plan with Astra and may use only read-only Explorer/Librarian evidence. Fixer is not used.

`$pantheon-review` keeps the review and verdict with Astra and may use only read-only Explorer/Librarian evidence. A review-only request does not use Fixer or modify production source.

These workflows do not activate a sticky Pantheon profile by themselves.

## Context discipline

Every Pantheon child spawn defaults to native `fork_turns: "none"` with a self-contained bounded assignment. Inherit only the minimum supported context required by a genuine dependency. Full-history inheritance is never the default.

Every assignment names the objective, scope, relevant constraints/context, permission boundary, expected evidence/output, stopping condition, and a prohibition on spawning subagents. Every spawn also carries the role-prefixed task name described above.

## Platform support

Pantheon keeps one shared payload under `agents/`, `skills/`, and `policy/` and exposes platform-native lifecycle frontends:

- **macOS/Linux:** Bash — `pantheon` and `install.sh`
- **Windows:** PowerShell — `pantheon.ps1` and `install.ps1`

Both frontends install the same Luna agents, the same four Pantheon skills, the same managed `AGENTS.md` block, and the same version marker. Windows support is native; WSL or Git Bash is not required for installation.

## Install with Codex

Open the Pantheon source directory in Codex and ask:

```text
Install Codex Pantheon for me.
```

The repository instructions direct Codex to run the platform-appropriate bootstrap command. Bootstrap installs/updates Pantheon-owned files and runs `doctor`. It does **not** activate Pantheon mode.

### macOS/Linux

```bash
./pantheon bootstrap
```

or:

```bash
./pantheon install
./pantheon doctor
```

The convenience installer is:

```bash
./install.sh
```

### Windows

From PowerShell:

```powershell
.\pantheon.ps1 bootstrap
```

or:

```powershell
.\pantheon.ps1 install
.\pantheon.ps1 doctor
```

The convenience installer is:

```powershell
.\install.ps1
```

On Windows, the default locations are `%USERPROFILE%\.codex` and `%USERPROFILE%\.agents\skills`. `CODEX_HOME` and `PANTHEON_SKILLS_HOME` override those defaults on every platform.

## Installed payload

Pantheon installs:

- `${CODEX_HOME:-~/.codex}/agents/luna-explorer.toml` (Windows equivalent: `%CODEX_HOME%\agents\luna-explorer.toml`)
- `${CODEX_HOME:-~/.codex}/agents/luna-librarian.toml`
- `${CODEX_HOME:-~/.codex}/agents/luna-fixer.toml`
- the `pantheon`, `pantheon-daily`, `pantheon-plan`, and `pantheon-review` skills
- one managed policy block in `AGENTS.md` under the Codex home
- `.pantheon-version` under the Codex home

Updating removes Pantheon's v0.5 `pantheon-worker.toml`, the older v0.4 specialist files, and the old `pantheon-team` skill. Unrelated Codex agents, skills, and text outside the managed markers remain user-owned.

## Doctor

macOS/Linux:

```bash
./pantheon doctor
```

Windows:

```powershell
.\pantheon.ps1 doctor
```

Doctor is read-only. It checks source/package integrity, all three named Luna agents, the four skills, legacy cleanup, managed policy drift, and Codex executable discovery. The Windows frontend checks PATH plus native Codex app/standalone locations under `%LOCALAPPDATA%`. Doctor does not prove live model/provider availability or a successful native child spawn.

## Uninstall

macOS/Linux:

```bash
./pantheon uninstall
```

Windows:

```powershell
.\pantheon.ps1 uninstall
```

Uninstall removes current and legacy Pantheon-owned paths while preserving unrelated Codex configuration.

## Documentation

- [User guide](docs/USER_GUIDE.md)
- [Codex-assisted install guide](docs/CODEX_INSTALL.md)
- [CLI reference](docs/CLI_REFERENCE.md)
- [Design doctrine](docs/DESIGN_DOCTRINE.md)
- [v0.6.0 release notes](docs/V0.6.0.md)
- [Third-party notices](THIRD_PARTY_NOTICES.md)
- [Changelog](CHANGELOG.md)

## What Pantheon intentionally does not do

Core Pantheon has no automatic prompt interception, proactive activation, recursive agent tree, custom orchestration runtime, persistent mission database, token/quota meter, scheduler, daemon, dashboard, or hidden cross-thread state.

> Enhance Codex. Don't replace it.

## License

Codex Pantheon is available under the [MIT License](LICENSE). Portions of the v0.6 role/routing semantics are adapted from the MIT-licensed `oh-my-opencode-slim`; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
