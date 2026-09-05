# Install Codex Pantheon with Codex

Pantheon v0.5.0 bootstraps through an ordinary Codex workspace. No separate orchestration runtime is required.

## Recommended flow

1. Download or clone the Codex Pantheon source.
2. Open the source directory in Codex.
3. Ask:

   ```text
   Install Codex Pantheon for me.
   ```

This is a lifecycle request and **does not activate Pantheon orchestration**. `$pantheon` explicitly activates full Pantheon; `$pantheon-daily` explicitly activates Daily.

The repository `AGENTS.md` tells Codex to execute:

```bash
./pantheon bootstrap
```

`bootstrap` installs or updates Pantheon-owned files and immediately runs `doctor`.

## What v0.5 installs

Pantheon owns these current paths:

- `${CODEX_HOME:-~/.codex}/agents/pantheon-worker.toml`;
- `${PANTHEON_SKILLS_HOME:-~/.agents/skills}/pantheon/`;
- `${PANTHEON_SKILLS_HOME:-~/.agents/skills}/pantheon-daily/`;
- `${PANTHEON_SKILLS_HOME:-~/.agents/skills}/pantheon-plan/`;
- `${PANTHEON_SKILLS_HOME:-~/.agents/skills}/pantheon-review/`;
- the marked Pantheon block in `${CODEX_HOME:-~/.codex}/AGENTS.md`;
- `${CODEX_HOME:-~/.codex}/.pantheon-version`.

Same-named current Pantheon paths are replaced on install/update and removed on uninstall. Pantheon does not back them up.

## v0.4 migration cleanup

v0.5 intentionally removes these Pantheon-owned legacy agent files during install/update/uninstall:

- `pantheon-explorer.toml`
- `pantheon-librarian.toml`
- `pantheon-oracle.toml`
- `pantheon-fixer.toml`
- `pantheon-designer.toml`
- `pantheon-reviewer.toml`
- `pantheon-verifier.toml`

It also removes the legacy `${PANTHEON_SKILLS_HOME:-~/.agents/skills}/pantheon-team/` skill. Full `$pantheon` now owns justified parallel Luna work directly.

If you placed unrelated personal content at one of those exact Pantheon-owned legacy paths, move it before updating. Other agent names, other skills, and text outside Pantheon's managed markers remain user-owned.

## Architecture note

Astra is the intended main Codex model; it is not installed by Pantheon. The only Pantheon child definition is `pantheon_worker`, pinned to GPT-5.6 Luna High. Pantheon does not automatically change the main model.

## Fail-closed behavior

If Pantheon detects malformed/duplicate managed markers, a protected `AGENTS.md` symlink, missing source payload, legacy source files that should have been removed, or another integrity problem, bootstrap stops. Do not bypass the safeguard by manually overwriting user-owned configuration.

## Evidence boundary

Repository tests validate packaged policy/configuration, migration logic, and lifecycle safeguards. `doctor` validates static installed state. Neither proves live Codex backend/provider behavior, model availability, quota use, billing, or successful native child spawning.

## Other natural-language lifecycle requests

```text
Update Pantheon for me.
Repair my Pantheon installation.
Check whether Pantheon is installed correctly.
Uninstall Pantheon.
```

Install/update/repair use `./pantheon bootstrap`; verification uses `./pantheon doctor`; uninstall runs only on an explicit removal request. None of these activates Pantheon unless the user separately asks to use a Pantheon profile.
