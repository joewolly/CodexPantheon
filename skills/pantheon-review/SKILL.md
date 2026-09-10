---
name: pantheon-review
description: Explicit Pantheon review workflow. Use only when the user invokes $pantheon-review or explicitly asks Pantheon to review code, a diff, branch, PR, or implementation.
---

# Pantheon Review

Run one read-only review request, then resume any previously active Daily/Full profile. This skill does not activate Pantheon, switch the main model, or modify production source.

The selected supported main-thread model is the Orchestrator and owns the review and verdict. Inspect target behavior, diff/static evidence, risk, and validation evidence. Use Explorer only for a material repository-evidence gap and Librarian only for a material authoritative external/reference gap. Both remain read-only; **do not use Fixer** during review-only work.

The Orchestrator may run focused tests/builds/reproduction directly when needed for the verdict. Specialist agreement is not proof, and passing tests do not erase static correctness issues.

For merge/release decisions return `PASS`, `PASS WITH NOTES`, or `FAIL / NO-MERGE` with blockers and material unverified gates.

All evidence dispatch follows the managed policy's minimum-context contract. Explicitly select the configured Luna role with `agent_type`; never inherit the Astra/Sol model. V1 parent transport uses `fork_context: false`; V2 parent transport uses `fork_turns: "none"` plus only required concise task metadata. Do not require a role-prefixed `task_name`; the resulting worker must resolve to GPT-5.6 Luna. If configured-role selection cannot be honored, fail visibly rather than creating a generic child. Keep assignments bounded, self-contained, and no-subagents.
