---
name: pantheon
description: Explicit Codex Pantheon orchestration. Use only when the user explicitly invokes $pantheon or explicitly asks to use Pantheon. Never trigger from task complexity alone.
---

# Pantheon

Activate Pantheon only because the user explicitly requested it. The parent Codex thread remains the orchestrator and owner of the mission, integration, user communication, and final result.

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

If the user invokes Pantheon with an effort modifier, interpret it as orchestration depth rather than a different roster:

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
