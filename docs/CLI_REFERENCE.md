# Pantheon CLI Reference

Run the lifecycle CLI from a Codex Pantheon source checkout:

```text
./pantheon <command>
```

The script requires Bash and common Unix utilities. Model availability depends on the active Codex build/provider and is not established by this CLI.

## Commands

| Command | Changes local state | Purpose |
| --- | --- | --- |
| `bootstrap` | Yes | Install or refresh Pantheon-owned files, remove owned legacy payloads, then run `doctor` |
| `install` | Yes | Install the source package and perform v0.4 cleanup |
| `update` | Yes | Replace Pantheon-owned files with the source package and perform v0.4 cleanup |
| `doctor` | No persistent changes | Check source completeness, current payload, legacy absence, policy, drift, and Codex discovery |
| `uninstall` | Yes | Remove current and legacy Pantheon-owned files, skills, policy block, and version marker |
| `version` | No | Print the Pantheon version |
| `help` | No | Print usage and environment-variable help |

`--version`/`-v` alias `version`; `--help`/`-h` alias `help`. Unknown commands exit 2.

## Environment variables

| Variable | Default | Controls |
| --- | --- | --- |
| `CODEX_HOME` | `~/.codex` | Agent definition, managed `AGENTS.md` block, version marker |
| `PANTHEON_SKILLS_HOME` | `~/.agents/skills` | Pantheon workflow skills |

## Current owned paths

- `${CODEX_HOME:-~/.codex}/agents/pantheon-worker.toml`;
- `${PANTHEON_SKILLS_HOME:-~/.agents/skills}/pantheon/`;
- `${PANTHEON_SKILLS_HOME:-~/.agents/skills}/pantheon-daily/`;
- `${PANTHEON_SKILLS_HOME:-~/.agents/skills}/pantheon-plan/`;
- `${PANTHEON_SKILLS_HOME:-~/.agents/skills}/pantheon-review/`;
- the single `<!-- PANTHEON:START -->` through `<!-- PANTHEON:END -->` block in `${CODEX_HOME:-~/.codex}/AGENTS.md`;
- `${CODEX_HOME:-~/.codex}/.pantheon-version`.

Install/update replace those same-named Pantheon paths. Uninstall removes them. Text outside the managed `AGENTS.md` markers and unrelated agent/skill names remain user-owned.

## Legacy paths owned for migration/removal

v0.5 also treats the following former Pantheon names as owned cleanup targets:

- `pantheon-explorer.toml`
- `pantheon-librarian.toml`
- `pantheon-oracle.toml`
- `pantheon-fixer.toml`
- `pantheon-designer.toml`
- `pantheon-reviewer.toml`
- `pantheon-verifier.toml`
- the `pantheon-team` skill directory

`install`, `update`, and `bootstrap` remove those paths before installing v0.5. `doctor` reports them as unhealthy if they reappear. `uninstall` removes them too.

## Doctor outcomes

After source preflight, `doctor` reports:

- `HEALTHY` — static checks passed;
- `HEALTHY WITH WARNINGS` — checks passed, but Codex discovery or possible unmanaged Pantheon text needs attention;
- `UNHEALTHY` — source, install, legacy-cleanup, drift, symlink, or marker checks failed.

Healthy/healthy-with-warning exit 0; unhealthy exits 1. A source-package integrity failure exits 1 immediately.

Doctor may create/remove a temporary comparison file and may invoke `codex --version`, but it does not rewrite installed configuration. It validates static installation integrity, not model/provider availability, quota behavior, billing, or a successful live worker spawn.

## Fail-closed safeguards

Lifecycle operations refuse to guess when managed `AGENTS.md` markers are malformed/duplicated or when that file is not a regular non-symlink file. Resolve the ownership/marker problem manually rather than overwriting unrelated configuration.
