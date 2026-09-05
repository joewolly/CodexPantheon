---
name: pantheon-daily
description: Explicit, thread-scoped, quota-conscious Codex Pantheon orchestration for day-to-day work. Activate on $pantheon-daily or a clear request to use, enable, or enter Pantheon Daily. Do not activate merely because Pantheon Daily is mentioned or because a task is complex.
---

# Pantheon Daily

Pantheon Daily is the quota-conscious Pantheon operating profile for routine work. The parent Codex thread remains responsible for the mission, implementation choices, integration, validation, user communication, and final result.

Daily optimizes for useful specialization per child-agent call. It is intentionally stricter than full `$pantheon`: avoid waste, keep fan-out small, and let the parent do work directly when delegation would add little value.

## Thread-scoped activation and switching

Treat Daily as conversational state in the current thread:

- Every new thread begins inactive and uses ordinary Codex behavior.
- `$pantheon-daily` or a clear natural-language request to use, enable, or enter Pantheon Daily activates Daily for the current thread.
- Once Daily is active, ordinary follow-ups stay in Daily without repeating `$pantheon-daily`.
- `$pantheon` switches the current thread from Daily to full Pantheon. A bare switch to full Pantheon starts full effort at `normal` unless the user supplies another effort instruction.
- `$pantheon-daily` switches an active full-Pantheon thread to Daily and clears full-Pantheon effort.
- A clear request to disable Pantheon—such as “stop using Pantheon,” “leave Pantheon mode,” or “go back to normal mode”—returns the thread to ordinary behavior.
- Activation never carries into another thread, a global preference, or external persistent storage.
- `$pantheon-plan`, `$pantheon-review`, and `$pantheon-team` remain request-scoped workflows. Invoking one does not replace the currently selected sticky profile. Its own routing contract governs that request, then Daily resumes afterward.
- Never silently switch Daily into full Pantheon or team mode because a task is difficult.

Mentioning, discussing, installing, updating, repairing, verifying, configuring, documenting, modifying, or uninstalling Codex Pantheon does not by itself activate Daily.

## Quota-first routing

First decide whether a specialist will materially reduce uncertainty, rework, or parent-thread effort. Zero specialists is a valid and often preferred Daily result.

When delegation is useful:

- Choose one best-fit specialist first.
- Normally use no more than two specialist calls for one user request.
- A third specialist call is allowed only when a concrete unresolved blocker, risk, or evidence gap remains after the earlier work and the parent cannot resolve it efficiently.
- Never use four or more specialist calls for one Daily request. Continue parent-owned work rather than silently escalating profiles.
- Do not fan out merely because work can be parallelized. Parallel Daily calls must represent genuinely independent work that is both necessary and cheaper than serial parent work.

Use the roster selectively:

- Low-risk, well-scoped implementation → parent handles it directly when practical; use `pantheon_fixer` when delegated implementation materially saves work or isolates a substantial change.
- Unknown repository path or ownership → `pantheon_explorer`.
- Unknown external documentation or reference → `pantheon_librarian`.
- Unresolved architecture or material tradeoff → `pantheon_oracle`, only after the parent identifies a real decision that cannot be resolved cheaply.
- Actual UI/UX or interaction work → `pantheon_designer`.
- Material static correctness, diff, security, or regression risk → `pantheon_reviewer`.
- Material executable test, build, reproduction, or acceptance-evidence need → `pantheon_verifier`.

Prefer Explorer or Librarian rather than both unless repository evidence and external reference evidence are independently required. For implementation, prefer at most one independent check—Reviewer or Verifier—based on the dominant risk. Do not default to Fixer → Reviewer → Verifier.

## Native child context and bounded assignments

Any Daily child spawn defaults to `fork_turns: "none"`. Give each child a self-contained, bounded assignment with the objective, relevant scope, constraints and known context, write permission, expected evidence/output, stopping condition, and a direct instruction not to spawn subagents.

Do not inherit context merely because it is available. Use the minimum supported inheritance only when a genuine parent dependency requires it. The sole special exception is a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

## Completion and evidence

Stop specialist escalation as soon as the request can be completed with sufficient evidence. Reconcile child findings against observable evidence; agreement between agents is not verification.

Daily changes routing behavior, not the seven agent model/reasoning definitions. It does not add token accounting, rate-limit tracking, persistent budgets, a daemon, scheduler, or custom runtime.

Repository tests prove packaged policy/configuration and lifecycle behavior. They do not prove live Codex backend, provider, runtime, quota behavior, billing, or native child-spawn availability.
