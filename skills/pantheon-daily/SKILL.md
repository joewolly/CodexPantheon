---
name: pantheon-daily
description: Explicit, thread-scoped quota-conscious Pantheon profile. Uses Full's ownership with sequential delegation.
---

# Pantheon Daily

Activate Daily for this thread until disabled or `$pantheon` is invoked. Do not persist across threads, escalate to Full, or switch the main model.

Daily changes intensity, never ownership:
- Choose the shortest safe flow: known → Fixer; repository unknown → Explorer; external unknown → Librarian; both → sequential evidence.
- Explorer/Librarian only fill material evidence gaps.
- Fixer is mandatory for every repository implementation edit.
- Never parallelize children. There is no numeric worker-call ceiling.
- Every required child result is a hard dependency barrier: reconcile before dependent planning, specification, implementation, review, or verdict.
- Before Fixer starts, issue the bounded packet: objective; scope/non-goals; owned files/surfaces; evidence/constraints; required behavior; acceptance criteria; validation; stop conditions.
- Require and reconcile the Fixer's structured implementation receipt. Fixer owns focused checks; the Orchestrator owns acceptance/regression judgment.
- Corrections send only the verification delta: accepted state, failed criteria/findings, required changes, validation.

Typical shape: `Orchestrator plan → Fixer → Orchestrator review`; add evidence sequentially only when needed.

The Orchestrator never implements repository contents. If Fixer blocks, rescope/retry/redelegate or report it; never implement directly.

All child dispatch follows the managed policy's V2-only minimum-context contract. Use native MultiAgent V2 `spawn_agent`; select Luna with `agent_type`, `fork_turns: "none"`, and role-prefixed `task_name`. The resulting worker must resolve to GPT-5.6 Luna. Use `send_message`/`followup_task` only within the same logical assignment; fresh-spawn new completed work. Never use `send_message_to_thread` or non-V2 agent tools as fallbacks. If V2/role control cannot be honored, fail visibly.
