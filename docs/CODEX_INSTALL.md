# Install Codex Pantheon with Codex

Pantheon v0.7 bootstraps through an ordinary Codex workspace. No separate orchestration or model-routing runtime is required.

Pantheon uses one shared payload and two platform-native lifecycle frontends:

- macOS/Linux: `pantheon` / `install.sh`
- Windows: `pantheon.ps1` / `install.ps1`

WSL or Git Bash is not required for a native Windows install.

## Recommended flow

1. Download or clone the Codex Pantheon source.
2. Open the source directory in Codex.
3. Ask:

   ```text
   Install Codex Pantheon for me.
   ```

This lifecycle request does **not** activate Pantheon. `$pantheon` activates Full Pantheon; `$pantheon-daily` activates Daily.

The repository `AGENTS.md` tells Codex to run the platform-appropriate bootstrap command.

macOS/Linux:

```bash
./pantheon bootstrap
```

Windows PowerShell:

```powershell
.\pantheon.ps1 bootstrap
```

`bootstrap` installs or updates Pantheon-owned files and immediately runs `doctor`.

## Orchestrator selection

Pantheon supports GPT-6 Astra and GPT-5.6 Sol as the main-thread Orchestrator. Select the model with Codex's native model control. Pantheon does not write a separate model preference, does not switch the active main model, and does not spawn a second Orchestrator.

That separation is intentional: the same installed Pantheon payload works for either model and native Codex remains the source of truth for the active model.

## Manual install/update

### macOS/Linux

```bash
./pantheon install
./pantheon doctor
```

Convenience installer:

```bash
./install.sh
```

### Windows

```powershell
.\pantheon.ps1 install
.\pantheon.ps1 doctor
```

Convenience installer:

```powershell
.\install.ps1
```

The Windows frontend defaults to `%USERPROFILE%\.codex` for Codex state and `%USERPROFILE%\.agents\skills` for skills. `CODEX_HOME` and `PANTHEON_SKILLS_HOME` override those defaults.

## What Pantheon installs

Pantheon owns:

- `<Codex home>/agents/luna-explorer.toml`
- `<Codex home>/agents/luna-librarian.toml`
- `<Codex home>/agents/luna-fixer.toml`
- `<skills home>/pantheon/`
- `<skills home>/pantheon-daily/`
- `<skills home>/pantheon-plan/`
- `<skills home>/pantheon-review/`
- the marked Pantheon block in `<Codex home>/AGENTS.md`
- `<Codex home>/.pantheon-version`

Defaults:

| Platform | Codex home | Skills home |
| --- | --- | --- |
| macOS/Linux | `~/.codex` | `~/.agents/skills` |
| Windows | `%USERPROFILE%\.codex` | `%USERPROFILE%\.agents\skills` |

Same-named Pantheon paths are replaced on install/update and removed on uninstall. Bash and PowerShell consume the same source payload.

## v0.5 migration cleanup

v0.7 continues removing the former v0.5 `<Codex home>/agents/pantheon-worker.toml` during install/update/bootstrap/uninstall, plus Pantheon's older v0.4 owned agent filenames:

- `pantheon-explorer.toml`
- `pantheon-librarian.toml`
- `pantheon-oracle.toml`
- `pantheon-fixer.toml`
- `pantheon-designer.toml`
- `pantheon-reviewer.toml`
- `pantheon-verifier.toml`

and the legacy `pantheon-team` skill directory.

If you placed unrelated personal content at one of those exact Pantheon-owned legacy paths, move it before updating. Other agent names, skills, and text outside Pantheon's managed markers remain user-owned.

## Architecture note

The selected supported main-thread model is the Orchestrator and is not installed by Pantheon. The children are `luna_explorer`, `luna_librarian`, and `luna_fixer`, all pinned to GPT-5.6 Luna High. Explorer/Librarian are read-only; Fixer is workspace-write.

## Fail-closed behavior

If Pantheon detects malformed/duplicate managed markers, a protected `AGENTS.md` symlink/reparse point, missing source payload, legacy source files that should have been removed, or another integrity problem, bootstrap stops. Do not bypass the safeguard by manually overwriting user-owned configuration.

On Windows, Pantheon treats NTFS reparse points at protected managed paths as the analogue of the Bash symlink safeguard and refuses to manage `AGENTS.md` through one.

## Doctor and Codex discovery

Both frontends validate the same static installation state. Windows Doctor looks for Codex on PATH and in native Codex app/standalone locations under `%LOCALAPPDATA%`.

Failure to discover an executable is a warning rather than a static Pantheon integrity failure.

## Evidence boundary

Repository tests validate packaged policy/configuration, migration logic, and lifecycle safeguards. `doctor` validates static installed state. Neither proves live Codex backend/provider behavior, model availability, quota use, billing, or successful native child spawning.
