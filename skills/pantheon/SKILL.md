---
name: pantheon
description: Explicit, thread-scoped full Codex Pantheon orchestration. Activate on $pantheon or a clear request to use or enable Pantheon. Do not activate merely because Pantheon is mentioned, configured, documented, installed, updated, or inspected. Complexity alone never activates it.
---

# Pantheon

Pantheon is the higher-intensity opt-in delegation profile. The main Codex thread remains the orchestrator and owns the mission, decisions, integration, review, validation judgment, user communication, and final result.

Pantheon is designed for the main thread to run **GPT-6 Astra**. Astra is not an installed Pantheon subagent and must never be spawned as a child. Pantheon has one child role: `pantheon_worker`, pinned to GPT-5.6 Luna.

**Astra thinks. Luna does.**

## Thread-scoped activation

- Every new thread begins inactive and uses ordinary Codex behavior.
- `$pantheon` or a clear request to use or enable Pantheon activates full Pantheon for the current thread.
- Once active, ordinary follow-ups stay in full Pantheon without repeating `$pantheon`.
- `$pantheon-daily` switches the thread to the separate Daily profile.
- A clear request to disable Pantheon returns the thread to ordinary behavior.
- Activation never carries into another thread, a global preference, external storage, daemon, database, or hidden state.
- Difficulty, task length, parallelizability, and mere discussion never activate or deactivate Pantheon.

Mentioning, discussing, installing, updating, repairing, verifying, configuring, documenting, modifying, or uninstalling Codex Pantheon does not by itself activate orchestration. `Install Codex Pantheon for me.`, `Run Pantheon doctor.`, and `Update the Pantheon README.` are lifecycle/product requests, not activation. `Use Pantheon for this.` and `$pantheon` are activation.

`$pantheon-plan` and `$pantheon-review` are request-scoped workflows. They do not become sticky submodes or replace the currently selected Daily/full profile. A direct request for Pantheon Worker is also request-scoped.

## One worker, not a specialist roster

The parent first decides whether delegation materially improves speed, context efficiency, or execution quality. If not, work directly.

When delegation helps, use `pantheon_worker` for bounded execution such as:

- repository or local-system exploration;
- external/reference research using tools available to the child;
- scoped implementation, refactoring, or bug fixing;
- focused tests, builds, reproduction, or other execution evidence.

Do not create role theater. Repository discovery and implementation may be one cohesive Luna assignment when that avoids an unnecessary extra call. Do not simulate the old Explorer, Librarian, Oracle, Fixer, Designer, Reviewer, or Verifier pipeline with multiple identical workers.

Astra retains planning, architecture, tradeoff decisions, prioritization, integration, code review, final verification judgment, and the final merge/release verdict. A Luna worker may gather evidence for those decisions but does not replace Astra's judgment.

## Full-Pantheon delegation intensity

Full Pantheon may use multiple Luna workers when the marginal value is real. Parallel workers are allowed only for genuinely independent workstreams with clear, non-overlapping ownership. Sequential additional workers require a concrete unresolved execution or evidence need.

There is no numeric worker ceiling in full Pantheon, but every call must earn its place. Do not duplicate assignments, ask multiple workers for the same opinion, or fan out merely because a task looks complex.

Pantheon v0.5 intentionally has no fast/normal/deep effort layer. **Daily and full Pantheon are the two delegation-intensity controls.**

## Native child context and bounded assignments

Every child spawn defaults to `fork_turns: "none"`. Give the worker a self-contained, bounded assignment containing the objective, relevant scope, constraints and known context, whether writes are authorized, expected evidence/output, stopping condition, and a direct instruction not to spawn subagents.

Do not inherit context merely because it is available. Use the minimum supported inheritance only when a genuine parent dependency requires it. The sole exception is a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

For research, planning support, or review support, explicitly make the assignment read-only. For implementation, authorize only the required files/scope. The worker remains bounded either way.

## Completion and evidence

Reconcile worker output against observable evidence and stop once the user objective is satisfied. Agreement is not verification. The parent may run checks directly or delegate focused execution evidence to Luna, but Astra owns the final interpretation and verdict.

Repository tests prove packaged policy/configuration, migration, and lifecycle behavior. They do not prove live Codex backend, provider, model availability, quota behavior, billing, or native child-spawn behavior.
