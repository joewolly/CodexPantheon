# Changelog

## Unreleased

## 0.3.0 — 2026-09-04

### Added

- MIT license and project contribution, security, support, user, CLI, and release guidance.
- Documentation of Pantheon-owned install paths and same-name replacement behavior.
- Native child-context guidance: self-contained assignments default to `fork_turns: "none"`, with inheritance limited to genuine parent-context dependencies.
- Progressive specialist escalation and a concise routing map for the seven existing roles.
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
