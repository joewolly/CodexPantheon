---
name: pantheon
description: Explicit, thread-scoped full Codex Pantheon orchestration. Activate only on $pantheon or a clear request to use or enable Pantheon.
---

# Pantheon — Full

Activate Full for this thread until disabled or `$pantheon-daily` is invoked. Do not persist across threads or switch the main model.

For each request:
1. Choose the shortest safe flow: known → Fixer; repository unknown → Explorer; external unknown → Librarian; both → both. Use only evidence that can change a decision/specification.
2. Reconcile required evidence receipts before dependent work. Independent read-only lanes may run in parallel.
3. Build a short dependency graph. Required child results are hard barriers: no dependent plan, specification, implementation assignment, review conclusion, or verdict proceeds until returned and reconciled.
4. Before Fixer starts, issue a bounded packet: objective; scope/non-goals; owned files/surfaces; confirmed evidence/constraints; required behavior; acceptance criteria; focused validation; stop conditions.
5. Route every repository edit to Fixer. Multiple Fixers may run in parallel only with explicit non-overlapping write ownership; unfinished evidence must not change an issued packet.
6. Require the Fixer's structured implementation receipt and reconcile actual state. Fixer owns focused checks; the Orchestrator owns final acceptance, regression/risk checks, and merge/release judgment.
7. For corrections, send only the verification delta: accepted state, failed criteria/findings, required changes, validation.

The Orchestrator never implements repository contents. If Fixer blocks, rescope/retry/redelegate or report it; never implement directly.

All child dispatch follows the managed policy's V2-only minimum-context contract. Use native MultiAgent V2 `spawn_agent`; select Luna with `agent_type`, `fork_turns: "none"`, and role-prefixed `task_name`. The resulting worker must resolve to GPT-5.6 Luna. Use `send_message`/`followup_task` only within the same logical assignment; fresh-spawn unrelated or new completed work. Never use `send_message_to_thread` or non-V2 agent tools as fallbacks. If V2/role control cannot be honored, fail visibly. Keep assignments bounded, self-contained, no-subagents.
