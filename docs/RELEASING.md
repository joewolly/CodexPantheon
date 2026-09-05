# Releasing Codex Pantheon

This checklist keeps the source package, installed payload, documentation, migration behavior, and release metadata aligned. It defines repository-side preparation; publishing a tag or GitHub release remains a separate maintainer action.

## 1. Confirm scope and state

- Start from the intended base branch and fetch current remote state.
- Confirm the worktree contains only the intended release changes.
- Review user-visible changes, compatibility implications, install/update behavior, migration behavior, and uninstall behavior.
- Decide whether the change needs a milestone note such as `docs/Vx.y.z.md`. Patch releases do not need a dedicated note unless the behavior warrants one.

## 2. Synchronize the version

Update every source of the release version:

- `VERSION`;
- the `VERSION` constant in `pantheon`;
- version-specific expectations in `tests/test.sh`;
- `CHANGELOG.md`;
- the README's current-release summary when its behavior changed.

Search current user-facing surfaces for stale previous-version behavior afterward. Historical release notes and changelog entries may intentionally describe prior architectures.

## 3. Synchronize the operating contract

When activation, profile switching, delegation intensity, context, or lifecycle behavior changes, inspect every surface that repeats that contract:

- `agents/pantheon-worker.toml`;
- `skills/pantheon/SKILL.md`;
- `skills/pantheon-daily/SKILL.md`;
- `skills/pantheon-plan/SKILL.md`;
- `skills/pantheon-review/SKILL.md`;
- `policy/managed-block.md`;
- repository `AGENTS.md`;
- `README.md` and relevant files under `docs/`;
- `tests/test.sh`.

For v0.5 and later, confirm the core invariants explicitly:

- Astra remains the main-thread orchestrator and is not installed as a Pantheon child;
- `pantheon_worker` is the single Luna child role;
- Daily remains the conservative profile and does not parallelize workers;
- full Pantheon owns justified multi-worker/parallel delegation;
- no specialist roster, separate team mode, or extra effort layer has accidentally reappeared;
- migration cleanup for Pantheon-owned legacy paths remains deterministic.

When the worker model, reasoning default, or permission posture changes, update the worker definition, README, user/install/CLI guidance, tests, changelog, and milestone notes together.

## 4. Update release communication

- Move the relevant `Unreleased` entries in `CHANGELOG.md` into a dated version section.
- Keep the changelog as the canonical release history.
- Describe behavior and migration impact rather than restating every commit.
- Do not claim hosted CI, a published tag, or a GitHub release until each has actually completed.

## 5. Validate

Run:

```bash
./tests/test.sh
bash -n pantheon install.sh tests/test.sh
git diff --check
```

The regression suite exercises install, update, doctor, bootstrap, migration cleanup, and uninstall using isolated temporary homes. If the release depends on a particular Codex build, model, or provider behavior, verify that separately and record the exact environment.

Review the final diff and confirm no local configuration, credentials, temporary homes, generated operating-system files, or obsolete architecture assets are included.

## 6. Publish separately

After repository preparation is reviewed and merged, the maintainer may create the intended tag and GitHub release. This repository does not yet declare an automated release pipeline or a historical tag convention, so publication details should be chosen and verified explicitly rather than inferred from a versioned document.

After publication, verify the tag and release point to the intended commit and that fresh users can follow the documented install path from that source.
