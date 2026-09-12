---
name: pantheon-review
description: Explicit Pantheon review workflow. Use only when the user invokes $pantheon-review or explicitly asks Pantheon to review code, a diff, branch, PR, or implementation.
---

# Pantheon Review

Run one read-only review, then resume the prior profile. This skill does not activate Pantheon, switch the main model, or modify production source.

The main-thread Orchestrator owns the review itself and the verdict. It must personally inspect the diff/implementation, behavior, static evidence, risk, and validation evidence; identify findings; assess severity; and make merge/release judgments.

Use Explorer only for a bounded factual repository question that supplies missing evidence for the Orchestrator's review, such as locating files/symbols/callers, tracing execution paths or state transitions, or identifying ownership, dependencies, and affected surfaces. Never ask Explorer to review a diff/PR/implementation, hunt for bugs or regressions, assess correctness or safety, assign severity, or recommend a merge/release outcome. Explorer reports repository facts and clearly labeled inference only; the Orchestrator converts that evidence into review findings and judgments. Use Librarian only for material authoritative/reference gaps. Explorer and Librarian are read-only; **do not use Fixer**.

Every required evidence result is a hard dependency barrier: do not finalize a dependent finding, merge/release judgment, or verdict until it returns and is reconciled. Respect the prior profile's parallelism: Daily stays sequential; Full or no prior sticky Pantheon profile may parallelize independent evidence lanes. The Orchestrator may run focused tests/builds/reproduction directly. Specialist agreement is not proof; passing tests do not erase static correctness issues.

For merge/release decisions return `PASS`, `PASS WITH NOTES`, or `FAIL / NO-MERGE` with blockers and material unverified gates.

All evidence dispatch follows the managed policy's V2-only minimum-context contract. Use native MultiAgent V2 `spawn_agent`; select the Luna role with `agent_type`, use `fork_turns: "none"`, and a concise role-prefixed `task_name`. The resulting worker must resolve to GPT-5.6 Luna. Coordinate only through V2 `send_message`/`followup_task`; never use `send_message_to_thread` or non-V2 agent tools as fallbacks. If V2 or role control cannot be honored, fail visibly. Keep assignments bounded, self-contained, no-subagents.
