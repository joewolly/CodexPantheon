# Codex Pantheon Design Doctrine

Codex Pantheon is a slim, explicit, Codex-native multi-agent layer. Its purpose is to improve specialist delegation without replacing Codex with a second orchestration platform.

## Non-negotiable principles

1. **Native first, context deliberate** — use Codex subagents, skills, configuration, tools, and normal files before adding Pantheon machinery; context is a cost, so start with self-contained minimal context and expand it only when evidence requires.
2. **Solo by default** — installation must not cause ordinary prompts to fan out automatically.
3. **Explicit activation** — complexity is not consent to orchestrate.
4. **Parent owns the mission** — the parent thread owns decomposition, integration, validation, and the final answer.
5. **Bounded agents** — every agent gets a concrete assignment and stopping condition; child agents do not recursively delegate.
6. **Small roster** — add capabilities before adding characters. Core roles are Explorer, Librarian, Oracle, Fixer, Designer, Reviewer, and Verifier.
7. **Progressive escalation** — the parent decides whether delegation adds material value and selects one best specialist first. Add another specialist only for a specific unresolved need, genuinely independent workstream, or material verification requirement; every additional specialist must earn its place. Team mode is the independent-workstream exception, with 2-3 agents as its normal range; complexity alone never creates a swarm.
8. **Distinct operating profiles** — ordinary Codex minimizes orchestration overhead; Pantheon Daily is explicitly quota-conscious and keeps specialist calls tightly bounded; full Pantheon prioritizes quality/confidence and may spend additional included capacity when the marginal value is real. Never silently switch profiles.
9. **Verification is first-class** — confidence comes from evidence, not agreement between agents.
10. **Thin workflows** — `$pantheon*` skills are routing recipes, not a custom workflow runtime.
11. **Risk-matched verification** — ordinary implementation uses Reviewer or Verifier based on risk; both are used only when static and runtime evidence are materially necessary. There is no default Fixer → Reviewer → Verifier chain.
12. **Scale effort, not roster size** — fast/normal/deep change full-Pantheon orchestration depth rather than multiplying agent definitions. Daily is a separate routing profile, not another effort level.
13. **Stateless by default** — no databases, task queues, daemons, hidden mission state, persistent quota budgets, or background schedulers in core Pantheon.
14. **No automatic mode detection** — Pantheon never intercepts ordinary prompts to decide it should activate or switch profiles itself.
15. **Safe lifecycle** — Pantheon owns only Pantheon files and a clearly marked block in `AGENTS.md`.
16. **Easy removal** — uninstalling Pantheon must return the user to normal Codex without rebuilding their environment.
17. **Low maintenance is a feature** — avoid dependencies on unstable Codex internals and do not reimplement native capabilities.

The concise routing map is: known scoped change → Fixer; unknown repository path/ownership → Explorer; unknown external reference → Librarian; unresolved architecture → Oracle; UI/UX → Designer; static correctness/diff/security/regression → Reviewer; executable tests/builds/reproduction/acceptance → Verifier. Explorer is not a Fixer preflight, Fixer can inspect a known target, and Oracle is only for unresolved architecture.

Pantheon Daily tightens that map further: the parent may handle low-risk implementation directly, normally uses no more than two specialist calls per user request, permits a third only for a concrete unresolved blocker/risk/evidence gap, and never uses four or more. Full Pantheon has no Daily numeric ceiling, but every additional specialist still requires material value.

Native child spawns, including direct named-agent requests, default to `fork_turns: "none"` and self-contained assignments. Use only the minimum supported inherited context for a genuine parent dependency, with a special inherited-fork exception only when no inheritance would make a required dynamic tool unavailable; full-history inheritance is never the default. Child handoffs are delta-only and stop when sufficient evidence answers the objective.

## The slim test

Before adding a feature, ask:

- Does it improve the way Codex uses native agents?
- Can configuration, a skill, or a small script solve it?
- Does it preserve explicit user control?
- Does it work without an always-on runtime?
- Does it keep context and fan-out no larger than the selected profile and evidence require?
- Does Pantheon remain understandable and easy to remove afterward?

If most answers are yes, the feature probably belongs. If it requires Pantheon to become its own agent platform, scheduler, execution environment, quota meter, or workflow engine, it probably does not.

> Enhance Codex. Don't replace it.