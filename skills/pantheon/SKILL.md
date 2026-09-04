---
name: pantheon
description: Explicit, thread-scoped Codex Pantheon orchestration. Activate only when the user invokes $pantheon or explicitly asks to use Pantheon, then keep it active in that thread until explicitly disabled. Never trigger from task complexity alone.
---

# Pantheon

Activate Pantheon only because the user explicitly requested it. The parent Codex thread remains the orchestrator and owner of the mission, integration, user communication, and final result.

## Thread-scoped activation state

Treat Pantheon activation as explicit conversational state in the current thread:

- Every new thread begins with Pantheon inactive and uses normal non-Pantheon behavior.
- `$pantheon` or a clear natural-language request to use or enter Pantheon activates it for the current thread. Activation may happen on the first message or at any later point.
- Once activated, Pantheon remains active for subsequent ordinary requests in that thread. The user does not need to repeat `$pantheon`.
- A clear request to disable Pantheon returns the thread to normal non-Pantheon behavior. Recognize explicit intent such as “disable Pantheon,” “stop using Pantheon,” “leave Pantheon mode,” or “go back to normal mode”; do not infer deactivation from vague wording.
- After deactivation, later requests remain outside Pantheon until the user explicitly activates it again.
- This state belongs only to the current conversation. Never carry it into a new or unrelated thread, a global preference, or external persistent storage.
- Never activate or deactivate Pantheon merely because a request is difficult, long, simple, or apparently suited to multiple agents. Vague wording, quoted examples, and mere discussion of Pantheon do not change the state.

Determine the current state from the thread's explicit activation and deactivation history. Do not create a daemon, database, background process, or hidden cross-thread state for this purpose.

## Select the minimum useful specialists

Available custom agents:

- `pantheon_explorer`: repository/system mapping and evidence gathering; read-only.
- `pantheon_librarian`: external/reference research; read-only.
- `pantheon_oracle`: architecture, tradeoffs, difficult reasoning; read-only.
- `pantheon_fixer`: focused implementation.
- `pantheon_designer`: UI/UX critique or explicitly authorized UI implementation.
- `pantheon_reviewer`: independent implementation/diff review; read-only.
- `pantheon_verifier`: independent tests/builds/reproduction; no production-source edits.

Do not invoke an agent merely because one exists for the category.

Default fan-out:

- 0 agents only when delegation would clearly add no value even though Pantheon was invoked; explain briefly and continue locally.
- 1 agent is the normal delegation case.
- 2-3 agents are appropriate for genuinely independent workstreams or independent verification.
- 4+ agents require an explicit user request for broader fan-out or an unusually broad task with clearly independent workstreams.

Never manufacture parallel work by asking multiple agents the same vague question.

## Child assignment contract

Every spawned agent assignment must be concrete and bounded. Include:

1. Objective
2. Relevant scope / files / subsystem
3. Constraints and known context
4. Whether modification is permitted
5. Expected output / evidence
6. A direct instruction not to spawn subagents

Prefer self-contained child assignments and the least inherited context needed. Avoid full-history forking by default when the task can be stated cleanly.

The parent must not hand off mission ownership. The parent synthesizes agent results, resolves conflicts, performs integration, and gives the final answer.

## Effort modifiers

Pantheon effort is also thread-scoped conversational state:

- When Pantheon is inactive, activating without an effort instruction selects `normal`.
- Select the Pantheon skill with `$pantheon`. Express effort as a clear conversational instruction supplied with the activation request, such as “Use deep orchestration for this task.” Do not require or recommend appending effort words to the skill-picker invocation.
- While Pantheon is active, clear instructions such as “switch Pantheon to fast,” “use normal Pantheon effort,” or “switch Pantheon to deep” change the effort without another skill invocation.
- The selected effort remains in effect for later requests while Pantheon is active, until the user explicitly selects another effort or disables Pantheon. Ordinary follow-ups and a repeated bare `$pantheon` do not reset it.
- Deactivation clears the selected effort. Reactivating without an effort instruction selects `normal`; do not silently restore the previous effort.

A clear instruction to “use normal Pantheon effort” selects normal effort while keeping Pantheon active. In contrast, a clear request to “go back to normal mode” deactivates Pantheon as described above.

Interpret the active effort as orchestration depth rather than a different roster:

- `fast`: strongly prefer zero or one specialist; avoid redundant second opinions; optimize for latency.
- `normal` or no modifier: balanced delegation; independent review/verification when materially useful.
- `deep`: allow more research and sequential independent review/verification, but still obey fan-out limits.

If native spawn controls allow a supported reasoning-effort override, use it only when it is compatible with the selected model. Do not hard-code model names merely to satisfy an effort label.

## Completion

Before finishing:

- Reconcile conflicting agent findings against evidence.
- Do not equate agent agreement with verification.
- Run or request independent verification when the risk of an unverified implementation is material.
- Report what was actually verified and what remains uncertain.
