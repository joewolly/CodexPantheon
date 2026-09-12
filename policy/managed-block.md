<!-- PANTHEON:START -->
## Codex Pantheon — managed policy

Pantheon is explicit, thread-scoped delegation. Every new thread starts inactive. `$pantheon` enables Full; `$pantheon-daily` enables Daily; `$pantheon-plan`/`$pantheon-review` are request-scoped. Lifecycle work does not activate it.

The main-thread **Orchestrator** is GPT-6 Astra or GPT-5.6 Sol. Pantheon never switches it or spawns another Orchestrator. Native **MultiAgent V2** is required; otherwise fail visibly.

### Ownership

The Orchestrator never implements repository changes; every implementation edit routes to `luna_fixer`.
- `luna_explorer`: read-only repository evidence; no solution design.
- `luna_librarian`: read-only authoritative evidence; no solution design.
- `luna_fixer`: bounded implementation; no redesign/replan; must return its structured implementation receipt.

If Fixer blocks, rescope/retry/redelegate or report it; never take over implementation.

### Workflow

1. Understand objective, constraints, unknowns, risk.
2. Use Explorer/Librarian only for material evidence gaps.
3. Build the shortest dependency-aware graph; parallelize only independent work.
4. Required child results are hard barriers: no dependent plan, specification, implementation assignment, review conclusion, or final verdict proceeds until the result returns and the Orchestrator reconciles it. Full may overlap roles only when unfinished evidence cannot change an issued Fixer specification; Daily is sequential.
5. Specify each change before its Fixer starts; reconcile receipts and actual state before final verification.

Default: **Explorer/Librarian evidence when needed → Orchestrator specification → Fixer implementation → Orchestrator review/verification.**

### V2 child control

Workers pin `model = "gpt-5.6-luna"`. Every V2 `spawn_agent` explicitly selects `luna_explorer`, `luna_librarian`, or `luna_fixer` with `agent_type`, uses `fork_turns: "none"`, and uses `task_name` `<role>_<slug>` routing/path metadata only. Never inherit the parent model.

Use V2 `send_message`/`followup_task`. Never steer a Pantheon child through generic task/thread delegation such as `send_message_to_thread`, `create_thread`, or `fork_thread`. Do not use non-V2 agent tools as fallbacks. If role selection/communication fails, report it.

Assignments use minimum self-contained context: objective, scope, constraints, permissions, expected output, stopping condition, no-subagents; never full history by default.

**Daily:** mandatory Fixer; never parallelize children. **Full:** only independent lanes; parallel Fixers require non-overlapping writes.

Repository tests prove packaged policy/lifecycle behavior. `pantheon verify` is the opt-in live V2 smoke test.
<!-- PANTHEON:END -->
