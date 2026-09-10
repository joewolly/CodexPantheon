# Codex Pantheon User Guide

Pantheon v0.7 has one model-neutral Orchestrator contract and three named Luna specialists. It stays inactive until you explicitly enable it.

## 1. Choose the Orchestrator

Select the main-thread model with Codex's native model control, then invoke Pantheon.

Supported Orchestrators:

| Role | Model | Responsibility |
| --- | --- | --- |
| Orchestrator / main thread | GPT-6 Astra **or** GPT-5.6 Sol | Understand, plan, decide, delegate, reconcile, review, verify, communicate |
| `luna_explorer` | GPT-5.6 Luna High | Read-only repository reconnaissance |
| `luna_librarian` | GPT-5.6 Luna High | Read-only docs/API/upstream/reference research |
| `luna_fixer` | GPT-5.6 Luna High | Implement the Orchestrator's scoped specification and run assigned focused validation |

Pantheon does **not** automatically switch your selected main model and does not install a separate Astra or Sol child. The same installed payload works with either supported Orchestrator, so changing the selected model does not require reinstalling Pantheon.

This is intentionally more reliable and cheaper than keeping a second Pantheon model selector: Codex remains the source of truth for which model is actually running.

## 2. Ownership rule

The normal implementation chain is:

```text
Explorer/Librarian evidence when needed
              ↓
    Orchestrator creates plan
              ↓
        Luna Fixer implements
              ↓
   Orchestrator reviews/verifies
```

Explorer and Librarian do not create the solution plan. Fixer does not independently redesign it. The Orchestrator is not the default implementation worker.

The Orchestrator may directly do one isolated, obvious, low-risk action when delegation overhead would exceed execution.

## 3. Operating profiles

Every new thread starts in ordinary Codex mode.

| Profile | Activate with | Delegation posture |
| --- | --- | --- |
| Ordinary Codex | default / `Stop using Pantheon.` | No Pantheon routing |
| Pantheon Daily | `$pantheon-daily` | Conservative specialist use, sequential only |
| Full Pantheon | `$pantheon` | More aggressive specialist use, justified parallelism allowed |

The selected Pantheon profile is sticky only inside the current thread. Nothing persists across threads.

### Daily

Daily saves usage by avoiding unnecessary delegation. It has no numeric worker-call ceiling.

- Evidence already sufficient: `Orchestrator plan → Fixer → Orchestrator review`.
- Repository evidence missing: `Explorer → Orchestrator plan → Fixer → Orchestrator review`.
- External/reference evidence missing: `Librarian → Orchestrator plan → Fixer → Orchestrator review`.
- Both necessary: use both sequentially, then plan, then Fixer.
- No parallel child calls.

### Full Pantheon

Full Pantheon uses the same ownership boundaries. It may parallelize genuinely independent Explorer/Librarian lanes and independent Fixer workstreams with non-overlapping write ownership.

## 4. Luna lanes

### `luna_explorer`

Use for repository mapping, symbols, code paths, state transitions, dependencies, ownership, and exact implementation locations. It is hard read-only and returns compressed evidence to the Orchestrator.

### `luna_librarian`

Use for official docs, API contracts, upstream repositories, standards, release notes, version-specific behavior, and authoritative examples. It is hard read-only and returns compressed evidence to the Orchestrator.

### `luna_fixer`

Fixer receives the Orchestrator's implementation specification. It may inspect enough local code to execute that plan, choose exact edit points/order, make small tactical adaptations that preserve the plan, edit scoped files, and run assigned validation.

If execution exposes a material architecture/product decision or contradicts the plan, Fixer stops and returns the issue instead of silently replanning.

## 5. Planning and review workflows

`$pantheon-plan` is planning-only. The main-thread Orchestrator owns the plan and may use Explorer/Librarian for read-only evidence. Fixer is not used.

`$pantheon-review` is review-only. The main-thread Orchestrator owns the review/verdict and may use Explorer/Librarian for read-only evidence. Fixer is not used unless you separately leave review mode and request fixes.

These workflows do not activate a sticky Pantheon profile by themselves.

## 6. Luna V1 workers and parent transport

Pantheon workers are always explicitly selected configured Luna roles. Pantheon dispatch explicitly selects the requested Luna role on every spawn. Their role files pin `model = "gpt-5.6-luna"`, and current Codex model metadata marks GPT-5.6 Luna as MultiAgent V1.

Astra or Sol can still expose a V2 `spawn_agent` call because V1/V2 on that call describes the **parent Orchestrator's collaboration surface**. It does not mean the child should inherit Astra/Sol.

- Every spawn explicitly sets `agent_type` to `luna_explorer`, `luna_librarian`, or `luna_fixer`.
- On a **V1 parent surface**, Pantheon uses `fork_context: false`.
- On a **V2 parent surface**, Pantheon uses `fork_turns: "none"` and supplies the required concise `task_name` only as routing/path metadata.
- Pantheon never omits configured-role selection and allows the child to inherit the Astra/Sol parent model.

A task label such as `luna_fixer_something` does **not** make a child Luna. Role/model identity comes from the configured agent selection. If Codex cannot expose or honor the requested Luna role, Pantheon reports that limitation instead of silently substituting a generic/inherited worker.

Every child receives a minimum self-contained bounded assignment: objective, scope, known constraints/facts, permissions, expected evidence/output, stopping condition, and a no-subagents instruction. Full-history inheritance is never the default.

Whether the resulting Luna child has its own message composer is controlled by Codex Desktop/runtime. Pantheon does not claim direct steering unless the UI actually exposes that composer.

The Orchestrator remains the main thread; Pantheon does not spawn a display-only Orchestrator child.

## 7. Install, update, repair, remove

Ask Codex:

```text
Install Codex Pantheon for me.
```

or use the platform lifecycle command:

```bash
./pantheon bootstrap
```

```powershell
.\pantheon.ps1 bootstrap
```

Lifecycle commands do not activate Pantheon.

## 8. Upgrade from v0.6

v0.7 keeps the same three Luna files and four skills. Bootstrap refreshes their model-neutral, context-compacted contracts and the managed policy block while preserving unrelated Codex configuration. The Luna model/effort settings remain GPT-5.6 Luna High in this release so the Orchestrator change is isolated from worker-tuning changes.
