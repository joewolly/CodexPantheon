# Changelog

## Unreleased

### Changed

- The Astra/Sol Orchestrator contract now follows the `oh-my-opencode-slim` workflow-manager shape more closely: understand, build a dependency-aware work graph, delegate, reconcile, and verify.
- The Orchestrator is now implementation-free. Every repository implementation edit routes to `luna_fixer`, including tiny, obvious, or low-risk changes; there is no delegation-overhead escape hatch.
- Full and Daily share the same hard implementation ownership. If Fixer cannot be spawned or complete an assignment, the Orchestrator must rescope, retry, redelegate, or report the blocker rather than taking over the edit.
- User-facing doctrine and upstream attribution now document the stricter Pantheon divergence from `oh-my-opencode-slim`.

## 0.7.0 — 2026-09-09

### Added

- GPT-5.6 Sol as a supported main-thread Pantheon Orchestrator alongside GPT-6 Astra.
- v0.7 architecture/release documentation and a sharp SVG diagram showing the interchangeable Astra/Sol Orchestrator above the three Luna specialist lanes.
- Regression coverage for the model-neutral Orchestrator contract and minimum-context child assignments.

### Changed

- Pantheon now defines one shared **Orchestrator** role contract instead of coupling ownership semantics to Astra-specific wording.
- Main-thread model selection remains native Codex state. Pantheon does not spawn a second Orchestrator, write a duplicate model preference, or pretend `$pantheon` changed the active model.
- Explorer, Librarian, and Fixer prompts now report to the Orchestrator role and are compressed around bounded work, minimum sufficient evidence, and explicit stopping conditions.
- Full, Daily, Plan, Review, managed-policy, repository-policy, user-guide, install, contribution, and release contracts are synchronized around Astra/Sol interchangeability.
- `fork_turns: "none"` remains the default child context policy and the contract now more explicitly requires minimum self-contained context.
- README architecture rendering now uses the versioned SVG asset rather than a raster architecture image.

### Unchanged by design

- `luna_explorer`, `luna_librarian`, and `luna_fixer` remain GPT-5.6 Luna High.
- Daily and Full remain the only sticky delegation-intensity profiles.
- Explorer/Librarian remain read-only; Fixer remains bounded workspace-write implementation.
- Existing v0.4/v0.5 migration cleanup, safe lifecycle behavior, and native Windows support remain intact.

### Not included

- No `$pantheon-astra` / `$pantheon-sol` duplicate skills.
- No Pantheon-owned model picker, persistent model state, model-router runtime, second Orchestrator child, token meter, daemon, scheduler, or worker-effort retuning.

## 0.6.0 — 2026-09-05

### Added

- Three named GPT-5.6 Luna High agents so running lanes are distinguishable in Codex: `luna_explorer`, `luna_librarian`, and `luna_fixer`.
- Hard role boundaries adapted from the MIT-licensed `oh-my-opencode-slim` Orchestrator/Explorer/Librarian/Fixer model.
- `THIRD_PARTY_NOTICES.md` with upstream attribution and license text.
- Regression assertions for the complete evidence → Astra plan/specification → Fixer implementation → Astra review/verification dependency.
- Role-prefixed Luna child task names so Explorer, Librarian, and Fixer work is glanceable in Codex task surfaces.
- Native Windows PowerShell lifecycle support through `pantheon.ps1` and `install.ps1`, using the same agents, skills, policy block, and version marker as the macOS/Linux Bash frontend.
- Windows lifecycle regression coverage for install, update, doctor, bootstrap, migration cleanup, user-owned configuration preservation, malformed-marker fail-closed behavior, uninstall, and `%USERPROFILE%` defaults.
- GitHub Actions coverage for both Linux/Bash and Windows/PowerShell lifecycle suites.

### Changed

- GPT-6 Astra is now explicitly prompted as an OMO-style workflow manager: understand, plan, schedule, delegate, reconcile, review, and verify; Astra is not the default implementation worker.
- Explorer and Librarian are hard read-only evidence roles and cannot create the solution/implementation plan.
- Fixer is the write-enabled implementation role and executes Astra's scoped specification rather than independently replanning or conducting broad research.
- `$pantheon-daily` keeps the same ownership model as full Pantheon, removes the v0.5 `0-1` worker-call ceiling, forbids parallel child calls, and allows sequential research/exploration followed by Fixer when required.
- Full `$pantheon` may parallelize genuinely independent read-only lanes and non-overlapping Fixer workstreams.
- Install/update/bootstrap migrate v0.5 `pantheon-worker.toml` to the three named Luna agent files while preserving v0.4 cleanup behavior.
- Repository lifecycle instructions and user documentation now route install/update/doctor/uninstall commands by platform.
- Windows Doctor discovers Codex from PATH and current native standalone/Desktop runtime layouts under `%LOCALAPPDATA%`.
- Windows protected-path checks treat NTFS reparse points as the analogue of the Bash symlink safeguard.
- Windows lifecycle support is compatible with Windows PowerShell 5.1 as well as newer PowerShell runtimes.

### Removed

- The generic `pantheon_worker` role and the preferred one-call explore → implement pattern that blurred planning versus execution ownership.

### Not included

