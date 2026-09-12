<p align="center">
  <img src="docs/codex-pantheon-banner.png" alt="Codex Pantheon — Astra or Sol, with three Luna specialists" width="100%">
</p>

# Codex Pantheon

Codex Pantheon is a slim, explicit, Codex-native orchestration layer for a supported main-thread Orchestrator.

**v0.7.0 makes the Orchestrator interchangeable between GPT-6 Astra and GPT-5.6 Sol, removes model-specific prompt coupling, and further compresses parent/child context while preserving the Explorer/Librarian/Fixer ownership model. Current `main` additionally hardens dependency reconciliation, Fixer completion evidence, and opt-in live runtime verification.**

> **Orchestrator decides. Luna specialists execute their lane.**

**Astra or Sol = Orchestrator. Luna = Explorer + Librarian + Fixer.**

<p align="center">
  <img src="docs/pantheon.png" alt="Codex Pantheon v0.7.0: choose Astra or Sol as one main-thread Orchestrator. Luna Explorer and Librarian gather read-only evidence; Luna Fixer implements the specification. The Orchestrator reviews and verifies." width="100%">
</p>

[View the detailed architecture diagram](docs/assets/codex-pantheon-v0.7-architecture.svg) · [Graphics and generation brief](docs/assets/GRAPHICS.md)

## Architecture

- **GPT-6 Astra or GPT-5.6 Sol — main thread / Orchestrator.** Understands the request, gathers evidence when needed, makes architecture/product decisions, creates the implementation specification, schedules/delegates work, reconciles results, reviews, verifies, and owns the final answer. It never implements repository changes.
- **GPT-5.6 Luna High — `luna_explorer`.** Read-only repository reconnaissance. Finds files, symbols, execution paths, ownership, and code evidence. It does not design the solution.
- **GPT-5.6 Luna High — `luna_librarian`.** Read-only documentation/API/upstream/reference research. It does not design the solution.
- **GPT-5.6 Luna High — `luna_fixer`.** Write-enabled implementation specialist. Executes the Orchestrator's scoped specification and assigned validation. It does not independently replan or redesign the mission. Every return includes a structured implementation receipt with status, files/changes, validation evidence, deviations/blockers, and explicit parent-verification obligations.

The default dependency is:

```text
Explorer/Librarian evidence when needed → Orchestrator plan/specification → Fixer implementation → Orchestrator review/verification
```

Every required child result is a **hard dependency barrier** for the work that depends on it. The Orchestrator does not proceed with or finalize a dependent plan, specification, implementation assignment, review conclusion, or final verdict until the required result has returned and been reconciled.

Every implementation edit goes through Luna Fixer, even a tiny or obvious change. If Fixer cannot be spawned or complete the assignment, the Orchestrator rescopes, retries, redelegates, or reports the blocker; it never takes over implementation.

## Selecting Astra or Sol

Pantheon deliberately does not maintain a second model selector.

1. Select **GPT-6 Astra** or **GPT-5.6 Sol** with Codex's native main-thread model control.
2. Invoke `$pantheon` or `$pantheon-daily`.
3. The selected supported main-thread model follows the same Pantheon Orchestrator contract.

Pantheon does not switch the active main model, write a duplicate model preference, or spawn an Astra/Sol child. This keeps Codex as the source of truth, avoids an extra model hop, eliminates selector drift, and means switching between Astra and Sol never requires reinstalling Pantheon.

## V2-only agent control

Pantheon requires the selected Orchestrator/runtime to expose native **MultiAgent V2**. Legacy multi-agent surfaces are not Pantheon compatibility paths.

Every Pantheon worker is created through native V2 `spawn_agent` with:

- `agent_type` explicitly set to `luna_explorer`, `luna_librarian`, or `luna_fixer`;
- `fork_turns: "none"`;
- only the concise `task_name` required as routing/path metadata.

Pantheon formats that V2 `task_name` as `<role>_<concise_task_slug>` so the current Codex Subagents UI exposes the worker lane at a glance. Examples: `fixer_v020_implement`, `explorer_v020_versions`, and `librarian_v020_release_map`.

