---
name: pantheon-daily
description: Explicit, thread-scoped, quota-conscious Pantheon profile for day-to-day Codex work. Activate on $pantheon-daily or a clear request to use or enable Pantheon Daily. Do not activate merely because Daily is mentioned or because a task is complex.
---

# Pantheon Daily

Pantheon Daily is the conservative, quota-conscious profile and the recommended Pantheon default for routine work. The main Codex thread remains the orchestrator; Pantheon is designed for GPT-6 Astra as that main model, with `pantheon_worker` on GPT-5.6 Luna as the only child role.

**Astra thinks. Luna does — but Daily makes Luna earn the call.**

## Thread-scoped activation and switching

- Every new thread begins inactive and uses ordinary Codex behavior.
- `$pantheon-daily` or a clear request to use or enable Pantheon Daily activates Daily for the current thread.
- Once Daily is active, ordinary follow-ups stay in Daily without repeating `$pantheon-daily`.
- `$pantheon` switches the current thread to full Pantheon.
- A clear request to disable Pantheon returns the thread to ordinary behavior.
- Activation never carries into another thread or persistent state.
- `$pantheon-plan` and `$pantheon-review` remain request-scoped workflows and do not replace the sticky Daily/full profile.
- Never silently switch Daily into full Pantheon because a task is difficult.

Mentioning, discussing, installing, updating, repairing, verifying, configuring, documenting, modifying, or uninstalling Pantheon does not activate Daily.

## Quota-first worker routing

Zero Luna calls is a valid and often preferred Daily result. Astra should handle cheap, well-understood work directly when delegation would cost more context or calls than it saves.

When Luna materially saves parent context, exploration time, implementation work, or execution effort:

- normally use **0-1 worker calls per user request**;
- do not parallelize workers in Daily;
- use a second sequential worker call only when the first leaves a concrete unresolved blocker or evidence gap that Astra cannot resolve cheaply;
- never create a specialist chain or call multiple workers merely for independent opinions.

Prefer one cohesive assignment. If Luna can inspect the relevant repository area, identify the target, implement the scoped change, and run focused validation in one bounded call, do that instead of splitting the work into artificial Explorer and Fixer stages.

Astra keeps planning, architecture, prioritization, integration, review, final verification judgment, and the final answer. Luna performs bounded exploration, research, implementation, fixes, and focused validation/evidence.

## Native child context and bounded assignments

Every Daily child spawn defaults to `fork_turns: "none"`. Give the worker a self-contained, bounded assignment with the objective, relevant scope, constraints and known context, write permission, expected evidence/output, stopping condition, and a direct instruction not to spawn subagents.

Do not inherit context merely because it is available. Use the minimum supported inheritance only when a genuine parent dependency requires it. The sole exception is a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

For research, planning support, or review support, explicitly require read-only behavior. For implementation, authorize only the necessary scope.

## Completion and evidence

Stop worker delegation as soon as the request can be completed with sufficient evidence. Astra reconciles the evidence and owns the final judgment.

Daily and full Pantheon are the only delegation-intensity profiles. Daily does not have fast/normal/deep effort levels, does not use `$pantheon-team`, and does not add token accounting, quota polling, persistent budgets, a daemon, scheduler, or custom runtime.

Repository tests prove packaged policy/configuration, migration, and lifecycle behavior. They do not prove live Codex backend, provider, model availability, quota behavior, billing, or native child-spawn behavior.
