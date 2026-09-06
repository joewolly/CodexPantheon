---
name: pantheon-review
description: Explicit Pantheon review workflow. Use only when the user invokes $pantheon-review or explicitly asks Pantheon to review code, a diff, branch, PR, or implementation.
---

# Pantheon Review

This is a request-scoped, read-only review workflow. It does not activate Pantheon, replace the selected Daily/full profile, or become sticky. Do not modify production source as part of a review-only request.

Astra performs the actual review and owns the verdict. Astra inspects the target behavior, diff, risk, static evidence, and validation evidence and decides what the evidence proves.

## Optional evidence specialists

Use `luna_explorer` for a bounded repository-evidence question such as mapping a code path, ownership boundary, or suspected regression surface. Use `luna_librarian` for a bounded authoritative external/reference requirement. Both are read-only and return evidence; neither owns the review judgment.

Do not use `luna_fixer` during a review-only request. If the user separately asks to apply fixes, finish or clearly exit the review decision, have Astra create the implementation specification, and route the implementation to Fixer under the active Pantheon profile or an explicit implementation request.

Astra may run focused tests/builds/reproduction directly when needed for the review verdict. Agreement from a specialist is not proof, and a passing test does not erase a static correctness issue.

Every child spawn defaults to `fork_turns: "none"` and receives a self-contained, bounded assignment with objective, review target/scope, constraints/context, explicit read-only permission, expected evidence/output, stopping condition, and a direct instruction not to spawn subagents.

Do not inherit context merely because it is available. Use the minimum supported inheritance only when a genuine parent dependency requires it, with the sole exception of a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

For a merge or release decision, return a clear `PASS`, `PASS WITH NOTES`, or `FAIL / NO-MERGE` verdict with blocking reasons and material unverified gates.

Repository tests prove packaged policy/configuration, migration, and lifecycle behavior, not live backend/provider/model availability, quota behavior, billing, or native child-spawn behavior.
