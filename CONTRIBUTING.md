# Contributing to Codex Pantheon

Pantheon deliberately stays small: Codex custom-agent configuration, skills, policy, and lifecycle scripts should strengthen native delegation without becoming a separate orchestration runtime.

## Before you start

- Read [docs/DESIGN_DOCTRINE.md](docs/DESIGN_DOCTRINE.md).
- Search existing issues/PRs before overlapping work.
- Keep changes focused and preserve user-owned configuration.

## Development setup

```bash
git clone https://github.com/joewolly/CodexPantheon.git
cd CodexPantheon
./tests/test.sh
```

The test suite uses temporary Codex/skill homes and does not modify the normal installation.

## Repository map

| Path | Purpose |
| --- | --- |
| `agents/` | Named Luna Explorer, Librarian, and Fixer definitions |
| `skills/` | Full/Daily activation plus request-scoped planning/review workflows |
| `policy/managed-block.md` | Installed Astra orchestration/routing contract |
| `pantheon` | Lifecycle CLI and migration manifest |
| `tests/test.sh` | Lifecycle, migration, and routing-contract regression tests |
| `docs/` | User, install, design, CLI, release, and milestone guidance |

## Change guidelines

- Preserve explicit thread-scoped activation and solo-by-default behavior.
- Keep GPT-6 Astra as the main-thread Orchestrator; do not install a separate Astra child.
- Keep `luna_explorer`, `luna_librarian`, and `luna_fixer` as the only core Pantheon child roles unless the design doctrine explicitly changes.
- Explorer and Librarian remain hard read-only and return evidence; they do not create the implementation plan.
- Astra owns planning, architecture, product/tradeoff decisions, sequencing, implementation specifications, integration, review, final verification judgment, and user communication.
- Fixer implements Astra's scoped specification; do not turn it into an autonomous planner/researcher.
- Preserve the non-trivial implementation chain: evidence when needed → Astra plan/specification → Fixer → Astra review/verification.
- Daily may reduce delegation but must not invert role ownership, parallelize children, or add a numeric worker-call ceiling.
- Full Pantheon may parallelize only independent work with non-overlapping write ownership.
- Install custom agents as regular files, never symlinks.
- Prefer skills/config/small scripts over runtimes, daemons, schedulers, task databases, or prompt interception.
- Preserve the `oh-my-opencode-slim` MIT attribution when adapting upstream material.

When changing the operating contract, keep these aligned:

- `agents/luna-explorer.toml`
- `agents/luna-librarian.toml`
- `agents/luna-fixer.toml`
- all four `skills/*/SKILL.md` files
- `policy/managed-block.md`
- `AGENTS.md`
- `README.md`
- `docs/USER_GUIDE.md`
- `tests/test.sh`

For a release, follow [docs/RELEASING.md](docs/RELEASING.md).

## Validation

```bash
./tests/test.sh
bash -n pantheon install.sh tests/test.sh
git diff --check
```

A passing `doctor` proves static installed integrity, not a live child spawn or model/provider availability.

## Pull requests

Include the problem, chosen scope, before/after behavior, exact validation, compatibility/migration implications, and documentation/changelog updates.

Contributions are licensed under the repository's [MIT License](LICENSE).
