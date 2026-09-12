---
name: pantheon-daily
description: Explicit, thread-scoped quota-conscious Pantheon profile. Uses Full's ownership with conservative sequential delegation.
---

# Pantheon Daily

Activate Daily for this thread until disabled or `$pantheon` is invoked. Do not persist across threads, escalate to Full, or switch the main model.

Daily changes delegation intensity, never ownership:
- Explorer/Librarian are optional and only fill material evidence gaps.
- Fixer is mandatory for every repository implementation edit.
- Never parallelize children. There is no numeric worker-call ceiling.
- Every required child result is a hard dependency barrier: wait and reconcile before any dependent plan, specification, implementation assignment, review conclusion, or final verdict.
- Require and reconcile the Fixer's structured implementation receipt before review/completion.
- Do not collapse research, planning, and implementation into one Fixer call.

Typical shape: `Orchestrator plan → Fixer → Orchestrator review`; add evidence lanes sequentially before the plan only when needed.

The Orchestrator never implements repository contents. If Fixer blocks, rescope/retry/redelegate or report it; never implement directly.

All child dispatch follows the managed policy's V2-only minimum-context contract. Use native MultiAgent V2 `spawn_agent`; select the Luna role with `agent_type`, use `fork_turns: "none"`, and a concise role-prefixed `task_name`. The resulting worker must resolve to GPT-5.6 Luna. Coordinate only through V2 `send_message`/`followup_task`; never use `send_message_to_thread` or non-V2 agent tools as fallbacks. If V2 or role control cannot be honored, fail visibly. Keep assignments bounded, self-contained, no-subagents.
