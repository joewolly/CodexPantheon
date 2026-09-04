---
name: pantheon-review
description: Explicit Pantheon independent review workflow. Use only when the user explicitly invokes $pantheon-review or explicitly asks Pantheon to review code, a diff, branch, PR, or implementation.
---

# Pantheon Review

This is an independent review workflow. Do not modify production source code.

This workflow applies only to the request that invoked it. It does not become a sticky review submode or change the base Pantheon thread state or effort. If base Pantheon is already active, resume its prior mode after this workflow.

Required specialist:

- `pantheon_reviewer` performs the independent review of the actual target.

Optional specialists, only when they materially improve confidence:

- `pantheon_verifier` for tests, builds, reproduction, or acceptance-criteria evidence.
- `pantheon_explorer` when the reviewer needs additional repository context that should be gathered separately.
- `pantheon_librarian` when correctness depends on version-sensitive external APIs, standards, or upstream behavior.

Rules:

1. Give the reviewer the actual review target and intended behavior, not another agent's summary alone.
2. Each child gets a bounded assignment and must not spawn subagents.
3. Review is read-only; verifier may generate normal temporary build/test artifacts but must not edit production source.
4. Prefer concrete findings with file/symbol/line or reproduction evidence.
5. Do not invent findings to justify the workflow.
6. The parent independently reconciles the evidence and owns the final verdict.

For merge/release decisions, end with a clear verdict such as PASS, PASS WITH NOTES, or FAIL / NO-MERGE, together with the blocking reasons and any unverified gates.
