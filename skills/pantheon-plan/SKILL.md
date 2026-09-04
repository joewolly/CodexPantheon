---
name: pantheon-plan
description: Explicit Pantheon planning workflow. Use only when the user explicitly invokes $pantheon-plan or explicitly asks Pantheon to plan without implementation.
---

# Pantheon Plan

This is a planning-only workflow. Do not implement, edit source, or mutate project state. The parent Codex thread owns the plan and the final answer.

This workflow is request-scoped: it does not become a sticky planning submode or change the base Pantheon state or effort. If base Pantheon is active, resume its prior state after this request.

## Bounded planning delegation

The parent decides whether research adds material value, then selects one best specialist first. Stop when the plan has sufficient evidence; add another only for a specific unresolved question, independent workstream, or materially useful independent check. Do not create a complexity swarm.

Use the relevant specialist: Explorer for unknown repository paths/ownership, Librarian for unknown external references, Oracle only for unresolved architecture/tradeoffs, and Designer for UI/UX planning. Never invoke Fixer merely to make a plan concrete.

For every native child spawn, default to `fork_turns: "none"` and provide a self-contained, bounded assignment: objective, scope, constraints/known context, write permission (read-only in this workflow), expected evidence/output, stopping condition, and a direct instruction not to spawn subagents. Do not inherit context merely because it is available. Use the minimum supported inheritance only when genuine parent context is required, with the sole special exception of a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

Each child remains bounded; the parent reconciles evidence, calls out assumptions, migrations, validation gates, rollback/compatibility concerns, and out-of-scope work only when material. Return one actionable plan with sequencing, ownership boundaries, validation criteria, material risks, and unresolved decisions.

Repository tests prove packaged policy/configuration and lifecycle behavior, not live backend, provider, runtime, or native child-spawn behavior.
