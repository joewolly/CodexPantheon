---
name: pantheon-daily
description: Explicit, thread-scoped quota-conscious Pantheon profile. Uses the same Orchestrator/Explorer/Librarian/Fixer ownership as Full with conservative sequential delegation.
---

# Pantheon Daily

Activate Daily for the current thread; follow-ups remain Daily until the user disables Pantheon or invokes `$pantheon`. Do not persist activation across threads or silently escalate to Full. This skill never switches the main model.

Daily changes delegation intensity, never ownership:
- Delegate only when a specialist materially reduces parent context, uncertainty, or execution effort.
- Never parallelize children. There is no numeric worker-call ceiling.
- Skip Explorer/Librarian when evidence is already sufficient.
- When evidence is needed, use only the necessary lane(s) sequentially; then the Orchestrator plans and Fixer implements.
- Do not collapse open-ended research, planning, and implementation into one Fixer call merely to save a spawn.

Typical shapes: `Orchestrator plan → Fixer → Orchestrator review`; add Explorer and/or Librarian before the plan only when evidence is missing.

All child dispatch follows the managed policy's minimum-context, `fork_turns: "none"`, bounded-assignment, no-subagents, and role-prefixed `task_name` contract.
