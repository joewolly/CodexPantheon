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
10. **Evidence precedes plan when needed.** If facts are missing, Explorer/Librarian gather them first. The Orchestrator synthesizes evidence and creates the specification before Fixer runs.
11. **No implementation fallback.** If Fixer cannot be spawned, fails, or returns a blocker, the Orchestrator rescopes, retries, redelegates, or reports the blocker. Astra/Sol never takes over the edit.
12. **Fixer does not become a planner.** Tactical choices are allowed only when they preserve the supplied plan. A material architecture/product decision goes back to the Orchestrator.
13. **Daily changes intensity, not ownership.** Daily may skip unnecessary evidence lanes, never parallelizes child calls, and has no numeric worker-call ceiling. Fixer is still mandatory for implementation.
14. **Full Pantheon earns parallelism.** Parallel evidence lanes and multiple Fixers are allowed only for genuinely independent work with non-overlapping writes.
15. **No role theater.** There is no Oracle, Designer, Reviewer, Verifier, Council, or separate Team role in core Pantheon.
16. **Context is a cost.** Child spawns start with `fork_turns: "none"`. Pass the minimum self-contained context that makes the bounded task executable; do not replay thread history by default.
17. **Bounded children.** Every specialist gets an objective, scope, known constraints/facts, permission boundary, expected output/evidence, stopping condition, and a prohibition on recursive delegation.
18. **Thin workflows.** `$pantheon*` skills are routing/instruction recipes, not a model router or custom runtime.
19. **Stateless by default.** No databases, persistent budgets, hidden mission state, task queues, daemons, or background schedulers in core Pantheon.
20. **Safe lifecycle.** Pantheon owns only its named files and marked `AGENTS.md` block; removal preserves unrelated configuration.

## Canonical flows

Known implementation:

```text
User → Orchestrator plan/specification → Luna Fixer → Orchestrator review/verification → User
```

Repository unknowns:

```text
User → Orchestrator scopes unknown → Luna Explorer → Orchestrator plan/specification → Luna Fixer → Orchestrator review/verification → User
```

External/version-sensitive unknowns:

```text
User → Orchestrator scopes unknown → Luna Librarian → Orchestrator plan/specification → Luna Fixer → Orchestrator review/verification → User
```

Both evidence types:

```text
Explorer/Librarian → Orchestrator synthesizes evidence → Orchestrator plan/specification → Fixer → Orchestrator review/verification
```

## The slim test

Before adding a feature, ask:

- Does it materially improve Orchestrator behavior or one of the three Luna lanes?
- Can it fit the existing Orchestrator/Explorer/Librarian/Fixer contract instead of adding a character?
- Does ordinary Codex remain untouched until explicit activation?
- Does it work identically under Astra and Sol unless a documented model capability requires otherwise?
- Does it preserve planning/architecture in the main thread and every implementation edit in Fixer?
- Does it preserve hard read-only boundaries for Explorer and Librarian?
- Does Daily remain meaningfully lighter without corrupting ownership?
- Does it minimize child context and avoid duplicate model hops?
- Does it avoid a new runtime, scheduler, database, or persistent state?

If the answer requires duplicated orchestration state or blurring who decides versus who executes, the design is moving away from Pantheon's purpose.

> Enhance Codex. Don't replace it.