The configured role pins the actual worker to **GPT-5.6 Luna High**. `agent_type` remains authoritative; the `explorer` / `librarian` / `fixer` task-name prefix is display/path metadata only and never selects or impersonates a role or model.

After spawn, the Orchestrator keeps coordination on the native V2 agent plane:

- `send_message` passes information to a running worker;
- `followup_task` assigns another task/turn to an existing worker.

Pantheon never falls back to generic task/thread delegation such as `send_message_to_thread`, `create_thread`, `fork_thread`, direct task turn/resume calls, or legacy/non-V2 agent tools to steer a child. If V2 configured-role selection or V2 communication cannot be honored, Pantheon reports the runtime limitation instead of switching control paths or silently respawning work.

Parent-mediated steering is the supported coordination model. A separate composer on a child card is optional Codex UI behavior and is not required by Pantheon.

## Context discipline

Every Pantheon worker is explicitly selected as a Luna role through V2 `spawn_agent`. Child spawns use `fork_turns: "none"`; full-history inheritance is never the default.

Every child receives a minimum self-contained bounded assignment containing the objective, scope, known constraints/facts, permission boundary, expected evidence/output, stopping condition, and a prohibition on spawning subagents.

## Operating profiles

| Profile | Activation | Behavior |
| --- | --- | --- |
| Ordinary Codex | default | Pantheon does nothing; normal Codex behavior |
| Pantheon Daily | `$pantheon-daily` | Same role ownership, conservative delegation, no parallel child calls |
| Full Pantheon | `$pantheon` | Same role ownership, more aggressive specialist use and dependency-safe parallelism |

Both Pantheon profiles are sticky only inside the current thread. Invoke the other profile to switch. Say `Stop using Pantheon.` to return to ordinary Codex. Nothing persists across threads.

### Pantheon Daily

Daily protects usage by changing how often optional evidence specialists are used, never who owns implementation. There is no numeric worker-call ceiling.

Known implementation:

```text
Orchestrator plan → Luna Fixer → Orchestrator review
```

Unknown implementation:

```text
Luna Explorer and/or Librarian → Orchestrator plan → Luna Fixer → Orchestrator review
```

Daily never parallelizes children. Required results are consumed sequentially before the dependent stage begins. Luna Fixer remains mandatory for implementation.

### Full Pantheon

Full Pantheon uses the same ownership boundaries with fewer delegation constraints. It may overlap Explorer, Librarian, and Fixer work **across genuinely independent work items** when no unfinished evidence can change an already-issued Fixer specification. Multiple Fixers may run in parallel only with explicit non-overlapping write ownership.

This is not speculative execution across unresolved dependencies: if a Fixer specification depends on an Explorer/Librarian result, that result must return and be reconciled first.

There is no `$pantheon-team`, no fast/normal/deep layer, and no Oracle/Designer/Reviewer/Verifier child roster.

## Fixer implementation receipts

A Fixer completion claim is not enough by itself. Each `luna_fixer` return is required to provide:

- **Status:** `completed`, `partial`, or `blocked`;
- **Summary:** concise implementation result;
- **Files/changes:** every touched file and material change;
- **Validation:** each check with `PASS`, `FAIL`, `SKIPPED`, or `UNKNOWN` and concise evidence;
- **Deviations/blockers:** divergence from the specification, unresolved ambiguity, or `none`;
- **Parent verification:** what the Orchestrator must independently inspect or verify.

The Orchestrator reconciles that receipt against actual repository state before final review or user-facing completion.

## Request-scoped workflows

```text
$pantheon-plan Plan the migration without implementing it.
$pantheon-review Review this branch against main and give me a merge verdict.
```

`$pantheon-plan` keeps the plan with the main-thread Orchestrator and may use only read-only Explorer/Librarian evidence. Fixer is not used. Required evidence remains a hard barrier for the dependent portion of the plan.

`$pantheon-review` keeps the review and verdict with the main-thread Orchestrator and may use only read-only Explorer/Librarian evidence. A review-only request does not use Fixer or modify production source. Required evidence must be reconciled before the dependent finding or verdict is finalized.

