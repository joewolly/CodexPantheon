# Codex Pantheon User Guide

Pantheon v0.6 has one orchestrator and three named Luna specialists. It stays inactive until you explicitly enable it.

## 1. Roles

| Role | Model | Responsibility |
| --- | --- | --- |
| Astra / main thread | GPT-6 Astra | Orchestrate, gather evidence, make architecture/product decisions, create implementation specs, reconcile, review, verify, communicate |
| `luna_explorer` | GPT-5.6 Luna High | Read-only repository reconnaissance |
| `luna_librarian` | GPT-5.6 Luna High | Read-only docs/API/upstream/reference research |
| `luna_fixer` | GPT-5.6 Luna High | Implement Astra's scoped specification and run assigned focused validation |

Astra is not installed as a subagent and Pantheon does not automatically switch your selected main model.

## 2. The ownership rule

The normal implementation chain is:

```text
Explorer/Librarian evidence when needed
              ↓
       Astra creates plan
              ↓
        Luna Fixer implements
              ↓
       Astra reviews/verifies
```

Explorer and Librarian do not create the solution plan. Fixer does not independently redesign it. Astra is not the default implementation worker.

Astra may directly do one isolated, obvious, low-risk action when delegation overhead would exceed execution.

## 3. Operating profiles

Every new thread starts in ordinary Codex mode.

| Profile | Activate with | Delegation posture |
| --- | --- | --- |
| Ordinary Codex | default / `Stop using Pantheon.` | No Pantheon routing |
| Pantheon Daily | `$pantheon-daily` | Conservative specialist use, sequential only |
| Full Pantheon | `$pantheon` | More aggressive specialist use, justified parallelism allowed |

The selected profile is sticky only in the current thread. Nothing persists across threads.

### Daily

Daily saves usage by avoiding unnecessary delegation. It does **not** use the old v0.5 `0-1` worker-call ceiling.

- If Astra already understands the implementation: `Astra plan → Fixer → Astra review`.
- If repository evidence is missing: `Explorer → Astra plan → Fixer → Astra review`.
- If current external/reference evidence is missing: `Librarian → Astra plan → Fixer → Astra review`.
- If both are necessary, use both sequentially, then Astra plans, then Fixer implements.
- No parallel child calls in Daily.

### Full Pantheon

Full Pantheon uses the same ownership boundaries. Astra can parallelize genuinely independent Explorer/Librarian lanes and independent Fixer workstreams with non-overlapping write ownership.

## 4. What each Luna agent may do

### `luna_explorer`

Use for repository mapping, symbols, code paths, state transitions, dependencies, ownership, and finding exact implementation locations. It is hard read-only and reports evidence to Astra.

### `luna_librarian`

Use for official docs, API contracts, upstream repositories, standards, release notes, version-specific behavior, and authoritative examples. It is hard read-only and reports evidence to Astra.

### `luna_fixer`

Fixer receives Astra's implementation specification. It can inspect local code enough to execute the plan, choose exact edit points/order, make small tactical adaptations that preserve the plan, edit scoped files, and run assigned validation.

If execution reveals a material architecture/product decision or contradicts Astra's plan, Fixer stops and returns the issue to Astra rather than silently replanning.

## 5. Planning and review workflows

`$pantheon-plan` is planning-only. Astra owns the plan and may use Explorer/Librarian for read-only evidence. Fixer is not used.

`$pantheon-review` is review-only. Astra owns the review/verdict and may use Explorer/Librarian for read-only evidence. Fixer is not used unless you separately ask to leave review mode and implement fixes.

These workflows do not activate a sticky Pantheon profile by themselves.

## 6. Context discipline

Every child spawn defaults to `fork_turns: "none"` with a self-contained bounded assignment. Astra gives the child only the objective, scope, constraints/context, permissions, expected evidence/output, stopping condition, and prohibition on subagents that it needs.

Never use full-history inheritance by default.

## 7. Install, update, repair, remove

Ask Codex:

```text
Install Codex Pantheon for me.
```

or run:

```bash
./pantheon bootstrap   # install/update + doctor
./pantheon doctor      # read-only verification
./pantheon uninstall   # remove Pantheon-owned current + legacy paths
```

Lifecycle commands do not activate Pantheon.

## 8. Upgrade from v0.5

`./pantheon bootstrap` removes the v0.5 `pantheon-worker.toml`, installs `luna-explorer.toml`, `luna-librarian.toml`, and `luna-fixer.toml`, refreshes the four skills, and replaces the managed policy block.

The older v0.4 Pantheon specialist filenames and `pantheon-team` are also removed as Pantheon-owned legacy paths. Unrelated Codex configuration remains untouched.