- The OpenCode/Bun plugin runtime, TUI, background-job board, scheduler, or other OpenCode-specific machinery from `oh-my-opencode-slim`.
- No Oracle, Designer, Reviewer, Verifier, Council, separate team mode, automatic activation, persistent state, quota meter, daemon, or custom orchestration runtime.

## 0.5.0 — 2026-09-05

### Added

- `pantheon_worker`, a single GPT-5.6 Luna High child role for bounded repository exploration, reference research, implementation, fixes, and focused validation/evidence.
- v0.5 migration checks that require the old v0.4 specialist/team payload to be absent from a healthy installation.

### Changed

- Pantheon now uses a two-role architecture: GPT-6 Astra remains the main-thread orchestrator and Luna is the only Pantheon child.
- `$pantheon-daily` is now the conservative default philosophy: normally 0-1 Luna calls per user request, no parallel workers, and a second sequential call only for a concrete unresolved blocker/evidence gap.
- Full `$pantheon` owns higher-intensity delegation and may use multiple or parallel Luna workers only for material, genuinely independent work.
- Planning, architecture, prioritization, integration, review, final verification judgment, and merge/release verdicts stay with the parent/Astra thread.
- `$pantheon-plan` uses Luna only as optional read-only research support; `$pantheon-review` uses Luna only as optional evidence support while Astra owns the review verdict.
- Install/update/bootstrap automatically remove Pantheon's seven v0.4 agent files and the old `pantheon-team` skill.
- Doctor reports reappearing legacy Pantheon agent/team paths as unhealthy.

### Removed

- The Explorer, Librarian, Oracle, Fixer, Designer, Reviewer, and Verifier child-agent roster.
- `$pantheon-team`; justified parallelism now belongs directly to full Pantheon.
- Fast/normal/deep full-Pantheon effort levels. Daily and full Pantheon are the two delegation-intensity controls.

### Not included

- No automatic model switching, prompt interception, token/quota meter, persistent budget state, daemon, scheduler, dashboard, recursive agent tree, or custom orchestration runtime.

## 0.4.0 — 2026-09-04

### Added

- `$pantheon-daily`, a sticky quota-conscious operating profile for routine day-to-day Codex work.
- Explicit switching between Daily and full Pantheon within one thread without persistent cross-thread state.
- Daily routing limits: normally 0-2 specialist calls per user request, a third only for a concrete unresolved blocker/risk/evidence gap, and never 4+.
- v0.4 user/release documentation and lifecycle coverage for the fifth workflow skill.

### Changed

- Full `$pantheon` is now explicitly the quality-and-confidence-first profile and remains progressive without Daily's numeric specialist ceiling.
- The managed policy now distinguishes ordinary Codex, Pantheon Daily, and full Pantheon while keeping plan/review/team workflows request-scoped.
- Install, update, doctor, and uninstall manage the new `pantheon-daily` skill alongside the existing four workflow skills.

### Not included

- No new agent role, cheaper duplicate roster, token accounting, quota polling, billing estimation, persistent budget state, daemon, scheduler, HUD, or custom runtime.

## 0.3.0 — 2026-09-04

### Added

- MIT license and project contribution, security, support, user, CLI, and release guidance.
- Documentation of Pantheon-owned install paths and same-name replacement behavior.
- Native child-context guidance: all Pantheon child spawns, including direct named-agent requests, default to `fork_turns: "none"`, with inheritance limited to genuine parent-context dependencies.
- Evidence-earned progressive specialist escalation without a fixed two-specialist ceiling, plus a concise routing map for the seven existing roles.
- Delta-only output and stop behavior for every role, with concise role-specific handoff formats.
- Regression coverage for context defaults, dispatch boundaries, activation state, packaged policy, and all seven role payloads.

### Changed

- Compact managed policy retains activation/state semantics while routing activated work to the relevant skills.
- Ordinary implementation checks now choose Reviewer or Verifier by risk; both are reserved for cases needing material static and runtime evidence.
- Documentation now distinguishes packaged configuration/lifecycle tests from live backend, provider, and runtime behavior.

### Not included

- No new agent, skill, runtime, persistence, scheduler, dashboard, token accounting, or quantitative token/billing claim.

## 0.2.0 — 2026-09-03

### Added

- Formal bounded child-agent contract for the seven core Pantheon specialists.
- `$pantheon`, `$pantheon-plan`, `$pantheon-review`, and `$pantheon-team` workflow skills.
- Fast / normal / deep orchestration-depth guidance.
- Minimal fan-out, non-recursion, and verification-first coordination rules.
- Managed `AGENTS.md` policy block.
- Idempotent lifecycle CLI with install, update, doctor, and uninstall.
- Static drift and integrity diagnostics.
- Safe copy-based custom-agent installation and regression tests.
- Codex-assisted `./pantheon bootstrap` flow plus repository instructions that let Codex install/update/repair Pantheon and verify it with `doctor`.

### Changed

- Pantheon explicitly codifies solo-by-default and user-controlled activation as project invariants.
- All seven Pantheon roles now pin explicit model and reasoning defaults.
- Explorer and Librarian use GPT-5.6 Luna with high reasoning.
- Fixer and Designer use GPT-5.6 Luna with max reasoning.
- Oracle and Reviewer use GPT-5.6 Sol with high reasoning.
- Verifier uses GPT-5.6 Terra with medium reasoning.

### Not included

- No always-on runtime, scheduler, persistent mission state, automatic prompt routing, or orchestration daemon.
