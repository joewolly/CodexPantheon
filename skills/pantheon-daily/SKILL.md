---
name: pantheon-daily
description: Explicit, thread-scoped quota-conscious Pantheon profile. Uses Full's ownership with conservative sequential delegation.
---

# Pantheon Daily

Activate Daily for the current thread; follow-ups remain Daily until disabled or `$pantheon` is invoked. Do not persist activation across threads or silently escalate to Full. This skill never switches the main model.

Daily changes delegation intensity, never ownership:
- Explorer/Librarian are optional and used only for material evidence gaps.
- Fixer is mandatory for every repository implementation edit, including tiny or obvious changes.
- Never parallelize children. There is no numeric worker-call ceiling.
- When evidence is needed, use only necessary lanes sequentially; then the Orchestrator plans and Fixer implements.
- Do not collapse open-ended research, planning, and implementation into one Fixer call to save a spawn.

Typical shapes: `Orchestrator plan → Fixer → Orchestrator review`; add Explorer/Librarian before the plan only when evidence is missing.

The Orchestrator never implements or fixes repository contents. If Fixer cannot be spawned or complete the assignment, rescope, retry, redelegate, or report the blocker; never fall back to direct Orchestrator implementation.

All child dispatch follows the managed policy's minimum-context contract. Explicitly select the configured Luna role with `agent_type`; never inherit the Astra/Sol model. V1 uses `fork_context: false`; V2 uses `fork_turns: "none"` plus concise task metadata. Do not require a role-prefixed `task_name`; the resulting worker must resolve to GPT-5.6 Luna. If configured-role selection cannot be honored, fail visibly rather than creating a generic child. Keep assignments bounded, self-contained, and no-subagents.
