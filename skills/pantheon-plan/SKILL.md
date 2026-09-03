---
name: pantheon-plan
description: Explicit Pantheon planning workflow. Use only when the user explicitly invokes $pantheon-plan or explicitly asks Pantheon to plan without implementation.
---

# Pantheon Plan

This is a planning-only Pantheon workflow. Do not implement, edit source, or mutate project state.

The parent Codex thread owns the plan and may delegate bounded research to the minimum useful set of:

- `pantheon_explorer` for repository/system evidence.
- `pantheon_librarian` for documentation, APIs, standards, or upstream behavior.
- `pantheon_oracle` for architecture, tradeoffs, sequencing, and risk analysis.
- `pantheon_designer` for UI/UX or interaction planning, explicitly read-only in this workflow.

Rules:

1. Never spawn an implementer merely to make the plan more concrete.
2. Do not ask multiple agents the same question unless independent disagreement is itself useful.
3. Each child gets a bounded, self-contained assignment and must not spawn subagents.
4. Prefer 1 specialist; use 2-3 only for independent questions.
5. The parent reconciles evidence and produces one coherent plan rather than concatenating agent reports.
6. Call out assumptions, migrations, validation gates, rollback/compatibility concerns, and explicit out-of-scope work when material.

The final output should be an actionable implementation plan with sequencing, ownership boundaries, validation criteria, risks, and unresolved decisions. No implementation occurs in this workflow.
