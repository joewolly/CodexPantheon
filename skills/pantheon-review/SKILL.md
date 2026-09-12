---
name: pantheon-review
description: Explicit Pantheon review workflow. Use only for $pantheon-review or explicit Pantheon review requests.
---

# Pantheon Review

Run a read-only review; resume the prior profile. Does not activate Pantheon, switch the main model, or modify source.

The main-thread Orchestrator owns review and verdict. It personally inspects diff/implementation/evidence, identifies findings, assigns severity, and makes merge/release judgments.

Use Explorer only for a bounded factual repository question: files/symbols/callers, execution paths/state, ownership, dependencies, or affected surfaces. Never ask Explorer to review a diff/PR/implementation, hunt bugs/regressions, judge correctness/safety, assign severity, or recommend merge/release. Explorer reports facts/labeled inference; the Orchestrator creates findings. Use Librarian only for authoritative/reference gaps. Both are read-only; **do not use Fixer**.

Every required evidence result is a hard dependency barrier; reconcile before dependent findings/verdicts. Daily stays sequential; Full or no prior sticky Pantheon profile may parallelize independent evidence lanes. The Orchestrator may run focused tests/builds/reproduction directly. Specialist agreement is not proof; passing tests do not erase static correctness issues.

For merge/release return `PASS`, `PASS WITH NOTES`, or `FAIL / NO-MERGE` with blockers and material unverified gates.

All evidence dispatch follows the managed policy's V2-only minimum-context contract. Use native MultiAgent V2 `spawn_agent` with Luna `agent_type`, `fork_turns: "none"`, and role-prefixed `task_name`; the resulting worker must resolve to GPT-5.6 Luna. Coordinate only through V2 `send_message`/`followup_task`; never use `send_message_to_thread` or non-V2 agent tools as fallbacks. If V2/role control cannot be honored, fail visibly. Keep assignments bounded, self-contained, no-subagents.
