# Codex Pantheon Design Doctrine

Codex Pantheon is a slim, explicit, Codex-native delegation layer. It exists to make an Astra-led Codex session selectively more capable without turning Pantheon into its own agent platform.

> **Astra thinks. Luna does. Pantheon controls how much Luna Astra is allowed to use.**

## Non-negotiable principles

1. **Solo by default** — installing Pantheon changes no ordinary prompt behavior. Every new thread begins with zero Pantheon delegation.
2. **Explicit activation** — complexity is not consent. Only `$pantheon`, `$pantheon-daily`, or a clear equivalent request activates a sticky Pantheon profile.
3. **Astra is the parent, not a child** — Pantheon is designed for GPT-6 Astra as the main Codex model. Do not create a separate Astra orchestrator subagent or move mission ownership out of the parent thread.
4. **One child role** — core Pantheon has one subagent: `pantheon_worker` on GPT-5.6 Luna. Add capabilities to the worker before adding characters.
5. **Astra owns thinking** — planning, architecture, prioritization, integration, review, final verification judgment, merge/release verdicts, and user communication remain in the parent.
6. **Luna owns bounded execution** — exploration, reference research, implementation, fixes, and focused validation/evidence are the worker's job when delegation helps.
7. **No role theater** — do not reproduce Explorer → Fixer → Reviewer → Verifier pipelines with multiple copies of the same worker. One cohesive assignment is better when it can safely cover discovery through focused validation.
8. **Two intensity controls only** — Pantheon Daily is conservative; full Pantheon permits heavier delegation and justified parallelism. There is no fast/normal/deep effort layer and no separate team mode.
9. **Daily protects usage** — zero worker calls is healthy. Normally use 0-1 Luna calls per request, no parallel workers, and a second sequential call only for a concrete unresolved blocker/evidence gap.
10. **Full Pantheon earns parallelism** — multiple Luna workers are allowed only when their workstreams are genuinely independent or a concrete additional execution/evidence lane is needed. Complexity alone never creates a swarm.
11. **Context is a cost** — child spawns start with `fork_turns: "none"` and self-contained assignments. Inherit only the minimum required context.
12. **Bounded agents** — every worker gets an objective, scope, permission boundary, expected evidence, and stopping condition. Workers never recursively delegate.
13. **Verification is evidence, not agreement** — Astra decides what the evidence proves. A worker may run tests or reproduction, but does not replace the parent's final review judgment.
14. **Thin workflows** — `$pantheon*` skills are routing/instruction recipes, not a custom runtime.
15. **Stateless by default** — no databases, hidden mission state, persistent budgets, quota trackers, task queues, daemons, or background schedulers in core Pantheon.
16. **Safe lifecycle** — Pantheon owns only its named files and a clearly marked block in `AGENTS.md`; updates may remove Pantheon-owned legacy paths from prior releases, but unrelated user configuration is preserved.
17. **Easy removal** — uninstalling Pantheon returns the environment to normal Codex without reconstruction.
18. **Low maintenance is a feature** — prefer native Codex capabilities, configuration, skills, and small scripts over dependencies on unstable internals.

## The slim test

Before adding a feature, ask:

- Does it make Astra + Luna delegation materially better?
- Can the capability fit inside the existing worker or a thin skill instead of a new agent?
- Does ordinary Codex remain untouched until the user explicitly opts in?
- Does it avoid a new orchestration layer, scheduler, database, or persistent state?
- Does it keep context and worker calls no larger than evidence requires?
- Does Daily remain meaningfully cheaper/lighter than full Pantheon?
- Can a user still explain the whole architecture as “Astra thinks, Luna does”?

If the answer to the last question becomes no, Pantheon is probably getting too heavy.

> Enhance Codex. Don't replace it.
