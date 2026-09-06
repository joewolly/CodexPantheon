# Pantheon CLI Reference

Run the lifecycle CLI from a Codex Pantheon source checkout:

```text
./pantheon <command>
```

## Commands

| Command | Changes local state | Purpose |
| --- | --- | --- |
| `bootstrap` | Yes | Install/refresh Pantheon-owned files, remove owned legacy payloads, then run `doctor` |
| `install` | Yes | Install the current source package and perform migration cleanup |
| `update` | Yes | Replace Pantheon-owned files with the current source package and perform migration cleanup |
| `doctor` | No persistent changes | Check source completeness, current payload, legacy absence, policy, drift, and Codex discovery |
| `uninstall` | Yes | Remove current and legacy Pantheon-owned files, skills, policy block, and version marker |
| `version` | No | Print the Pantheon version |
| `help` | No | Print usage and environment-variable help |

## Environment variables

| Variable | Default | Controls |
| --- | --- | --- |
| `CODEX_HOME` | `~/.codex` | Agent definitions, managed `AGENTS.md` block, version marker |
| `PANTHEON_SKILLS_HOME` | `~/.agents/skills` | Pantheon workflow skills |

## Current owned paths

- `${CODEX_HOME:-~/.codex}/agents/luna-explorer.toml`
- `${CODEX_HOME:-~/.codex}/agents/luna-librarian.toml`
- `${CODEX_HOME:-~/.codex}/agents/luna-fixer.toml`
- `${PANTHEON_SKILLS_HOME:-~/.agents/skills}/pantheon/`
- `${PANTHEON_SKILLS_HOME:-~/.agents/skills}/pantheon-daily/`
- `${PANTHEON_SKILLS_HOME:-~/.agents/skills}/pantheon-plan/`
- `${PANTHEON_SKILLS_HOME:-~/.agents/skills}/pantheon-review/`
- the single `<!-- PANTHEON:START -->` through `<!-- PANTHEON:END -->` block in `${CODEX_HOME:-~/.codex}/AGENTS.md`
- `${CODEX_HOME:-~/.codex}/.pantheon-version`

## Legacy paths owned for migration/removal

v0.6 treats the following former Pantheon names as owned cleanup targets:

- `pantheon-worker.toml` (v0.5)
- `pantheon-explorer.toml`
- `pantheon-librarian.toml`
- `pantheon-oracle.toml`
- `pantheon-fixer.toml`
- `pantheon-designer.toml`
- `pantheon-reviewer.toml`
- `pantheon-verifier.toml`
- the `pantheon-team` skill directory

`install`, `update`, and `bootstrap` remove those paths before installing v0.6. `doctor` reports them as unhealthy if they reappear. `uninstall` removes them too.

## Doctor outcomes

- `HEALTHY` — static checks passed.
- `HEALTHY WITH WARNINGS` — checks passed but Codex discovery or possible unmanaged Pantheon text needs attention.
- `UNHEALTHY` — source, install, migration-cleanup, drift, symlink, or marker checks failed.

Doctor may invoke `codex --version` and create/remove a temporary comparison file, but it does not rewrite installed configuration. It validates static installation integrity, not model/provider availability, quota behavior, billing, or a successful live child spawn.

## Fail-closed safeguards

Lifecycle operations refuse to guess when managed `AGENTS.md` markers are malformed/duplicated or when that file is not a regular non-symlink file. Resolve the ownership/marker problem manually rather than overwriting unrelated configuration.
