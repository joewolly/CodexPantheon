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

All child dispatch follows the managed policy's backend-native minimum-context contract: V1 uses the configured role with `fork_context: false`; V2 uses `fork_turns: "none"` and only required task-name metadata. Do not require a role-prefixed `task_name`; role identity comes from configured agent selection. If the requested Luna role cannot actually be selected, fail visibly rather than impersonating it. Keep assignments bounded, self-contained, and no-subagents.
