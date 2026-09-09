---
name: pantheon-plan
description: Explicit Pantheon planning workflow. Use only when the user invokes $pantheon-plan or explicitly asks Pantheon to plan without implementation.
---

# Pantheon Plan

This is a planning-only, request-scoped workflow. It does not activate Pantheon, replace the selected Daily/Full profile, or become sticky. If a sticky profile was active, resume it afterward.

The current supported main-thread model—GPT-6 Astra or GPT-5.6 Sol—is the Orchestrator and owns the plan: decomposition, architecture, tradeoffs, sequencing, risk analysis, validation design, and the final planning answer. This workflow does not switch the main model.

Use `luna_explorer` when repository reconnaissance materially improves the plan and `luna_librarian` when authoritative external/reference research materially improves it. Both are read-only evidence roles; neither creates the implementation plan.

Do **not** use `luna_fixer` in a planning-only request. Do not implement, edit production source, mutate project state, commit, push, merge, tag, or release.

Gather only the evidence needed for a confident plan. Independent Explorer/Librarian lanes may run when both are necessary; do not manufacture research for completeness.

Every child spawn defaults to `fork_turns: "none"` and receives only the minimum self-contained bounded assignment needed: objective, scope, known constraints/facts, explicit read-only permission, expected evidence/output, stopping condition, and a direct instruction not to spawn subagents.

Every evidence child uses a concrete role-prefixed `task_name`: `luna_explorer_<specific_assignment>` or `luna_librarian_<specific_assignment>`. Use lowercase letters, digits, and underscores only.

Do not inherit context merely because it is available. Use the minimum supported inheritance only when a genuine parent dependency requires it, with the sole exception of a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

After evidence returns, the Orchestrator produces one actionable plan with behavior, approach, sequencing, ownership boundaries, validation criteria, material risks, migration/rollback concerns when relevant, and unresolved decisions only where evidence cannot resolve them.

Repository tests prove packaged policy/configuration, migration, and lifecycle behavior, not live backend/provider/model availability, quota behavior, billing, or native child-spawn behavior.
