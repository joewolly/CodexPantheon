# Contributing to Codex Pantheon

Pantheon deliberately stays small: Codex custom-agent configuration, skills, policy, and lifecycle scripts should strengthen native delegation without becoming a separate orchestration or model-routing runtime.

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
| `policy/managed-block.md` | Installed model-neutral Orchestrator/routing contract |
| `pantheon` / `pantheon.ps1` | Platform lifecycle frontends and migration manifest |
| `tests/` | Lifecycle, migration, and routing-contract regression tests |
| `docs/` | User, install, design, CLI, release, and milestone guidance |

## Change guidelines

- Preserve explicit thread-scoped activation and solo-by-default behavior.
- Keep the current supported main-thread model as the Orchestrator; GPT-6 Astra and GPT-5.6 Sol share one contract.
- Do not install a separate Astra/Sol child or add a Pantheon model selector that can drift from Codex's actual active model.
- Keep `luna_explorer`, `luna_librarian`, and `luna_fixer` as the only core Pantheon child roles unless doctrine explicitly changes.
- Explorer and Librarian remain hard read-only and return evidence; they do not create the implementation plan.
- The Orchestrator owns planning, architecture, product/tradeoff decisions, sequencing, implementation specifications, integration, review, final verification judgment, and user communication.
- Fixer implements the Orchestrator's scoped specification; do not turn it into an autonomous planner/researcher.
- Preserve the non-trivial chain: evidence when needed → Orchestrator plan/specification → Fixer → Orchestrator review/verification.
- Require the Orchestrator's native MultiAgent V2 control plane. Spawn with `spawn_agent`, explicit Luna `agent_type`, and `fork_turns: "none"`.
- Keep post-spawn worker coordination on V2 `send_message`/`followup_task`; never use generic task/thread messaging or legacy/non-V2 agent primitives as Pantheon fallbacks.
- Preserve minimum self-contained child context by default.
- Daily may reduce delegation but must not invert role ownership, parallelize children, or add a numeric worker-call ceiling.
- Full Pantheon may parallelize only independent work with non-overlapping writes.
- Install custom agents as regular files, never symlinks/reparse points.
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
- `docs/DESIGN_DOCTRINE.md`
- `tests/test.sh`

For a release, follow [docs/RELEASING.md](docs/RELEASING.md).

## Validation

```bash
./tests/test.sh
bash -n pantheon install.sh tests/test.sh
git diff --check
```

Also run `./tests/test.ps1` on Windows/PowerShell when relevant or require the Windows CI job before release.

A passing `doctor` proves static installed integrity, not live child spawning or V2 communication. Before merging a control-plane change, validate at least one live Astra/Sol V2 → configured Luna spawn and a V2 follow-up/message round trip in Codex.

## Pull requests

Include the problem, chosen scope, before/after behavior, exact validation, compatibility/migration implications, and documentation/changelog updates.

Contributions are licensed under the repository's [MIT License](LICENSE).
