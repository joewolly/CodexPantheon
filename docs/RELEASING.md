# Releasing Codex Pantheon

This checklist keeps the source package, installed payload, documentation, migration behavior, platform frontends, and release metadata aligned.

## 1. Confirm scope and state

- Start from the intended base branch and fetch current remote state.
- Confirm only intended release changes are present.
- Review user-visible behavior, compatibility, install/update migration, and uninstall behavior.
- Confirm the Bash and PowerShell frontends still consume one shared payload rather than platform-specific copies.

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

For v0.6+, inspect all of these when routing or role ownership changes:

- `agents/luna-explorer.toml`
- `agents/luna-librarian.toml`
- `agents/luna-fixer.toml`
- `skills/pantheon/SKILL.md`
- `skills/pantheon-daily/SKILL.md`
- `skills/pantheon-plan/SKILL.md`
- `skills/pantheon-review/SKILL.md`
- `policy/managed-block.md`
- repository `AGENTS.md`
- `README.md` and relevant docs
- `tests/test.sh`
- `tests/test.ps1`

Confirm the core invariants:

- Astra remains the main-thread Orchestrator and is not installed as a child.
- Astra owns architecture, product/tradeoff decisions, the implementation specification, integration, review, and final verification judgment.
- `luna_explorer` and `luna_librarian` remain read-only evidence roles and do not create the solution plan.
- `luna_fixer` remains the write-enabled implementation role and executes Astra's plan rather than independently replanning it.
- Non-trivial implementation follows evidence when needed → Astra plan/specification → Fixer → Astra review/verification.
- Daily changes delegation intensity only: no parallel children, no numeric worker ceiling, and no ownership inversion.
- Full Pantheon may parallelize only genuinely independent lanes with non-overlapping writes.
- No Oracle/Designer/Reviewer/Verifier roster, separate team mode, or custom orchestration runtime has accidentally reappeared.
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

The GitHub Actions matrix must pass both the Linux lifecycle job and the Windows lifecycle job before release. The regression suites exercise install, update, doctor, bootstrap, migration cleanup, path defaults, user-owned configuration preservation, and uninstall with isolated temporary homes.

Live model/subagent behavior must be verified separately when a release depends on it.

## 6. Publish separately

After repository preparation is reviewed and merged, create the intended tag/GitHub release separately and verify it points to the intended commit.
