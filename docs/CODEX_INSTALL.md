# Install Codex Pantheon with Codex

Pantheon v0.3.0 can bootstrap itself through an ordinary Codex workspace. No separate orchestration runtime is required.

## Recommended flow

1. Download or clone the Codex Pantheon source.
2. Open the Pantheon source directory in the Codex app or start Codex from that directory.
3. Ask Codex:

   ```text
   Install Codex Pantheon for me.
   ```

This request operates on the Pantheon product; it does not activate Pantheon orchestration. `$pantheon` followed by a task explicitly activates orchestration, while `Use Pantheon to update the Pantheon installer.` explicitly activates Pantheon and then operates on Pantheon.

The repository `AGENTS.md` tells Codex to execute:

```bash
./pantheon bootstrap
```

`bootstrap` performs the Pantheon-owned install/update and immediately runs `doctor`.

The repository tests validate packaged policy/configuration and lifecycle safeguards; they do not prove live Codex backend, provider, runtime, or child-spawn availability.

## What Codex is allowed to change

The bootstrap command is deliberately bounded. It may synchronize only:

- Pantheon custom-agent TOMLs under `${CODEX_HOME:-~/.codex}/agents/`;
- Pantheon workflow skills under `${PANTHEON_SKILLS_HOME:-~/.agents/skills}`;
- Pantheon's marked block in `${CODEX_HOME:-~/.codex}/AGENTS.md`;
- `${CODEX_HOME:-~/.codex}/.pantheon-version`.

It preserves unrelated Codex configuration and unrelated skills.

### Pantheon-owned names

Install and update replace the bundled Pantheon agent files and workflow skill directories when those same names already exist. Uninstall removes those paths. They are Pantheon-owned and are not backed up:

- the seven `pantheon-*.toml` agent definitions bundled under `agents/`;
- the `pantheon`, `pantheon-plan`, `pantheon-review`, and `pantheon-team` skill directories;
- the managed Pantheon block in `AGENTS.md`;
- the `.pantheon-version` marker.

Move or rename unrelated content that already uses one of those exact names before installing. Other agent names, other skills, and text outside Pantheon's managed markers remain user-owned.

## Fail-closed behavior

If Pantheon detects malformed/duplicate managed markers, a protected `AGENTS.md` symlink, or another integrity problem, bootstrap stops and Codex should report the error rather than bypassing the safeguard with manual file edits.

## Other natural-language requests

From the Pantheon source workspace, these requests are also defined by the repository instructions:

```text
Update Pantheon for me.
Repair my Pantheon installation.
Check whether Pantheon is installed correctly.
Uninstall Pantheon.
```

Install/update/repair use `./pantheon bootstrap`; verification uses `./pantheon doctor`; uninstall runs only on an explicit removal request.
