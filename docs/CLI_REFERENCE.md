# Pantheon CLI Reference

Run the lifecycle CLI from a Codex Pantheon source checkout:

```text
./pantheon <command>
```

The script requires Bash and common Unix command-line utilities. The repository does not currently define a formal operating-system or minimum-Codex compatibility matrix. Agent model availability depends on the active Codex build and provider and is not established by the lifecycle CLI.

## Commands

| Command | Changes local state | Purpose |
| --- | --- | --- |
| `bootstrap` | Yes | Install or refresh Pantheon-owned files, then run `doctor` |
| `install` | Yes | Install the source package's Pantheon-owned files |
| `update` | Yes | Replace installed Pantheon-owned files with the source package's versions |
| `doctor` | No persistent changes | Check source completeness, installed files, managed policy, drift, and Codex executable discovery |
| `uninstall` | Yes | Remove Pantheon-owned files, skills, policy block, and version marker |
| `version` | No | Print the Pantheon version |
| `help` | No | Print usage and environment-variable help |

`--version` and `-v` are aliases for `version`. `--help` and `-h` are aliases for `help`. An unknown command prints usage and exits with status 2.

Running `./pantheon` without a command prints help and exits successfully. Successful commands normally exit 0. Source-package or fail-closed safeguard errors exit 1; these can occur before `doctor` reaches its status summary.

## Environment variables

| Variable | Default | Controls |
| --- | --- | --- |
| `CODEX_HOME` | `~/.codex` | Agent definitions, managed `AGENTS.md` block, and version marker |
| `PANTHEON_SKILLS_HOME` | `~/.agents/skills` | Pantheon workflow skill directories |

Example with isolated destinations:

```bash
PANTHEON_TEST_ROOT="$(mktemp -d)"
CODEX_HOME="$PANTHEON_TEST_ROOT/codex" \
PANTHEON_SKILLS_HOME="$PANTHEON_TEST_ROOT/skills" \
./pantheon bootstrap
```

Remove the temporary directory when you no longer need the isolated installation.

## Owned paths

Pantheon owns these installed paths:

- `${CODEX_HOME:-~/.codex}/agents/pantheon-*.toml` for the seven bundled role names;
- `${PANTHEON_SKILLS_HOME:-~/.agents/skills}/pantheon*` for the five bundled workflow names (`pantheon`, `pantheon-daily`, `pantheon-plan`, `pantheon-review`, and `pantheon-team`);
- the single `<!-- PANTHEON:START -->` through `<!-- PANTHEON:END -->` block in `${CODEX_HOME:-~/.codex}/AGENTS.md`;
- `${CODEX_HOME:-~/.codex}/.pantheon-version`.

Install and update replace same-named Pantheon agent files and skill directories. Uninstall removes them. Pantheon does not back up those owned paths, so move or rename any unrelated content that currently uses a bundled Pantheon name before installing.

Text outside the managed `AGENTS.md` markers and skills or agent definitions with other names remain user-owned.

## Doctor outcomes

After its source-package preflight passes, `doctor` reports one of three outcomes:

- `HEALTHY`: all static checks passed;
- `HEALTHY WITH WARNINGS`: checks passed, but Codex discovery or possible legacy unmanaged instructions need attention;
- `UNHEALTHY`: one or more source, install, drift, symlink, or marker checks failed.

Healthy and healthy-with-warning outcomes exit 0. An unhealthy outcome exits 1 and suggests `./pantheon update` for repairable Pantheon-owned drift. A missing or invalid source-package file also exits 1 immediately without printing one of these status labels.

Doctor may create and remove a temporary comparison file and may invoke `codex --version`, but it does not rewrite the installed Pantheon configuration. It validates static installation integrity, not model availability, provider access, quota behavior, billing, or a successful live subagent spawn.

## Fail-closed safeguards

Lifecycle operations refuse to guess when the managed `AGENTS.md` markers are malformed or duplicated, or when that file is not a regular non-symlink file. Resolve the ownership or marker problem manually; do not bypass it by overwriting unrelated configuration.
