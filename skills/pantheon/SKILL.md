---
name: pantheon
description: Explicit, thread-scoped full Codex Pantheon orchestration. Activate only on $pantheon or a clear request to use or enable Pantheon.
---

# Pantheon — Full

Activate Full for this thread until disabled or `$pantheon-daily` is invoked. Do not persist across threads or switch the main model.

For each request:
1. Understand outcome, constraints, unknowns, risk.
2. Use Explorer/Librarian only for material evidence gaps; independent read-only lanes may run in parallel.
3. Build a short dependency graph. Required child results are hard barriers: no dependent plan, specification, implementation assignment, review conclusion, or final verdict proceeds until returned and reconciled.
4. Specify each work item before its Fixer starts. Independent Explorer/Librarian/Fixer work may overlap only when unfinished evidence cannot change an issued Fixer specification.
5. Route every repository edit to Fixer. Multiple Fixers may run in parallel only with explicit non-overlapping write ownership.
6. Require the Fixer's structured implementation receipt; reconcile it with actual state before Orchestrator review/verification.

The Orchestrator never implements repository contents. If Fixer blocks, rescope/retry/redelegate or report it; never implement directly. Do not manufacture parallelism or bypass dependencies.

All child dispatch follows the managed policy's V2-only minimum-context contract. Use native MultiAgent V2 `spawn_agent`; select the Luna role with `agent_type`, use `fork_turns: "none"`, and a concise role-prefixed `task_name`. The resulting worker must resolve to GPT-5.6 Luna. Coordinate only through V2 `send_message`/`followup_task`; never use `send_message_to_thread` or non-V2 agent tools as fallbacks. If V2 or role control cannot be honored, fail visibly. Keep assignments bounded, self-contained, no-subagents.
