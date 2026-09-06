# Codex Pantheon Design Doctrine

Codex Pantheon is a slim, explicit, Codex-native orchestration layer. It exists to give an Astra-led Codex session the proven shape of an Orchestrator with specialized execution lanes without turning Pantheon into a separate agent runtime.

> **Astra plans. Luna specialists execute their lane.**

Pantheon v0.6 adapts the core Orchestrator, Explorer, Librarian, and Fixer role semantics from the MIT-licensed `oh-my-opencode-slim` project to Codex-native custom agents. OpenCode-specific plugin, TUI, scheduler, job-board, and SDK machinery is intentionally not ported.

## Non-negotiable principles

1. **Solo by default.** Installing Pantheon changes no ordinary prompt behavior. Every new thread starts inactive.
2. **Explicit activation.** Only `$pantheon`, `$pantheon-daily`, or a clear equivalent request activates a sticky Pantheon profile.
3. **Astra is the Orchestrator.** GPT-6 Astra remains the main thread. It understands, plans, schedules, delegates, reconciles, reviews, verifies, and communicates. It is not installed as a child.
4. **Astra is not the default implementer.** It may directly perform one isolated, clear, low-risk action when delegation overhead exceeds execution. Substantive implementation normally routes to Fixer.
5. **Astra owns decisions.** Architecture, product behavior, tradeoffs, prioritization, sequencing, implementation specifications, cross-lane integration, final review, verification judgment, and merge/release verdicts remain with Astra.
6. **Explorer owns repository evidence.** `luna_explorer` is read-only. It locates files/symbols, traces behavior, maps ownership/dependencies, and reports evidence. It does not design the solution.
7. **Librarian owns external evidence.** `luna_librarian` is read-only. It researches official docs, APIs, upstream behavior, standards, version-sensitive facts, and authoritative examples. It does not design the solution.
8. **Fixer owns bounded implementation.** `luna_fixer` receives Astra's scoped implementation specification, edits the workspace, and runs assigned focused validation. It does not independently redesign or replan the mission.
9. **Evidence precedes plan when needed.** If Astra lacks facts, Explorer/Librarian gather them first. Astra synthesizes them and creates the implementation plan before Fixer runs.
10. **Do not invert ownership after research.** Explorer/Librarian evidence must not become an excuse for Astra to take over substantive implementation simply because the path is now obvious.
11. **Fixer does not become a planner.** Local tactical choices are allowed only when they preserve Astra's plan. A material architecture/product decision goes back to Astra.
12. **Daily changes intensity, not ownership.** Daily uses the same roles, never parallelizes child calls, and has no numeric worker-call ceiling. Sequential evidence → Astra plan → Fixer is valid when necessary.
13. **Full Pantheon earns parallelism.** Parallel Explorer/Librarian lanes and multiple Fixers are allowed only for genuinely independent work with non-overlapping writes.
14. **No role theater.** There is no Oracle, Designer, Reviewer, Verifier, Council, or separate Team role in core Pantheon. Astra owns judgment; the three Luna roles own distinct execution/evidence lanes.
15. **Context is a cost.** Child spawns start with `fork_turns: "none"` and self-contained assignments. Inherit only the minimum required context.
16. **Bounded children.** Every specialist receives an objective, scope, permission boundary, expected output/evidence, stopping condition, and a prohibition on recursive delegation.
17. **Thin workflows.** `$pantheon*` skills are routing/instruction recipes, not a custom runtime.
18. **Stateless by default.** No databases, persistent budgets, hidden mission state, task queues, daemons, or background schedulers in core Pantheon.
19. **Safe lifecycle.** Pantheon owns only its named files and marked `AGENTS.md` block. Update/migration may remove only explicitly Pantheon-owned legacy paths.
20. **Easy removal.** Uninstall returns the environment to ordinary Codex while preserving unrelated configuration.

## Canonical flows

Known implementation:

```text
User → Astra plan/specification → Luna Fixer → Astra review/verification → User
```

Repository unknowns:

```text
User → Astra scopes unknown → Luna Explorer → Astra plan/specification → Luna Fixer → Astra review/verification → User
```

External/version-sensitive unknowns:

```text
User → Astra scopes unknown → Luna Librarian → Astra plan/specification → Luna Fixer → Astra review/verification → User
```

Both evidence types:

```text
Explorer/Librarian → Astra synthesizes evidence → Astra plan/specification → Fixer → Astra review/verification
```

## The slim test

Before adding a feature, ask:

- Does it make Astra's orchestration or one of the three Luna lanes materially better?
- Can it fit in the existing Orchestrator/Explorer/Librarian/Fixer contract instead of adding a character?
- Does ordinary Codex remain untouched until explicit activation?
- Does it keep planning/architecture with Astra and implementation with Fixer?
- Does it preserve hard read-only boundaries for Explorer and Librarian?
- Does Daily remain meaningfully lighter without corrupting ownership?
- Does it avoid a new runtime, scheduler, database, or persistent state?

If the answer requires blurring who decides versus who executes, the design is moving away from Pantheon's purpose.

> Enhance Codex. Don't replace it.
