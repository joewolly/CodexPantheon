# Codex Pantheon repository instructions

Keep Pantheon slim, explicit, and Codex-native.

- Prefer configuration, skills, and small scripts over custom runtime machinery.
- Do not add automatic activation, prompt interception, background daemons, persistent mission state, or recursive child-agent orchestration without an explicit design decision changing the project doctrine.
- Preserve solo-by-default behavior.
- Preserve the v0.6 orchestration architecture: GPT-6 Astra remains the main-thread orchestrator; `luna_explorer`, `luna_librarian`, and `luna_fixer` are the only Pantheon child roles.
- Astra owns planning, architecture, product/tradeoff decisions, prioritization, integration, review, final verification judgment, and the final response. Astra is not the default implementation worker.
- Luna Explorer and Librarian are read-only evidence specialists. Luna Fixer implements Astra's scoped specification and must not independently redesign or replan the mission.
- Every Astra child spawn must use a role-prefixed `task_name`: `luna_explorer_<assignment>`, `luna_librarian_<assignment>`, or `luna_fixer_<assignment>`. The assignment suffix must be concrete, concise, and unique enough to distinguish concurrent work; generic task names that omit the Luna lane are not acceptable.
- For non-trivial implementation, preserve the dependency chain: Explorer/Librarian evidence when needed → Astra plan/specification → Fixer implementation → Astra review/verification.
- Keep Daily and full Pantheon as the only delegation-intensity profiles. Daily may delegate less and does not parallelize children, but it must not alter role ownership or impose a numeric worker-call ceiling.
- Preserve user-owned Codex configuration outside Pantheon-managed files/markers.
- Custom agent roles must be installed as regular files, not symlinks/reparse points.
- Keep one shared payload under `agents/`, `skills/`, and `policy/`; the Bash and PowerShell lifecycle frontends must not fork or duplicate that payload.
- Run `./tests/test.sh` after lifecycle-script, policy, skill, migration, or agent changes. When Windows behavior changes, also run `./tests/test.ps1` on PowerShell/Windows or rely on the Windows CI job before merge.

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
