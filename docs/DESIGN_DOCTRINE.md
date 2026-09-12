# Codex Pantheon Design Doctrine

Codex Pantheon is a slim, explicit, Codex-native orchestration layer. It gives a supported main-thread model the proven shape of an Orchestrator with specialized execution lanes without becoming a separate agent runtime.

> **Orchestrator decides. Luna specialists execute their lane.**

Pantheon v0.7 keeps the Orchestrator contract model-neutral between GPT-6 Astra and GPT-5.6 Sol while retaining the Explorer/Librarian/Fixer role semantics adapted from the MIT-licensed `oh-my-opencode-slim` project. OpenCode-specific plugin, TUI, scheduler, job-board, and SDK machinery is intentionally not ported.

## Non-negotiable principles

1. **Solo by default.** Installing Pantheon changes no ordinary prompt behavior. Every new thread starts inactive.
2. **Explicit activation.** Only `$pantheon`, `$pantheon-daily`, or a clear equivalent request activates a sticky Pantheon profile.
3. **The main thread is the Orchestrator.** The current supported main-thread model may be GPT-6 Astra or GPT-5.6 Sol. Pantheon does not install or spawn a second Orchestrator.
4. **Model selection is native Codex state.** Pantheon never pretends a skill invocation changed the active model. Choose Astra or Sol with Codex's native model control; the same Pantheon contract applies to both.
5. **The Orchestrator never implements.** Astra/Sol is an exclusive workflow manager. Every repository implementation edit, including tiny or obvious changes, routes to `luna_fixer`; there is no delegation-overhead escape hatch.
6. **The Orchestrator owns decisions.** Architecture, product behavior, tradeoffs, prioritization, sequencing, implementation specifications, cross-lane integration, final review, verification judgment, and merge/release verdicts remain in the main thread.
7. **Explorer owns repository evidence.** `luna_explorer` is read-only. It locates files/symbols, traces behavior, maps ownership/dependencies, and reports evidence. It does not design the solution.
8. **Librarian owns external evidence.** `luna_librarian` is read-only. It researches official docs, APIs, upstream behavior, standards, version-sensitive facts, and authoritative examples. It does not design the solution.
9. **Fixer owns bounded implementation.** `luna_fixer` receives the Orchestrator's scoped specification, edits the workspace, and runs assigned focused validation. It does not independently redesign or replan the mission.
10. **Fixer returns evidence, not a bare claim.** Every Fixer return is a structured implementation receipt: status; summary; files/changes; validation with `PASS`/`FAIL`/`SKIPPED`/`UNKNOWN` evidence; deviations/blockers; and explicit parent-verification obligations. The Orchestrator reconciles the receipt against actual state.
11. **Evidence precedes plan when needed.** If facts are missing, Explorer/Librarian gather them first. The Orchestrator synthesizes evidence and creates the specification before the dependent Fixer runs.
12. **Required results are hard barriers.** A dependent plan, specification, implementation assignment, review conclusion, or final verdict does not proceed or finalize until the required child result has returned and the Orchestrator has reconciled it.
13. **No implementation fallback.** If Fixer cannot be spawned, fails, or returns a blocker, the Orchestrator rescopes, retries, redelegates, or reports the blocker. Astra/Sol never takes over the edit.
14. **Fixer does not become a planner.** Tactical choices are allowed only when they preserve the supplied plan. A material architecture/product decision goes back to the Orchestrator.
15. **Daily changes intensity, not ownership.** Daily may skip unnecessary evidence lanes, never parallelizes child calls, and has no numeric worker-call ceiling. Fixer is still mandatory for implementation.
16. **Full Pantheon earns parallelism.** Independent Explorer/Librarian/Fixer work items may overlap only when unfinished evidence cannot change an already-issued Fixer specification. Parallel Fixers require explicit non-overlapping write ownership. Dependency barriers always win over parallelism.
17. **No role theater.** There is no Oracle, Designer, Reviewer, Verifier, Council, or separate Team role in core Pantheon.
18. **One agent control plane.** Pantheon requires native MultiAgent V2. Spawn with V2 `spawn_agent`; continue through V2 `send_message`/`followup_task`. Never fall back to legacy agent APIs or generic task/thread messaging to steer a Pantheon child.
19. **Context is a cost.** Child spawns use `fork_turns: "none"`. Pass the minimum self-contained context that makes the bounded task executable; do not replay thread history by default.
20. **Bounded children.** Every specialist gets an objective, scope, known constraints/facts, permission boundary, expected output/evidence, stopping condition, and a prohibition on recursive delegation.
21. **Thin workflows.** `$pantheon*` skills are routing/instruction recipes, not a model router or custom runtime.
22. **Stateless by default.** No databases, persistent budgets, hidden mission state, task queues, daemons, or background schedulers in core Pantheon.
23. **Safe lifecycle.** Pantheon owns only its named files and marked `AGENTS.md` block; removal preserves unrelated configuration.
24. **Live verification is explicit and fail-closed.** `doctor` remains static. `pantheon verify` is opt-in because it consumes live model usage and creates normal Codex session rollouts. It only reports success when actual parent/child runtime evidence proves the requested role, routing, effective Luna High configuration, round trip, and context isolation.

## Canonical flows

Known implementation:

```text
User → Orchestrator plan/specification → Luna Fixer → receipt → Orchestrator reconcile/review/verification → User
```

Repository unknowns:

```text
User → Orchestrator scopes unknown → Luna Explorer → reconcile evidence → Orchestrator plan/specification → Luna Fixer → receipt → reconcile receipt → Orchestrator review/verification → User
```

External/version-sensitive unknowns:

```text
User → Orchestrator scopes unknown → Luna Librarian → reconcile evidence → Orchestrator plan/specification → Luna Fixer → receipt → reconcile receipt → Orchestrator review/verification → User
```

Both evidence types:

```text
Explorer/Librarian → Orchestrator reconciles/synthesizes evidence → Orchestrator plan/specification → Fixer → receipt → reconcile receipt → Orchestrator review/verification
```

Independent Full work items may overlap:

```text
Work item A: Explorer ───────────────→ Orchestrator A spec → Fixer A
Work item B: already-specified Fixer B ─────────────────────────────→ receipt B
```

The overlap is valid only because work item B does not depend on unfinished evidence from A. If a result can change a Fixer specification, that result is a barrier and the Fixer waits.

## The slim test

Before adding a feature, ask:

- Does it materially improve Orchestrator behavior or one of the three Luna lanes?
- Can it fit the existing Orchestrator/Explorer/Librarian/Fixer contract instead of adding a character?
- Does ordinary Codex remain untouched until explicit activation?
- Does it work identically under Astra and Sol unless a documented model capability requires otherwise?
- Does it preserve planning/architecture in the main thread and every implementation edit in Fixer?
- Does it preserve hard read-only boundaries for Explorer and Librarian?
- Does each required child result become a real reconciliation barrier for dependent work?
- Does Fixer return inspectable evidence instead of an unverified completion claim?
- Does it keep child spawn and follow-up traffic on the native V2 agent control plane?
- Does Daily remain meaningfully lighter without corrupting ownership?
- Does Full parallelize only genuinely independent work with safe write ownership?
- Does it minimize child context and avoid duplicate model hops?
- Does it avoid a new runtime, scheduler, database, or persistent mission state?

If the answer requires duplicated orchestration state, speculative work across unresolved dependencies, or blurring who decides versus who executes, the design is moving away from Pantheon's purpose.

> Enhance Codex. Don't replace it.
