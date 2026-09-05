---
name: pantheon-plan
description: Explicit Pantheon planning workflow. Use only when the user explicitly invokes $pantheon-plan or explicitly asks Pantheon to plan without implementation.
---

# Pantheon Plan

This is a planning-only, request-scoped workflow. It does not activate Pantheon, replace the selected Daily/full profile, or become a sticky planning mode. If a sticky profile was already active, resume it after this request.

The parent Codex thread owns the plan. Pantheon is designed for GPT-6 Astra as the main thread; Astra performs decomposition, architecture, tradeoff decisions, sequencing, risk analysis, and the final planning answer.

## Bounded Luna research

Use `pantheon_worker` only when repository exploration, external/reference research, or other concrete evidence materially improves the plan. Zero worker calls is valid. One worker call is normally enough; add another only for a genuinely independent essential evidence gap.

Any worker assignment in this workflow is **read-only**. Do not implement, edit production source, mutate project state, commit, push, merge, tag, or release.

Every child spawn defaults to `fork_turns: "none"` and receives a self-contained, bounded assignment containing the objective, scope, known constraints/context, explicit read-only permission, expected evidence/output, stopping condition, and a direct instruction not to spawn subagents.

Do not inherit context merely because it is available. Use the minimum supported inheritance only when a genuine parent dependency requires it, with the sole exception of a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

Return one actionable plan with sequencing, ownership boundaries, validation criteria, material risks, migration/rollback concerns when relevant, and unresolved decisions only where evidence cannot resolve them.

Repository tests prove packaged policy/configuration, migration, and lifecycle behavior, not live backend, provider, model availability, quota behavior, or native child-spawn behavior.
