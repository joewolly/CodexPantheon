---
name: pantheon-review
description: Explicit Pantheon review workflow. Use only when the user invokes $pantheon-review or explicitly asks Pantheon to review code, a diff, branch, PR, or implementation.
---

# Pantheon Review

Run one read-only review request, then resume any previously active Daily/Full profile. This skill does not activate Pantheon, switch the main model, or modify production source.

The selected supported main-thread model is the Orchestrator and owns the review and verdict. Inspect target behavior, diff/static evidence, risk, and validation evidence. Use Explorer only for a material repository-evidence gap and Librarian only for a material authoritative external/reference gap. Both remain read-only; **do not use Fixer** during review-only work.

The Orchestrator may run focused tests/builds/reproduction directly when needed for the verdict. Specialist agreement is not proof, and passing tests do not erase static correctness issues.

For merge/release decisions return `PASS`, `PASS WITH NOTES`, or `FAIL / NO-MERGE` with blockers and material unverified gates.

All evidence dispatch follows the managed policy's V2-only minimum-context contract. Use native MultiAgent V2 `spawn_agent`; explicitly select the configured Luna role with `agent_type`, use `fork_turns: "none"`, and keep `task_name` concise routing metadata. Format it as `<role>_<concise_task_slug>` with `explorer` or `librarian` matching `agent_type`, such as `librarian_v020_release_map`; the prefix is display/path metadata only. The resulting worker must resolve to GPT-5.6 Luna. Coordinate it only through native V2 `send_message`/`followup_task`; never use generic `send_message_to_thread` or non-V2 agent tools as fallbacks. If V2 or configured-role selection/communication cannot be honored, fail visibly. Keep assignments bounded, self-contained, and no-subagents.
