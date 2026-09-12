# Codex Pantheon User Guide

Pantheon v0.7 has one model-neutral Orchestrator contract and three named Luna specialists. It stays inactive until you explicitly enable it. Current `main` also requires structured Fixer receipts, hard dependency reconciliation, and offers an opt-in live runtime verifier.

## 1. Choose the Orchestrator

Select the main-thread model with Codex's native model control, then invoke Pantheon.

Supported Orchestrators:

| Role | Model | Responsibility |
| --- | --- | --- |
| Orchestrator / main thread | GPT-6 Astra **or** GPT-5.6 Sol | Understand, plan, decide, schedule, delegate, reconcile, review, verify, communicate; never implement repository changes |
| `luna_explorer` | GPT-5.6 Luna High | Read-only repository reconnaissance |
| `luna_librarian` | GPT-5.6 Luna High | Read-only docs/API/upstream/reference research |
| `luna_fixer` | GPT-5.6 Luna High | Implement the Orchestrator's scoped specification and run assigned focused validation |

Pantheon does **not** automatically switch your selected main model and does not install a separate Astra or Sol child. The same installed payload works with either supported Orchestrator, so changing the selected model does not require reinstalling Pantheon.

Pantheon requires the selected Orchestrator/runtime to expose native **MultiAgent V2**. If V2 is unavailable, Pantheon fails visibly instead of switching to another control plane.

## 2. Ownership and dependency rules

The default implementation chain is:

```text
Explorer/Librarian evidence when needed
              ↓
    Orchestrator creates plan
              ↓
        Luna Fixer implements
              ↓
   Orchestrator reviews/verifies
```

Explorer and Librarian do not create the solution plan. Fixer does not independently redesign it. The Orchestrator never implements repository changes.

There is no small-change exception. Even a one-line or obvious implementation edit goes to Fixer. If Fixer cannot be spawned or complete the assignment, the Orchestrator rescopes, retries, redelegates, or reports the blocker instead of taking over implementation.

Every **required** child result is a hard dependency barrier. The Orchestrator must receive and reconcile that result before proceeding with or finalizing the dependent plan, specification, implementation assignment, review conclusion, or final verdict.

That rule is per work item, not a blanket ban on concurrency. In Full Pantheon, unrelated Explorer/Librarian/Fixer tasks may overlap when no unfinished evidence can change an already-issued Fixer specification. Daily remains fully sequential.

## 3. Operating profiles

Every new thread starts in ordinary Codex mode.

| Profile | Activate with | Delegation posture |
| --- | --- | --- |
| Ordinary Codex | default / `Stop using Pantheon.` | No Pantheon routing |
| Pantheon Daily | `$pantheon-daily` | Conservative specialist use, sequential only |
| Full Pantheon | `$pantheon` | More aggressive specialist use, dependency-safe parallelism allowed |

The selected Pantheon profile is sticky only inside the current thread. Nothing persists across threads.

### Daily

Daily saves usage by avoiding unnecessary evidence delegation. It has no numeric worker-call ceiling; Fixer remains mandatory for implementation.

- Evidence already sufficient: `Orchestrator plan → Fixer → Orchestrator review`.
- Repository evidence missing: `Explorer → Orchestrator plan → Fixer → Orchestrator review`.
- External/reference evidence missing: `Librarian → Orchestrator plan → Fixer → Orchestrator review`.
- Both necessary: use both sequentially, reconcile both, then plan, then Fixer.
- No parallel child calls.

### Full Pantheon

Full Pantheon uses the same ownership boundaries. It can parallelize genuinely independent Explorer/Librarian evidence lanes and independent Fixer workstreams with non-overlapping write ownership.

It can also overlap roles across **different independent work items**. For example, a Fixer whose specification is already complete may run while an Explorer researches a separate subsystem. It may not start a Fixer while unfinished evidence could still change that Fixer's specification.

## 4. Luna lanes

### `luna_explorer`

Use for repository mapping, symbols, code paths, state transitions, dependencies, ownership, and exact implementation locations. It is hard read-only and returns compressed evidence to the Orchestrator.

### `luna_librarian`

Use for official docs, API contracts, upstream repositories, standards, release notes, version-specific behavior, and authoritative examples. It is hard read-only and returns compressed evidence to the Orchestrator.

### `luna_fixer`

Fixer receives the Orchestrator's implementation specification. It may inspect enough local code to execute that plan, choose exact edit points/order, make small tactical adaptations that preserve the plan, edit scoped files, and run assigned validation.

