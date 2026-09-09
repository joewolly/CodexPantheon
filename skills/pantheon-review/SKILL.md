---
name: pantheon-review
description: Explicit Pantheon review workflow. Use only when the user invokes $pantheon-review or explicitly asks Pantheon to review code, a diff, branch, PR, or implementation.
---

# Pantheon Review

This is a request-scoped, read-only review workflow. It does not activate Pantheon, replace the selected Daily/Full profile, or become sticky. Do not modify production source during a review-only request.

The current supported main-thread model—GPT-6 Astra or GPT-5.6 Sol—is the Orchestrator and performs the actual review. It inspects behavior, diff, risk, static evidence, and validation evidence and owns the verdict. This workflow does not switch the main model.

Use `luna_explorer` for a bounded repository-evidence question such as a code path, ownership boundary, or suspected regression surface. Use `luna_librarian` for a bounded authoritative external/reference requirement. Both are read-only; neither owns the review judgment.

Do not use `luna_fixer` during a review-only request. If the user separately asks to apply fixes, clearly exit the review decision, create the implementation specification, and route non-trivial implementation to Fixer under the active Pantheon profile or explicit implementation request.

The Orchestrator may run focused tests/builds/reproduction directly when needed for the verdict. Agreement from a specialist is not proof, and a passing test does not erase a static correctness issue.

Every child spawn defaults to `fork_turns: "none"` and receives only the minimum self-contained bounded assignment needed: objective, review target/scope, known constraints/facts, explicit read-only permission, expected evidence/output, stopping condition, and a direct instruction not to spawn subagents.

Every evidence child uses a concrete role-prefixed `task_name`: `luna_explorer_<specific_assignment>` or `luna_librarian_<specific_assignment>`. Use lowercase letters, digits, and underscores only.

Do not inherit context merely because it is available. Use the minimum supported inheritance only when a genuine parent dependency requires it, with the sole exception of a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

For a merge or release decision, return a clear `PASS`, `PASS WITH NOTES`, or `FAIL / NO-MERGE` verdict with blocking reasons and material unverified gates.

Repository tests prove packaged policy/configuration, migration, and lifecycle behavior, not live backend/provider/model availability, quota behavior, billing, or native child-spawn behavior.
