# Releasing Codex Pantheon

This checklist keeps the source package, installed payload, documentation, and release metadata aligned. It defines the repository-side preparation process; publishing a tag or GitHub release remains a separate maintainer action.

## 1. Confirm scope and state

- Start from the intended base branch and fetch current remote state.
- Confirm the worktree contains only the intended release changes.
- Review user-visible changes, compatibility implications, install/update behavior, and uninstall behavior.
- Decide whether the change needs a milestone note such as `docs/Vx.y.z.md`. Patch releases do not need a dedicated note unless the behavior warrants one.

## 2. Synchronize the version

Update every source of the release version:

- `VERSION`;
- the `VERSION` constant in `pantheon`;
- version-specific expectations in `tests/test.sh`;
- `CHANGELOG.md`;
- the README's current-release summary when its behavior changed.

Search the repository for the previous version afterward to catch stale user-visible or test references.

## 3. Synchronize the operating contract

When activation, effort, delegation, or lifecycle behavior changes, inspect every surface that repeats that contract:

- `skills/pantheon/SKILL.md`;
- `policy/managed-block.md`;
- repository `AGENTS.md`;
- `README.md` and relevant files under `docs/`;
- `tests/test.sh`.

When the role roster, model assignments, or reasoning defaults change, also inspect:

- `agents/*.toml`;
- the README role table;
- changelog or milestone notes;
- the architecture image labels and source assets, if applicable.

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

The regression suite exercises install, update, doctor, bootstrap, and uninstall using isolated temporary homes. If the release depends on a particular Codex build, model, or provider behavior, verify that separately and record the exact environment.

Review the final diff and confirm no local configuration, credentials, temporary homes, or generated operating-system files are included.

## 6. Publish separately

After repository preparation is reviewed and merged, the maintainer may create the intended tag and GitHub release. This repository does not yet declare an automated release pipeline or a historical tag convention, so publication details should be chosen and verified explicitly rather than inferred from a versioned document.

After publication, verify the tag and release point to the intended commit and that fresh users can follow the documented install path from that source.
