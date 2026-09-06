---
name: pantheon-daily
description: Explicit, thread-scoped quota-conscious Pantheon profile. Uses the same Astra/Explorer/Librarian/Fixer ownership as full Pantheon with more conservative delegation and no parallel child calls.
---

# Pantheon Daily

Pantheon Daily uses the same orchestration contract as full Pantheon but biases harder against delegation overhead. **It changes delegation intensity, never role ownership.**

## Activation

- Every new thread begins inactive.
- `$pantheon-daily` or a clear request to use/enable Pantheon Daily activates Daily for the current thread.
- Ordinary follow-ups remain in Daily until the user disables Pantheon or invokes `$pantheon`.
- Activation never carries into another thread or persistent state.
- `$pantheon-plan` and `$pantheon-review` remain request-scoped workflows.
- Never silently switch Daily into full Pantheon because a task is difficult.

## Ownership is identical to full Pantheon

Astra is the orchestrator: understand, plan, prioritize, architect, delegate, reconcile, review, and verify. Astra is **not the default implementation worker**.

- `luna_explorer` is read-only repository reconnaissance and does not plan the solution.
- `luna_librarian` is read-only external/reference research and does not plan the solution.
- `luna_fixer` implements Astra's scoped specification and assigned validation; it does not independently replan or redesign the mission.

Astra may directly perform one isolated, clear, low-risk action when delegation overhead exceeds execution. Otherwise, substantive implementation routes to Fixer.

## Quota-conscious routing

Daily has **no numeric worker-call ceiling**. A hard 0-1 ceiling can distort ownership by forcing Astra either to make Fixer research/plan or to research with Luna and then implement itself. Daily avoids that failure mode.

Instead:

- delegate only when the specialist materially saves parent context, uncertainty, or execution effort;
- do not parallelize child agents in Daily;
- prefer the smallest evidence lane that lets Astra plan confidently;
- if Astra already has enough evidence, skip Explorer/Librarian and send the implementation specification directly to Fixer;
- if evidence is genuinely required, use Explorer and/or Librarian sequentially as needed, then Astra creates the plan, then Fixer implements;
- do not use Explorer/Librarian for reconnaissance and then let Astra perform substantive implementation merely because the answer is now obvious;
- do not combine open-ended exploration, architecture planning, and implementation into one Fixer call just to save a spawn.

Typical shapes:

- trivial isolated action: `Astra directly`;
- known implementation: `Astra plan → Fixer → Astra review`;
- unknown repository behavior: `Explorer → Astra plan → Fixer → Astra review`;
- version-sensitive implementation: `Librarian → Astra plan → Fixer → Astra review`;
- both evidence types required: `Explorer → Librarian → Astra plan → Fixer → Astra review` (or the reverse order when dependencies require it).

## Context and assignments

Every child spawn defaults to `fork_turns: "none"`. Give each specialist a self-contained, bounded assignment with objective, scope, constraints/context, permission boundary, expected evidence/output, stopping condition, and a direct instruction not to spawn subagents.

Do not inherit context merely because it is available. Use the minimum supported inheritance only when a genuine parent dependency requires it. The sole exception is a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

Daily and full Pantheon are the only delegation-intensity profiles. Daily has no separate team mode, effort levels, token accounting, quota polling, daemon, scheduler, or custom runtime.

Repository tests prove packaged policy/configuration, migration, and lifecycle behavior, not live backend/provider/model availability, quota behavior, billing, or native child-spawn behavior.
