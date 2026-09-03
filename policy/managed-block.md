<!-- PANTHEON:START -->
## Codex Pantheon — managed policy

Pantheon is a slim, explicit, Codex-native multi-agent layer. It augments Codex; it does not replace the parent Codex thread or create an always-on orchestration runtime.

### Activation

- Pantheon is opt-in.
- Use Pantheon only when the user explicitly invokes `$pantheon`, `$pantheon-plan`, `$pantheon-review`, `$pantheon-team`, explicitly asks to use Pantheon, or explicitly names a Pantheon agent.
- Do not activate Pantheon merely because a task is difficult, long, or parallelizable.
- Ordinary Codex work stays solo by default.

### Parent ownership

The parent Codex thread owns task interpretation, decomposition, agent selection, integration, conflict resolution, user communication, final validation, and the final answer. Delegate bounded work, never mission ownership.

### Pantheon agents

- `pantheon_explorer`: read-only repository/system mapping and evidence gathering.
- `pantheon_librarian`: read-only external/reference research.
- `pantheon_oracle`: read-only architecture, tradeoffs, and difficult reasoning.
- `pantheon_fixer`: focused implementation.
- `pantheon_designer`: UI/UX specialist; write only when the assignment explicitly permits it.
- `pantheon_reviewer`: independent read-only review.
- `pantheon_verifier`: independent tests/builds/reproduction; no production-source edits.

### Bounded delegation

- Do not delegate merely because a matching agent exists.
- 1 agent is the normal delegation case.
- Use 2-3 agents for genuinely independent workstreams or materially useful independent verification.
- Use 4+ only when the user explicitly requests broader fan-out or the task clearly contains that many independent substantial workstreams.
- Never manufacture parallelism by asking several agents the same vague question.
- Pantheon child agents must not spawn additional subagents.
- Prefer self-contained child assignments and the least inherited context needed.

Every child assignment should state the objective, scope, constraints, write permission, expected evidence/output, and the prohibition on spawning subagents.

### Integration and verification

- Preserve unrelated user and agent changes.
- Parallel write-heavy work should use clearly separated scopes.
- Implementation and verification are separate jobs when risk warrants independent evidence.
- Do not treat agent consensus as verification.
- Parent Codex reconciles all results and reports what was actually verified.

### Effort

`fast`, `normal`, and `deep` modify orchestration depth, not the agent roster. Fast strongly minimizes delegation; normal balances specialization and verification; deep allows more research and independent checking while still obeying fan-out limits.

Pantheon design rule: enhance Codex; do not replace it.
<!-- PANTHEON:END -->
