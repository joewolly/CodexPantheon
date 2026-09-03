# Codex Pantheon Design Doctrine

Codex Pantheon is a slim, explicit, Codex-native multi-agent layer. Its purpose is to improve specialist delegation without replacing Codex with a second orchestration platform.

## Non-negotiable principles

1. **Native first** — use Codex subagents, skills, configuration, tools, and normal files before adding Pantheon machinery.
2. **Solo by default** — installation must not cause ordinary prompts to fan out automatically.
3. **Explicit activation** — complexity is not consent to orchestrate.
4. **Parent owns the mission** — the parent thread owns decomposition, integration, validation, and the final answer.
5. **Bounded agents** — every agent gets a concrete assignment and stopping condition; child agents do not recursively delegate.
6. **Small roster** — add capabilities before adding characters. Core roles are Explorer, Librarian, Oracle, Fixer, Designer, Reviewer, and Verifier.
7. **Minimum useful fan-out** — one agent is normal; parallelism must be earned by independent workstreams.
8. **Verification is first-class** — confidence comes from evidence, not agreement between agents.
9. **Thin workflows** — `$pantheon*` skills are routing recipes, not a custom workflow runtime.
10. **Scale effort, not roster size** — fast/normal/deep change orchestration depth rather than multiplying agent definitions.
11. **Stateless by default** — no databases, task queues, daemons, hidden mission state, or background schedulers in core Pantheon.
12. **No automatic mode detection** — Pantheon never intercepts ordinary prompts to decide it should activate itself.
13. **Safe lifecycle** — Pantheon owns only Pantheon files and a clearly marked block in `AGENTS.md`.
14. **Easy removal** — uninstalling Pantheon must return the user to normal Codex without rebuilding their environment.
15. **Low maintenance is a feature** — avoid dependencies on unstable Codex internals and do not reimplement native capabilities.

## The slim test

Before adding a feature, ask:

- Does it improve the way Codex uses native agents?
- Can configuration, a skill, or a small script solve it?
- Does it preserve explicit user control?
- Does it work without an always-on runtime?
- Does Pantheon remain understandable and easy to remove afterward?

If most answers are yes, the feature probably belongs. If it requires Pantheon to become its own agent platform, scheduler, execution environment, or workflow engine, it probably does not.

> Enhance Codex. Don't replace it.
