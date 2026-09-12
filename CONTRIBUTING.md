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

The static/lifecycle test suites use temporary Codex/skill homes and do not modify the normal installation. The real `pantheon verify` command is different: it intentionally consumes live model usage and creates normal Codex session rollouts.

## Repository map

| Path | Purpose |
| --- | --- |
| `agents/` | Named Luna Explorer, Librarian, and Fixer definitions |
| `skills/` | Full/Daily activation plus request-scoped planning/review workflows |
| `policy/managed-block.md` | Installed model-neutral Orchestrator/routing contract |
| `pantheon` / `pantheon.ps1` | Platform lifecycle frontends, Doctor, and opt-in live verifier |
| `tests/` | Lifecycle, migration, routing, docs-contract, and verifier regression tests |
| `docs/` | User, install, design, CLI, release, and milestone guidance |

## Change guidelines

- Preserve explicit thread-scoped activation and solo-by-default behavior.
- Keep the current supported main-thread model as the Orchestrator; GPT-6 Astra and GPT-5.6 Sol share one contract.
- Do not install a separate Astra/Sol child or add a Pantheon model selector that can drift from Codex's actual active model.
- Keep `luna_explorer`, `luna_librarian`, and `luna_fixer` as the only core Pantheon child roles unless doctrine explicitly changes.
- Explorer and Librarian remain hard read-only and return evidence; they do not create the implementation plan.
- The Orchestrator owns planning, architecture, product/tradeoff decisions, sequencing, implementation specifications, integration, review, final verification judgment, and user communication. It never implements repository changes.
- **Every repository implementation edit** routes to Fixer; there is no small/obvious/delegation-overhead exception.
- Fixer implements the Orchestrator's scoped specification; do not turn it into an autonomous planner/researcher.
- Every Fixer return must provide the structured implementation receipt required by the role contract, and the Orchestrator must reconcile that receipt against actual state.
- Preserve the implementation chain: evidence when needed → Orchestrator plan/specification → Fixer → Orchestrator review/verification.
- Treat every required child result as a hard dependency barrier for dependent planning, specification, implementation, review, or final verdict work.
- Require the Orchestrator's native MultiAgent V2 control plane. Spawn with `spawn_agent`, explicit Luna `agent_type`, and `fork_turns: "none"`.
- Keep post-spawn worker coordination on V2 `send_message`/`followup_task`; never use generic task/thread messaging or legacy/non-V2 agent primitives as Pantheon fallbacks.
- Preserve minimum self-contained child context by default.
- Daily may reduce delegation but must not invert role ownership, parallelize children, or add a numeric worker-call ceiling.
- Full Pantheon may overlap only genuinely independent work items. Unfinished evidence must never be able to change an already-issued Fixer specification; parallel Fixers require explicit non-overlapping write ownership.
- Keep `doctor` static/read-only and `verify` explicit/live/fail-closed. Never let prompt text or uncorrelated marker strings count as runtime proof.
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
- `CONTRIBUTING.md`
- `CHANGELOG.md`
- `docs/USER_GUIDE.md`
- `docs/DESIGN_DOCTRINE.md`
- `docs/CODEX_INSTALL.md`
- `docs/CLI_REFERENCE.md`
- `docs/RELEASING.md`
- routing/verifier/docs regression tests under `tests/`

For a release, follow [docs/RELEASING.md](docs/RELEASING.md).

## Validation

At minimum on macOS/Linux:

```bash
./tests/test.sh
bash ./tests/test-orchestrator-contract.sh
bash ./tests/test-doc-contract.sh
bash ./tests/test-verify.sh
bash -n pantheon install.sh tests/*.sh
git diff --check
```

Also run `.\tests\test.ps1` and `.\tests\test-verify.ps1` on Windows/PowerShell when relevant or require the Windows CI job before merge.

A passing `doctor` proves static installed integrity, not live child spawning or V2 communication. When a control-plane/runtime change depends on real child behavior, run the explicit platform command (`./pantheon verify` or `.\pantheon.ps1 verify`) in an authenticated Codex environment and record the result. The live command consumes model usage and leaves ordinary Codex parent/child session rollouts under normal Codex retention behavior.

## Pull requests

Include the problem, chosen scope, before/after behavior, exact validation, compatibility/migration implications, and documentation/changelog updates. For verifier/control-plane changes, describe both positive and adversarial/fail-closed coverage.

Contributions are licensed under the repository's [MIT License](LICENSE).
