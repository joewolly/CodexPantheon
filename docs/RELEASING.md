# Releasing Codex Pantheon

This checklist keeps the source package, installed payload, documentation, migration behavior, platform frontends, runtime-evidence boundary, and release metadata aligned.

## 1. Confirm scope and state

- Start from the intended base branch and fetch current remote state.
- Confirm only intended release changes are present.
- Review user-visible behavior, compatibility, install/update migration, uninstall behavior, and any change to live verifier assumptions.
- Confirm Bash and PowerShell still consume one shared payload rather than platform-specific copies.

## 2. Synchronize the version

Update:

- `VERSION`
- the `VERSION` constant in `pantheon`
- the `$Version` constant in `pantheon.ps1`
- version-specific expectations in `tests/test.sh` and `tests/test.ps1`
- `CHANGELOG.md`
- the README current-release summary
- a milestone note such as `docs/Vx.y.z.md` for material releases

Historical release notes may intentionally describe prior architectures.

## 3. Synchronize the operating contract

When routing, role ownership, dependency semantics, completion evidence, or runtime verification changes, inspect:

- all three `agents/luna-*.toml` files
- all four `skills/*/SKILL.md` files
- `policy/managed-block.md`
- repository `AGENTS.md`
- `README.md`
- `CONTRIBUTING.md`
- `CHANGELOG.md`
- `docs/USER_GUIDE.md`
- `docs/DESIGN_DOCTRINE.md`
- `docs/CODEX_INSTALL.md`
- `docs/CLI_REFERENCE.md`
- this release checklist
- routing/verifier/docs regression tests

Confirm:

- The current supported main-thread model is the Orchestrator; GPT-6 Astra and GPT-5.6 Sol share one model-neutral contract.
- Pantheon does not spawn a separate Orchestrator or maintain a duplicate model preference.
- Model selection remains native Codex state.
- Explorer/Librarian remain read-only evidence roles and do not create the solution plan.
- Fixer remains the write-enabled implementation role and executes the Orchestrator's specification rather than independently replanning it.
- **Every repository implementation edit** routes through Fixer; no size/delegation-overhead exception has reappeared.
- Every Fixer return provides the structured implementation receipt, and the Orchestrator reconciles it before completion.
- Required child results remain hard dependency barriers for the dependent plan/specification/implementation/review/verdict.
- `fork_turns: "none"` and minimum self-contained context remain the child defaults.
- Daily changes delegation intensity only: no parallel children, no numeric worker ceiling, and no ownership inversion.
- Full Pantheon overlaps only genuinely independent work items; unfinished evidence cannot change an already-issued Fixer specification, and parallel Fixers have non-overlapping write ownership.
- `doctor` remains static/read-only; `verify` remains explicit, live, and fail-closed on correlated runtime evidence.
- No old role roster, team mode, or custom runtime has reappeared.
- v0.4/v0.5 cleanup remains deterministic.

## 4. Third-party attribution

When adapting additional `oh-my-opencode-slim` prompt/routing material, keep `THIRD_PARTY_NOTICES.md` accurate and preserve the upstream MIT notice.

## 5. Validate packaged behavior

macOS/Linux:

```bash
./tests/test.sh
bash ./tests/test-orchestrator-contract.sh
bash ./tests/test-doc-contract.sh
bash ./tests/test-verify.sh
bash -n pantheon install.sh tests/*.sh
git diff --check
```

Windows PowerShell:

```powershell
.\tests\test.ps1
.\tests\test-verify.ps1
```

The GitHub Actions matrix must pass Linux/Bash and Windows/PowerShell jobs before release.

The verifier regression harnesses are deterministic/fake-runtime tests. They prove parser/fail-closed behavior, not provider availability or the user's authenticated runtime.

## 6. Validate live behavior when relevant

If the release changes agent control, spawn metadata, model/effort routing, context isolation, or live-verifier assumptions, run the explicit live check in an authenticated Codex environment:

macOS/Linux:

```bash
./pantheon verify
```

Windows PowerShell:

```powershell
.\pantheon.ps1 verify
```

Record the result in the release/PR evidence. A successful `verify` proves the tested environment completed the exact parent→Luna Explorer smoke path at that point in time; it is not a permanent guarantee of provider availability.

Remember that the command consumes live model usage and creates ordinary parent/child Codex session rollouts. Pantheon cleans only its temporary verifier artifacts; normal session records remain under Codex retention behavior.

## 7. Publish from the merged release commit

Release metadata is published by `.github/workflows/release.yml` when `VERSION` changes on `main`. Changes to the publisher workflow itself also trigger it so publication fixes can recover a failed release without another version bump.

The publication job:

- checks out the exact merged `main` commit;
- verifies a matching `docs/Vx.y.z.md` release-note file and changelog heading;
- reruns the Bash package/lifecycle suite and shell syntax checks;
- creates tag `vX.Y.Z` at the exact merged commit;
- creates the GitHub release using the versioned release-note file;
- is idempotent when the matching release already exists;
- treats a publisher-only change as a no-op when that version is already released;
- fails closed rather than overwriting an existing mismatched tag/release.

After merging the release PR, verify the **Publish release** workflow succeeds and confirm the GitHub release/tag both resolve to the intended merged commit.
