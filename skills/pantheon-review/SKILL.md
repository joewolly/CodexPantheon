---
name: pantheon-review
description: Explicit Pantheon independent review workflow. Use only when the user explicitly invokes $pantheon-review or explicitly asks Pantheon to review code, a diff, branch, PR, or implementation.
---

# Pantheon Review

This is an independent review workflow. Do not modify production source code. It is request-scoped: it applies only to the request that invokes it and does not become a sticky review submode or change base Pantheon state or effort. If base Pantheon is active, resume its prior state afterward.

## Required and optional specialists

`pantheon_reviewer` is required and must inspect the actual target and intended behavior. `pantheon_verifier` is optional, only when runtime tests, builds, reproduction, or acceptance evidence materially improve confidence. Use Explorer or Librarian only for a specific missing repository or external-reference question; do not add a preflight for completeness. Add another specialist only for a specific unresolved need, genuinely independent workstream, or material verification requirement. Every additional specialist must earn its place.

For every native child spawn, default to `fork_turns: "none"` and give a self-contained, bounded assignment with objective, review target/scope, constraints and known context, write permission (read-only for review), expected findings/evidence, stopping condition, and a direct instruction not to spawn subagents. Do not inherit context merely because it is available. Use the minimum supported inheritance only when genuine parent context is required, with the sole special exception of a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

The parent chooses the minimum useful review evidence, reconciles it independently, and does not invent findings or treat agreement as proof. A Verifier remains optional; there is no default Fixer → Reviewer → Verifier chain.

Repository tests prove packaged policy/configuration and lifecycle behavior, not live backend, provider, runtime, or native child-spawn behavior.

For a merge or release decision, give a clear `PASS`, `PASS WITH NOTES`, or `FAIL / NO-MERGE` verdict with blocking reasons and unverified gates.
