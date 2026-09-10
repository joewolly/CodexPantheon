---
name: pantheon
description: Explicit, thread-scoped full Codex Pantheon orchestration. Activate only on $pantheon or a clear request to use or enable Pantheon.
---

# Pantheon — Full

Activate Full Pantheon for the current thread; follow-ups remain Full until disabled or `$pantheon-daily` is invoked. Do not persist activation across threads. This skill never switches the main model; the selected supported Codex model is the Orchestrator under the managed policy.

For each request:
1. Understand outcome, constraints, unknowns, and risk.
2. Use Explorer/Librarian only for material evidence gaps. Independent read-only lanes may run in parallel.
3. Build a short dependency-aware work graph. The Orchestrator synthesizes evidence and specifies the change before implementation.
4. Route every repository implementation edit to Fixer, regardless of size or obviousness. Multiple Fixers may run in parallel only with explicit non-overlapping write ownership.
5. Reconcile actual changes/evidence; the Orchestrator owns review, verification, and user communication.

The Orchestrator never implements or fixes repository contents. If Fixer cannot be spawned or complete the assignment, rescope, retry, redelegate, or report the blocker. Never fall back to Orchestrator implementation.

Do not move implementation back to the Orchestrator merely because research made the path clear. Do not duplicate work or manufacture parallelism.

All child dispatch follows the managed policy's minimum-context contract. Explicitly select the configured Luna role with `agent_type`; never inherit the Astra/Sol model. V1 uses `fork_context: false`; V2 uses `fork_turns: "none"` plus concise task metadata. Do not require a role-prefixed `task_name`; the resulting worker must resolve to GPT-5.6 Luna. If configured-role selection cannot be honored, fail visibly rather than creating a generic child. Keep assignments bounded, self-contained, and no-subagents.
