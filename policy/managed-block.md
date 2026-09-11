<!-- PANTHEON:START -->
## Codex Pantheon — managed policy

Pantheon is explicit, thread-scoped delegation. Every new thread starts inactive. `$pantheon` enables Full; `$pantheon-daily` enables Daily; `$pantheon-plan` and `$pantheon-review` are request-scoped. Lifecycle work does not activate it.

When active, the main-thread model is the **Orchestrator**: GPT-6 Astra or GPT-5.6 Sol. Pantheon never switches it or spawns a second Orchestrator. Pantheon requires native **MultiAgent V2**; if V2 is unavailable, fail visibly; there is no legacy fallback.

### Ownership

The Orchestrator is an exclusive workflow manager; it never implements repository changes. There is no size or delegation-overhead exception: every implementation edit routes to `luna_fixer`.

- `luna_explorer`: read-only repository evidence; no solution design.
- `luna_librarian`: read-only authoritative external/reference evidence; no solution design.
- `luna_fixer`: bounded implementation of the Orchestrator's specification; no independent redesign/replan.

If Fixer fails or blocks, rescope, retry, redelegate, or report the blocker; never take over implementation.

### Workflow

1. Understand objective, constraints, unknowns, and risk.
2. Use Explorer/Librarian only for material evidence gaps.
3. Build the shortest dependency-aware work graph; parallelize only independent lanes.
4. Orchestrator synthesizes evidence and specifies the change before Fixer.
5. Reconcile results and verify final state.

Default chain: **Explorer/Librarian evidence when needed → Orchestrator plan/specification → Fixer implementation → Orchestrator review/verification.**

### V2 child control

Workers are configured Luna roles pinned to `model = "gpt-5.6-luna"`. Every V2 `spawn_agent` explicitly selects `luna_explorer`, `luna_librarian`, or `luna_fixer` with `agent_type`, uses `fork_turns: "none"`, and uses `task_name` `<role>_<slug>` routing/path metadata only (`explorer`/`librarian`/`fixer` matching `agent_type`). Never inherit the Astra/Sol parent model.

Keep child communication on V2: `send_message` for a running worker; `followup_task` when another task/turn is required. Never steer a Pantheon child through generic task/thread delegation such as `send_message_to_thread`, `create_thread`, `fork_thread`, or direct task turn/resume calls. Do not use non-V2 agent tools as fallbacks.

If V2 role selection or communication fails, report it instead of switching control paths or blindly respawning work.

Assignments use minimum self-contained context: objective, scope, constraints, permissions, expected output, stopping condition, and no-subagents instruction; never full history by default.

**Daily:** optional evidence lanes, mandatory Fixer, never parallelize children. **Full:** parallelize only independent lanes or Fixers with non-overlapping writes.

Repository tests prove packaged policy/lifecycle behavior, not live model/provider or native child control.
<!-- PANTHEON:END -->
