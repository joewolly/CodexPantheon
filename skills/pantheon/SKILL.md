---
name: pantheon
description: Explicit, thread-scoped full Codex Pantheon orchestration. Activate only on $pantheon or a clear request to use or enable Pantheon.
---

# Pantheon — Full

Activate Full Pantheon for the current thread; follow-ups remain Full until disabled or `$pantheon-daily` is invoked. Do not persist activation across threads. This skill never switches the main model; the selected supported Codex model is the Orchestrator under the managed policy.

For each request:
1. Understand outcome, constraints, unknowns, and risk.
2. Use Explorer/Librarian only for material evidence gaps. Independent read-only lanes may run in parallel.
3. Build a short dependency-aware work graph. Treat every required child result as a hard barrier: do not make or finalize any dependent plan, specification, implementation assignment, review conclusion, or final verdict until that result has returned and been reconciled.
4. The Orchestrator synthesizes all evidence required by a work item and specifies that change before its Fixer begins. Independent work items may overlap across Explorer/Librarian/Fixer only when unfinished evidence cannot change an already-issued Fixer specification.
5. Route every repository implementation edit to Fixer, regardless of size or obviousness. Multiple Fixers may run in parallel only with explicit non-overlapping write ownership.
6. Require each Fixer structured implementation receipt, reconcile it against actual changes/evidence, resolve deviations/blockers, and perform Orchestrator review/verification before user communication.

The Orchestrator never implements or fixes repository contents. If Fixer cannot be spawned or complete the assignment, rescope, retry, redelegate, or report the blocker. Never fall back to Orchestrator implementation.

Do not move implementation back to the Orchestrator merely because research made the path clear. Do not duplicate work, manufacture parallelism, or proceed past an unresolved dependency merely because another lane is ready.

All child dispatch follows the managed policy's V2-only minimum-context contract. Use native MultiAgent V2 `spawn_agent`; explicitly select the configured Luna role with `agent_type`, use `fork_turns: "none"`, and use concise `explorer_`/`librarian_`/`fixer_`-prefixed `task_name` routing metadata. The resulting worker must resolve to GPT-5.6 Luna. Continue worker coordination only through native V2 `send_message`/`followup_task`; never use generic `send_message_to_thread` or non-V2 agent tools as fallbacks. If V2 or configured-role selection/communication cannot be honored, fail visibly. Keep assignments bounded, self-contained, and no-subagents.
