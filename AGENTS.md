# Codex Pantheon repository instructions

Keep Pantheon slim, explicit, model-neutral at the Orchestrator layer, and Codex-native.

- Prefer configuration, skills, and small scripts over custom runtime machinery.
- Do not add automatic activation, prompt interception, background daemons, persistent mission state, recursive child-agent orchestration, or a model-switching runtime without an explicit design decision changing project doctrine.
- Preserve solo-by-default behavior.
- Preserve the v0.7 orchestration architecture: the current supported main-thread model is the Orchestrator; supported choices are GPT-6 Astra and GPT-5.6 Sol. `luna_explorer`, `luna_librarian`, and `luna_fixer` are the only Pantheon child roles.
- Do not install or spawn a separate Astra/Sol Orchestrator. Pantheon must not pretend to switch the main-thread model; model selection stays with native Codex controls.
- The Orchestrator owns planning, architecture, product/tradeoff decisions, prioritization, integration, review, final verification judgment, and the final response. It is not the default implementation worker.
- Luna Explorer and Librarian are read-only evidence specialists. Luna Fixer implements the Orchestrator's scoped specification and must not independently redesign or replan the mission.
- Prefer Codex's directly interactive V1 parented-child surface when it is exposed: use `multi_agent_v1.spawn_agent`, select `luna_explorer`, `luna_librarian`, or `luna_fixer` with `agent_type`, and set `fork_context: false`.
- If V1 is unavailable, use V2 with `fork_turns: "none"` and a role-prefixed `task_name`: `luna_explorer_<assignment>`, `luna_librarian_<assignment>`, or `luna_fixer_<assignment>`. Do not choose V2 merely for task naming when V1 is available.
- For non-trivial implementation, preserve the dependency chain: Explorer/Librarian evidence when needed → Orchestrator plan/specification → Fixer implementation → Orchestrator review/verification.
- Keep Daily and Full Pantheon as the only delegation-intensity profiles. Daily may delegate less and does not parallelize children, but it must not alter role ownership or impose a numeric worker-call ceiling.
- Preserve minimum self-contained child context and never inherit full parent history by default.
- Preserve user-owned Codex configuration outside Pantheon-managed files/markers.
- Custom agent roles must be installed as regular files, not symlinks/reparse points.
- Keep one shared payload under `agents/`, `skills/`, and `policy/`; Bash and PowerShell lifecycle frontends must not fork or duplicate it.
- Run `./tests/test.sh` after lifecycle-script, policy, skill, migration, or agent changes. When Windows behavior changes, also run `./tests/test.ps1` on PowerShell/Windows or rely on Windows CI before merge.

## Codex-assisted lifecycle

When the user asks Codex to install, set up, upgrade, update, repair, or verify Codex Pantheon from this repository, act on the request rather than only describing commands.

- On macOS/Linux, for install/setup/upgrade/update/repair, run `./pantheon bootstrap`.
- On Windows, for install/setup/upgrade/update/repair, run `.\pantheon.ps1 bootstrap`.
- `bootstrap` installs or refreshes only Pantheon-owned files, removes Pantheon-owned legacy v0.4/v0.5 payloads, and then runs `doctor`.
- If `bootstrap` fails, report the exact safeguard or validation failure. Do not bypass malformed-marker, symlink/reparse-point, source-integrity, or user-owned configuration protections by manually overwriting files.
- If the user asks only for instructions or explicitly says not to make changes, explain the platform-appropriate commands without executing them.
- For verification-only requests, run `./pantheon doctor` on macOS/Linux or `.\pantheon.ps1 doctor` on Windows.
- For removal, run `./pantheon uninstall` on macOS/Linux or `.\pantheon.ps1 uninstall` on Windows only when the user explicitly asks to uninstall/remove Pantheon.

Lifecycle requests do not activate Pantheon orchestration. `$pantheon` and `$pantheon-daily` are the explicit sticky activation controls.
