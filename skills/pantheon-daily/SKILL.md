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

Every child dispatch explicitly selects the configured Luna role with `agent_type`; never inherit the Astra/Sol model. V1 parent transport uses `fork_context: false`; V2 parent transport uses `fork_turns: "none"` plus only required concise task metadata. The resulting worker must resolve to GPT-5.6 Luna. If configured-role selection cannot be honored, fail visibly rather than creating a generic child. Keep assignments bounded, self-contained, and no-subagents.
