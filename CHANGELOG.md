# Changelog

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
- Explorer and Librarian now default to GPT-5.6 Luna with medium reasoning; Fixer defaults to GPT-5.6 Luna with max reasoning.

### Not included

- No always-on runtime, scheduler, persistent mission state, automatic prompt routing, or orchestration daemon.
