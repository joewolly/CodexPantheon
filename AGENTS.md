# Codex Pantheon repository instructions

Keep Pantheon slim, explicit, and Codex-native.

- Prefer configuration, skills, and small scripts over custom runtime machinery.
- Do not add automatic activation, prompt interception, background daemons, persistent mission state, or recursive child-agent orchestration without an explicit design decision changing the project doctrine.
- Preserve solo-by-default behavior.
- Preserve user-owned Codex configuration outside Pantheon-managed files/markers.
- Custom agent roles must be installed as regular files, not symlinks.
- Run `./tests/test.sh` after lifecycle-script or policy changes.

## Codex-assisted lifecycle

When the user asks Codex to install, set up, upgrade, update, repair, or verify Codex Pantheon from this repository, act on the request rather than only describing commands.

- For install/setup/upgrade/update/repair, run `./pantheon bootstrap`.
- `bootstrap` is the preferred Codex entry point because it installs or refreshes only Pantheon-owned files and then runs `doctor`.
- If `bootstrap` fails, report the exact safeguard or validation failure. Do not bypass malformed-marker, symlink, or user-owned configuration protections by manually overwriting files.
- If the user asks only for instructions or explicitly says not to make changes, explain the commands without executing them.
- For a verification-only request, run `./pantheon doctor`.
- For removal, run `./pantheon uninstall` only when the user explicitly asks to uninstall/remove Pantheon.

These are ordinary repository lifecycle operations. For example, `Install Codex Pantheon for me.` asks Codex to operate on Pantheon with `./pantheon bootstrap`; it MUST NOT by itself activate Pantheon orchestration. Requests to update, repair, verify, configure, document, or otherwise operate on Pantheon are likewise non-activating unless the user separately and clearly asks to use, enable, or enter Pantheon orchestration.
