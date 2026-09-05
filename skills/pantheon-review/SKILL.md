---
name: pantheon-review
description: Explicit Pantheon review workflow. Use only when the user explicitly invokes $pantheon-review or explicitly asks Pantheon to review code, a diff, branch, PR, or implementation.
---

# Pantheon Review

This is a request-scoped focused review workflow. It does not activate Pantheon, replace the selected Daily/full profile, or become a sticky review mode. Do not modify production source code as part of the review.

The parent Codex thread performs the review and owns the verdict. Pantheon is designed for GPT-6 Astra as the main thread; Astra inspects the actual target, intended behavior, diff, risk, and available evidence directly.

## Luna as an evidence worker

`pantheon_worker` is optional. Use it only for a bounded evidence lane that materially improves the review, such as:

- mapping a specific repository path or ownership question;
- checking an authoritative external/reference requirement;
- running focused tests, builds, reproduction, or acceptance checks;
- gathering concrete evidence for a suspected regression;
- providing a read-only second opinion on a narrowly defined question when genuinely independent inspection matters.

Do not delegate the final code-review judgment or merge/release verdict to Luna. Worker review-support assignments are read-only with respect to production source.

Every child spawn defaults to `fork_turns: "none"` and receives a self-contained, bounded assignment with objective, review target/scope, known constraints/context, explicit read-only permission, expected evidence/output, stopping condition, and a direct instruction not to spawn subagents.

Do not inherit context merely because it is available. Use the minimum supported inheritance only when a genuine parent dependency requires it, with the sole exception of a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

Astra reconciles worker evidence itself. Agreement is not proof, and a passing test does not erase a static correctness issue. Use only the evidence lanes the target risk actually requires.

For a merge or release decision, return a clear `PASS`, `PASS WITH NOTES`, or `FAIL / NO-MERGE` verdict with blocking reasons and any material unverified gates.

Repository tests prove packaged policy/configuration, migration, and lifecycle behavior, not live backend, provider, model availability, quota behavior, or native child-spawn behavior.