If execution exposes a material architecture/product decision or contradicts the plan, Fixer stops and returns the issue instead of silently replanning.

Every Fixer return is a **structured implementation receipt**:

- `Status`: `completed`, `partial`, or `blocked`;
- `Summary`: concise implementation result;
- `Files/changes`: every touched file and material change;
- `Validation`: each check marked `PASS`, `FAIL`, `SKIPPED`, or `UNKNOWN` with concise evidence;
- `Deviations/blockers`: any divergence or unresolved ambiguity, or `none`;
- `Parent verification`: what the Orchestrator must independently inspect or verify.

The Orchestrator reconciles that receipt against actual repository state. A bare Fixer claim such as “done” is not sufficient completion evidence.

## 5. Planning and review workflows

`$pantheon-plan` is planning-only. The main-thread Orchestrator owns the plan and may use Explorer/Librarian for read-only evidence. Fixer is not used. A required evidence result must return and be reconciled before the dependent portion of the plan is finalized.

`$pantheon-review` is review-only. The main-thread Orchestrator owns the review/verdict and may use Explorer/Librarian for read-only evidence. Fixer is not used unless you separately leave review mode and request fixes. A required evidence result must be reconciled before the dependent finding or verdict is finalized.

These workflows do not activate a sticky Pantheon profile by themselves.

## 6. V2 control plane and Luna workers

Pantheon uses one control plane: the selected Astra/Sol Orchestrator's native MultiAgent V2 surface.

Every spawn:

- uses native V2 `spawn_agent`;
- explicitly sets `agent_type` to `luna_explorer`, `luna_librarian`, or `luna_fixer`;
- uses `fork_turns: "none"`;
- supplies only the concise `task_name` required as routing/path metadata.

Pantheon formats the V2 `task_name` as `<role>_<concise_task_slug>` so Codex's current Subagents list makes the worker lane visible. Use `explorer`, `librarian`, or `fixer` to match the selected `agent_type`, for example:

```text
fixer_v020_implement
explorer_v020_versions
librarian_v020_release_map
```

The configured role files pin `model = "gpt-5.6-luna"` and high reasoning, so Luna remains the worker model. `agent_type` is authoritative; the role prefix in `task_name` is display/path metadata only and does not select the role or model.

After spawn, parent-mediated coordination stays on the V2 agent plane:

- `send_message` passes information to a running worker without treating it as a normal Desktop task;
- `followup_task` gives an existing worker another unit of work and triggers the appropriate turn.

Pantheon does not use generic task/thread delegation such as `send_message_to_thread`, `create_thread`, `fork_thread`, or direct task turn/resume calls to steer a Pantheon child. It does not fall back to legacy/non-V2 agent primitives.

If V2 configured-role selection or V2 communication cannot be honored, Pantheon reports the runtime limitation. It does not silently substitute another control path or blindly respawn work that may already have executed.

Every child receives a minimum self-contained bounded assignment: objective, scope, known constraints/facts, permissions, expected evidence/output, stopping condition, and a no-subagents instruction. Full-history inheritance is never the default.

A separate child composer is optional Codex Desktop UI behavior. Pantheon coordinates through the parent and does not depend on a user-editable child composer.

The Orchestrator remains the main thread; Pantheon does not spawn a display-only Orchestrator child.

## 7. Install, update, repair, verify, remove

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

`bootstrap` installs/refreshes Pantheon-owned state and runs static `doctor`. Lifecycle commands do not activate Pantheon.

Static integrity check:

```bash
./pantheon doctor
```

```powershell
.\pantheon.ps1 doctor
```

Opt-in **live** runtime check:

```bash
./pantheon verify
```

```powershell
.\pantheon.ps1 verify
```

`verify` consumes one real Codex parent turn and one Luna Explorer child turn. It checks actual V2 spawn/correlation evidence, effective Luna High execution, the exact child/parent result, and `fork_turns: "none"` isolation. Temporary verifier artifacts are cleaned on success/failure, but the real Codex parent/child session rollouts remain in the user's normal Codex session store.

Remove Pantheon only when intended:

```bash
./pantheon uninstall
```

```powershell
.\pantheon.ps1 uninstall
```

## 8. Upgrade from v0.6

v0.7 keeps the same three Luna files and four skills. Bootstrap refreshes their model-neutral, context-compacted contracts and the managed policy block while preserving unrelated Codex configuration. The Luna model/effort settings remain GPT-5.6 Luna High in this release so the Orchestrator change is isolated from worker-tuning changes.
