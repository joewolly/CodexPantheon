# Changelog

## Unreleased

### Added

- MIT license and project contribution, security, support, user, CLI, and release guidance.
- Documentation of Pantheon-owned install paths and same-name replacement behavior.

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
