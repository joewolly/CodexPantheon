# Contributing to Codex Pantheon

Thanks for helping improve Pantheon. The project deliberately stays small: configuration, skills, policy, and lifecycle scripts should strengthen native Codex delegation without becoming a separate orchestration runtime.

## Before you start

- Read the [design doctrine](docs/DESIGN_DOCTRINE.md).
- Search existing issues and pull requests before opening overlapping work.
- For a substantial change, open an issue first so the behavior and scope can be agreed before implementation.
- Keep changes focused. Avoid unrelated cleanup in the same pull request.

## Development setup

Clone the repository, create a branch, and validate the current checkout:

```bash
git clone https://github.com/joewolly/CodexPantheon.git
cd CodexPantheon
./tests/test.sh
```

The test suite creates isolated temporary Codex and skill homes. It does not modify your normal Codex configuration.

To inspect an installed development copy without using your normal Codex home, set both supported overrides:

```bash
PANTHEON_DEV_ROOT="$(mktemp -d)"
CODEX_HOME="$PANTHEON_DEV_ROOT/codex" \
PANTHEON_SKILLS_HOME="$PANTHEON_DEV_ROOT/skills" \
./pantheon bootstrap
```

Remove the temporary directory when you are finished with the isolated installation.

## Repository map

| Path | Purpose |
| --- | --- |
| `agents/` | Installed custom-agent definitions and their permission postures |
| `skills/` | Explicit Pantheon activation, planning, review, and team workflows |
| `policy/managed-block.md` | The policy block installed into Codex `AGENTS.md` |
| `pantheon` | Lifecycle CLI and source-of-truth install manifest |
| `install.sh` | Backward-compatible install entry point |
| `tests/test.sh` | Isolated lifecycle and policy regression suite |
| `docs/` | User, install, design, CLI, release, and milestone guidance |

## Change guidelines

- Preserve explicit, thread-scoped activation and solo-by-default behavior.
- Keep the parent Codex thread responsible for interpretation, delegation, integration, verification, and the final response.
- Give every delegated agent a bounded objective, scope, constraints, permissions, expected evidence, and a prohibition on spawning subagents.
- Preserve user-owned Codex configuration outside Pantheon's files and managed markers.
- Install custom agent roles as regular files, never symlinks.
- Prefer a skill, configuration change, or small script over new runtime machinery.
- Do not add automatic activation, prompt interception, recursive orchestration, daemons, task databases, or hidden cross-thread state without an explicit change to the design doctrine.

Pantheon's operating contract is repeated in several installed surfaces. When changing it, inspect and keep the applicable copies aligned:

- `skills/pantheon/SKILL.md`
- `policy/managed-block.md`
- `AGENTS.md`
- `README.md`
- `docs/USER_GUIDE.md`
- `tests/test.sh`

For a release, follow [docs/RELEASING.md](docs/RELEASING.md) and synchronize `VERSION`, the CLI version constant, version-specific test assertions, the changelog, and applicable release documentation.

## Validation

Run the complete repository test suite for lifecycle, policy, agent, or skill changes:

```bash
./tests/test.sh
```

Also run these lightweight checks for documentation or shell changes:

```bash
bash -n pantheon install.sh tests/test.sh
git diff --check
```

If behavior depends on a live Codex build or provider, report that evidence separately. A passing `doctor` verifies the installed files and static integrity; it does not prove a live subagent spawn.

## Pull requests

A pull request should include:

- a clear description of the problem and the chosen scope;
- the user-visible behavior before and after the change;
- validation commands and exact results;
- any compatibility, migration, or uninstall implications;
- documentation and changelog updates when behavior changes.

By contributing, you agree that your contributions will be licensed under the repository's [MIT License](LICENSE).
