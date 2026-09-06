---
name: pantheon-plan
description: Explicit Pantheon planning workflow. Use only when the user invokes $pantheon-plan or explicitly asks Pantheon to plan without implementation.
---

# Pantheon Plan

This is a planning-only, request-scoped workflow. It does not activate Pantheon, replace the selected Daily/full profile, or become sticky. If a sticky profile was active, resume it after this request.

Astra owns the plan. Astra performs decomposition, architecture, tradeoff decisions, sequencing, risk analysis, validation design, and the final planning answer.

## Evidence specialists

Use `luna_explorer` when repository reconnaissance materially improves the plan. Use `luna_librarian` when authoritative external/reference research materially improves the plan. Both roles are read-only and return evidence to Astra; neither creates the implementation plan.

Do **not** use `luna_fixer` in a planning-only request. Do not implement, edit production source, mutate project state, commit, push, merge, tag, or release.

Astra should gather only the evidence needed to make the plan. Independent Explorer/Librarian lanes may be used when both are necessary, but do not manufacture research work for completeness.

Every child spawn defaults to `fork_turns: "none"` and receives a self-contained, bounded assignment containing objective, scope, constraints/context, explicit read-only permission, expected evidence/output, stopping condition, and a direct instruction not to spawn subagents.

Do not inherit context merely because it is available. Use the minimum supported inheritance only when a genuine parent dependency requires it, with the sole exception of a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

After evidence returns, Astra synthesizes it and produces one actionable plan with behavior, approach, sequencing, ownership boundaries, validation criteria, material risks, migration/rollback concerns when relevant, and unresolved decisions only where evidence cannot resolve them.

Repository tests prove packaged policy/configuration, migration, and lifecycle behavior, not live backend/provider/model availability, quota behavior, billing, or native child-spawn behavior.
