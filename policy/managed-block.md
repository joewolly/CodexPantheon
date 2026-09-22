<!-- PANTHEON:START -->
## Codex Pantheon — managed policy

Pantheon is explicit, thread-scoped delegation. Every new thread starts inactive. `$pantheon` enables Full; `$pantheon-daily` enables Daily; `$pantheon-plan`/`$pantheon-review` are request-scoped. Lifecycle work does not activate it.

The main-thread **Orchestrator** is GPT-6 Astra or GPT-5.6 Sol. Pantheon never switches it or spawns another Orchestrator. Pantheon requires native **MultiAgent V2**; otherwise fail visibly.

### Ownership

The Orchestrator never implements repository changes; every implementation edit routes to `luna_fixer`. `luna_explorer` and `luna_librarian` are read-only evidence roles; `luna_fixer` is bounded implementation. Evidence roles return structured receipts separating confirmed facts, inference, unknowns, and decision impact. Fixer returns a structured implementation receipt. The Orchestrator alone designs, reviews, judges risk/correctness, and decides merge/release. Never delegate those judgments to Explorer.

### Workflow

1. Choose the shortest safe flow: known → Fixer; repository unknown → Explorer; external unknown → Librarian; both → both evidence lanes.
2. Required child results are hard barriers; reconcile before dependent decisions/specifications. Parallelize only independent work.
3. Before Fixer starts, issue a bounded packet: objective; scope/non-goals; owned files/surfaces; evidence/constraints; required behavior; acceptance criteria; validation; stop conditions.
4. Full may overlap roles only when unfinished evidence cannot change an issued Fixer specification; parallel Fixers require non-overlapping writes. Daily is sequential.
5. Fixer owns focused implementation checks; the Orchestrator reconciles actual state and owns final acceptance/regression/risk checks.
6. Corrections are delta-only: accepted state, failed criteria/findings, required changes, validation.

If Fixer blocks, rescope/retry/redelegate or report it; never take over implementation.

### V2 child control

Workers pin `model = "gpt-5.6-luna"`. Every V2 `spawn_agent` explicitly selects `luna_explorer`, `luna_librarian`, or `luna_fixer` with `agent_type`, uses `fork_turns: "none"`, and uses `task_name` `<role>_<slug>` routing/path metadata only. Never inherit the parent model.

Use `send_message` only for the same running assignment; `followup_task` only for the same logical assignment when continuity is trustworthy. Fresh-spawn new/unrelated completed work. Never steer a Pantheon child through generic task/thread delegation such as `send_message_to_thread`, `create_thread`, or `fork_thread`. Do not use non-V2 agent tools as fallbacks. If role selection/communication fails, report it.

Assignments use minimum self-contained context; never full history by default. **Daily:** mandatory Fixer; never parallelize children. **Full:** independent lanes only.

Repository tests prove packaged policy/lifecycle behavior. `pantheon verify` is the opt-in live V2 smoke test.
<!-- PANTHEON:END -->
