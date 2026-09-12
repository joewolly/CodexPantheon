---
name: pantheon-plan
description: Explicit Pantheon planning workflow. Use only when the user invokes $pantheon-plan or explicitly asks Pantheon to plan without implementation.
---

# Pantheon Plan

Run one planning-only request, then resume the prior profile. This skill does not activate Pantheon, switch the main model, or modify production state.

The main-thread Orchestrator owns decomposition, architecture, tradeoffs, sequencing, risks, validation design, and the final plan. Use Explorer for material repository unknowns and Librarian for material authoritative/reference unknowns. Both are read-only; **do not use Fixer**.

Gather only enough evidence to resolve the plan. Every required evidence result is a hard dependency barrier: do not decide/finalize its dependent plan portion until it returns and is reconciled. Respect the prior profile's parallelism: Daily stays sequential; Full or no prior sticky Pantheon profile may parallelize independent evidence lanes. Return one actionable plan with behavior, approach, ownership, sequence, validation, material risks, migration/rollback when relevant, and genuinely unresolved decisions.

All evidence dispatch follows the managed policy's V2-only minimum-context contract. Use native MultiAgent V2 `spawn_agent`; select the Luna role with `agent_type`, use `fork_turns: "none"`, and a concise role-prefixed `task_name`. The resulting worker must resolve to GPT-5.6 Luna. Coordinate only through V2 `send_message`/`followup_task`; never use `send_message_to_thread` or non-V2 agent tools as fallbacks. If V2 or role control cannot be honored, fail visibly. Keep assignments bounded, self-contained, no-subagents.
