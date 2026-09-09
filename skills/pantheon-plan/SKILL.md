---
name: pantheon-plan
description: Explicit Pantheon planning workflow. Use only when the user invokes $pantheon-plan or explicitly asks Pantheon to plan without implementation.
---

# Pantheon Plan

Run one planning-only request, then resume any previously active Daily/Full profile. This skill does not activate Pantheon, switch the main model, or modify production state.

The selected supported main-thread model is the Orchestrator and owns decomposition, architecture, tradeoffs, sequencing, risks, validation design, and the final plan. Use Explorer only for material repository unknowns and Librarian only for material authoritative external/reference unknowns. Both remain read-only evidence lanes; **do not use Fixer**.

Gather only enough evidence to resolve the plan. The Orchestrator then returns one actionable plan covering behavior, approach, scope/ownership, sequencing, validation criteria, material risks, migration/rollback concerns when relevant, and unresolved decisions only where evidence cannot resolve them.

All evidence dispatch follows the managed policy's minimum-context, `fork_turns: "none"`, bounded-assignment, no-subagents, and role-prefixed `task_name` contract.
