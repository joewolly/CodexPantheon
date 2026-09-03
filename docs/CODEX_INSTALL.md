# Install Codex Pantheon with Codex

Pantheon v0.2 can bootstrap itself through an ordinary Codex workspace. No separate orchestration runtime is required.

## Recommended flow

1. Download or clone the Codex Pantheon source.
2. Open the Pantheon source directory in the Codex app or start Codex from that directory.
3. Ask Codex:

   ```text
   Install Codex Pantheon for me.
   ```

The repository `AGENTS.md` tells Codex to execute:

```bash
./pantheon bootstrap
```

`bootstrap` performs the Pantheon-owned install/update and immediately runs `doctor`.

## What Codex is allowed to change

The bootstrap command is deliberately bounded. It may synchronize only:

- Pantheon custom-agent TOMLs under `${CODEX_HOME:-~/.codex}/agents/`;
- Pantheon workflow skills under `~/.agents/skills/`;
- Pantheon's marked block in `${CODEX_HOME:-~/.codex}/AGENTS.md`;
- `${CODEX_HOME:-~/.codex}/.pantheon-version`.

It preserves unrelated Codex configuration and unrelated skills.

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