These workflows do not activate a sticky Pantheon profile by themselves.

## Platform support

Pantheon keeps one shared payload under `agents/`, `skills/`, and `policy/` and exposes platform-native lifecycle frontends:

- **macOS/Linux:** Bash — `pantheon` and `install.sh`
- **Windows:** PowerShell — `pantheon.ps1` and `install.ps1`

Both frontends install the same Luna agents, four Pantheon skills, managed `AGENTS.md` block, and version marker.

## Install with Codex

Open the Pantheon source directory in Codex and ask:

```text
Install Codex Pantheon for me.
```

Bootstrap installs/updates Pantheon-owned files and runs `doctor`. It does **not** activate Pantheon mode.

### macOS/Linux

```bash
./pantheon bootstrap
```

### Windows

```powershell
.\pantheon.ps1 bootstrap
```

`CODEX_HOME` and `PANTHEON_SKILLS_HOME` override the default Codex/skill homes on every platform.

## Installed payload

Pantheon installs:

- `<Codex home>/agents/luna-explorer.toml`
- `<Codex home>/agents/luna-librarian.toml`
- `<Codex home>/agents/luna-fixer.toml`
- the `pantheon`, `pantheon-daily`, `pantheon-plan`, and `pantheon-review` skills
- one managed policy block in `<Codex home>/AGENTS.md`
- `<Codex home>/.pantheon-version`

Updating continues to remove Pantheon's v0.5 `pantheon-worker.toml`, older v0.4 specialist files, and old `pantheon-team` skill while preserving unrelated Codex state.

## Doctor

macOS/Linux:

```bash
./pantheon doctor
```

Windows:

```powershell
.\pantheon.ps1 doctor
```

Doctor is read-only. It checks package/install integrity and Codex executable discovery. It does not prove live model/provider availability or a successful native V2 child spawn/communication round trip.

## Live verification

Use `verify` when you explicitly want to exercise the installed Codex runtime:

```bash
./pantheon verify
```

```powershell
.\pantheon.ps1 verify
```

`verify` consumes one real parent turn plus one Luna Explorer child turn. It fails closed unless it can prove an exact parent success reply, one actual/correlated V2 `spawn_agent` call, matching child provenance, effective **GPT-5.6 Luna High** execution, the expected child reply, and `fork_turns: "none"` isolation of a parent-only sentinel.

The check does not run automatically from install/update/bootstrap/doctor. Temporary verifier artifacts are cleaned on success and failure. Because this is a real Codex turn, normal parent/child session rollouts are created in the user's Codex session store and remain subject to normal Codex retention behavior.

See [CLI reference](docs/CLI_REFERENCE.md) for the exact evidence contract.

## Uninstall

```bash
./pantheon uninstall
```

or on Windows:

```powershell
.\pantheon.ps1 uninstall
```

Uninstall removes Pantheon-owned current and legacy paths while preserving unrelated Codex configuration.

## Documentation

- [User guide](docs/USER_GUIDE.md)
- [Codex-assisted install guide](docs/CODEX_INSTALL.md)
- [CLI reference](docs/CLI_REFERENCE.md)
- [Design doctrine](docs/DESIGN_DOCTRINE.md)
- [v0.7.0 release notes](docs/V0.7.0.md)
- [Third-party notices](THIRD_PARTY_NOTICES.md)
- [Changelog](CHANGELOG.md)

## What Pantheon intentionally does not do

Core Pantheon has no automatic prompt interception, proactive activation, recursive agent tree, custom orchestration/model-routing runtime, persistent mission database, token/quota meter, scheduler, daemon, dashboard, or hidden cross-thread state.

> Enhance Codex. Don't replace it.

## License

Codex Pantheon is available under the [MIT License](LICENSE). Portions of the role/routing semantics are adapted from the MIT-licensed `oh-my-opencode-slim`; see [THIRD_PARTY_NOTICES.md](THIRD_PARTY_NOTICES.md).
