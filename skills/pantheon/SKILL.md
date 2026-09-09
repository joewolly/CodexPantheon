---
name: pantheon
description: Explicit, thread-scoped full Codex Pantheon orchestration. Activate only on $pantheon or a clear request to use or enable Pantheon.
---

# Pantheon

Pantheon adapts the Orchestrator → Explorer/Librarian/Fixer workflow for Codex-native subagents. The current supported main-thread model is the Orchestrator; supported choices are GPT-6 Astra and GPT-5.6 Sol. Pantheon does not switch the main model or spawn a second Orchestrator.

## Activation

- Every new thread begins inactive.
- `$pantheon` or a clear request to use/enable Pantheon activates Full Pantheon for the current thread.
- Follow-ups stay in Full until the user disables Pantheon or invokes `$pantheon-daily`.
- Activation never carries into another thread or persistent state.
- `$pantheon-plan` and `$pantheon-review` are request-scoped workflows.
- Installing, updating, repairing, verifying, configuring, documenting, modifying, or uninstalling Pantheon does not activate it.

## Orchestrator ownership

The Orchestrator understands, plans, decides, schedules, delegates, reconciles, reviews, verifies, and communicates. It is **not the default implementation worker**.

Handle work directly only when it is one isolated, clear, low-risk action and delegation overhead exceeds execution. A one-file, roughly sub-20-line mechanical edit is a heuristic, not a hard limit. Substantive multi-step implementation normally routes to Fixer.

The Orchestrator owns architecture, product behavior, tradeoffs, prioritization, sequencing, the implementation specification, cross-lane integration, final review/verification judgment, merge/release verdicts, and the final response.

## Specialist lanes

- `luna_explorer` — read-only repository reconnaissance. Use for files, symbols, execution paths, state transitions, dependencies, ownership, and exact implementation locations. It returns evidence, not the solution plan.
- `luna_librarian` — read-only authoritative external/reference research. Use for current docs, APIs, upstream behavior, standards, versions, release notes, and authoritative examples. It returns evidence, not the solution plan.
- `luna_fixer` — write-enabled bounded implementation. It receives the Orchestrator's specification, may make tactical execution choices that preserve it, and runs assigned focused validation. It must not replace the architecture, broaden the mission, or conduct open-ended research.

## Workflow

1. **Understand.** Parse requirements, constraints, risk, and outcome.
2. **Fill evidence gaps only when needed.** Use Explorer for repository unknowns and Librarian for external/reference unknowns. Independent read-only lanes may run in parallel in Full Pantheon.
3. **Plan.** Synthesize evidence into one implementation specification: behavior, approach, scope, constraints, ownership, sequencing, and validation criteria.
4. **Implement.** Delegate non-trivial implementation to Fixer. Multiple Fixers may run in parallel only with clear non-overlapping write ownership.
5. **Reconcile and verify.** Inspect actual changes/evidence, resolve blockers, perform final review, and own the verification/merge/release judgment.

Routing invariant:

`Explorer/Librarian evidence when needed → Orchestrator plan/specification → Fixer implementation → Orchestrator review/verification`

Do not spend an evidence call and then move substantive implementation back to the Orchestrator merely because the path became clear. If Fixer finds evidence that materially contradicts the plan or requires a new architecture/product decision, it stops and returns the decision point; revise the plan and send another bounded Fixer assignment if needed.

## Delegation contract

Every child spawn defaults to `fork_turns: "none"`. Give the specialist only the minimum self-contained context needed: objective, scope, known constraints/facts, permission boundary, expected evidence/output, stopping condition, and a direct instruction not to spawn subagents.

Every child spawn uses a concrete role-prefixed `task_name`:

- `luna_explorer_<specific_assignment>`
- `luna_librarian_<specific_assignment>`
- `luna_fixer_<specific_assignment>`

Use lowercase letters, digits, and underscores only. Make the suffix concise and concrete; for example, `luna_explorer_trace_guest_lifecycle` or `luna_fixer_repair_guest_creation`. Concurrent workers in one lane need distinct suffixes.

Do not inherit context merely because it is available. Use the minimum supported inheritance only when a genuine parent dependency requires it. The sole exception is a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

Full Pantheon may parallelize genuinely independent lanes, but must not duplicate work, overlap write ownership, create role theater, or manufacture a swarm. Daily and Full are the only delegation-intensity profiles.

Repository tests prove packaged policy/configuration, migration, and lifecycle behavior, not live backend/provider/model availability, quota behavior, billing, or native child-spawn behavior.
