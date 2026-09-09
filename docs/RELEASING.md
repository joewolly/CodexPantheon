# Releasing Codex Pantheon

This checklist keeps the source package, installed payload, documentation, migration behavior, platform frontends, and release metadata aligned.

## 1. Confirm scope and state

- Start from the intended base branch and fetch current remote state.
- Confirm only intended release changes are present.
- Review user-visible behavior, compatibility, install/update migration, and uninstall behavior.
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

When routing or role ownership changes, inspect:

- all three `agents/luna-*.toml` files
- all four `skills/*/SKILL.md` files
- `policy/managed-block.md`
- repository `AGENTS.md`
- `README.md` and relevant docs
- both lifecycle test suites

Confirm:

- The current supported main-thread model is the Orchestrator; GPT-6 Astra and GPT-5.6 Sol share one model-neutral contract.
- Pantheon does not spawn a separate Orchestrator or maintain a duplicate model preference.
- Model selection remains native Codex state.
- Explorer/Librarian remain read-only evidence roles and do not create the solution plan.
- Fixer remains the write-enabled implementation role and executes the Orchestrator's specification rather than independently replanning it.
- Non-trivial implementation follows evidence when needed → Orchestrator plan/specification → Fixer → Orchestrator review/verification.
- `fork_turns: "none"` and minimum self-contained context remain the child defaults.
- Daily changes delegation intensity only: no parallel children, no numeric worker ceiling, and no ownership inversion.
- Full Pantheon parallelizes only genuinely independent lanes with non-overlapping writes.
- No old role roster, team mode, or custom runtime has reappeared.
- v0.4/v0.5 cleanup remains deterministic.

## 4. Third-party attribution

When adapting additional `oh-my-opencode-slim` prompt/routing material, keep `THIRD_PARTY_NOTICES.md` accurate and preserve the upstream MIT notice.

## 5. Validate

macOS/Linux:

```bash
./tests/test.sh
bash -n pantheon install.sh tests/test.sh
git diff --check
```

Windows PowerShell:

```powershell
.\tests\test.ps1
```

The GitHub Actions matrix must pass Linux/Bash and Windows/PowerShell lifecycle jobs before release.

Live model/subagent behavior must be verified separately when a release depends on it; static tests cannot prove backend availability.

## 6. Publish separately

After repository preparation is reviewed and merged, create the intended tag/GitHub release separately and verify it points to the intended commit.
