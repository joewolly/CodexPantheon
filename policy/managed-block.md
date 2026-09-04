<!-- PANTHEON:START -->
## Codex Pantheon — managed policy

Pantheon is a slim, explicit, Codex-native multi-agent layer. It augments Codex; it does not replace the parent Codex thread or create an always-on orchestration runtime.

### Activation

- Pantheon is opt-in and thread-scoped. Every new thread begins with Pantheon inactive and ordinary Codex behavior.
- `$pantheon` or a clear natural-language request to use, enable, or enter Pantheon orchestration activates it for the current thread, whether on the first message or later.
- Once activated, continue using Pantheon for ordinary follow-up requests in that thread without requiring the user to repeat `$pantheon`.
- Clear explicit intent such as “disable Pantheon,” “stop using Pantheon,” “leave Pantheon mode,” or “go back to normal mode” deactivates it. Do not infer activation or deactivation from vague wording.
- After deactivation, use normal non-Pantheon behavior until explicit reactivation. Never carry activation into a new or unrelated thread.
- `$pantheon-plan`, `$pantheon-review`, and `$pantheon-team` remain explicit workflows for the request that invokes them; they do not become independently sticky submodes.
- An explicit request for a named Pantheon agent remains valid for that request. It does not create a sticky named-agent mode.
- Do not activate or deactivate Pantheon merely because a task is difficult, long, or parallelizable. Vague wording, quoted examples, and mere discussion of Pantheon do not change the state.
- A product or subject mention is not an activation signal. Mentioning, discussing, inspecting, installing, updating, repairing, verifying, configuring, documenting, modifying, or uninstalling Codex Pantheon by itself leaves an OFF thread OFF; lifecycle operations such as `./pantheon bootstrap`, `./pantheon doctor`, and `./pantheon uninstall` are ordinary Codex work, not orchestration.
- Only `$pantheon` or separate clear intent to use, enable, or enter Pantheon as the orchestration mode transitions an OFF thread to ON. Discussion, examples, and quoted text do not transition the state.

Track the current mode from explicit activation and deactivation in the conversation. Do not create a daemon, database, global preference, external store, or hidden cross-thread state.

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

When Pantheon is inactive, activation uses `normal` effort unless the user supplies a clear conversational effort instruction. Select the skill with `$pantheon`; do not require or recommend appending effort words to that skill-picker invocation. An effort instruction supplied with activation, such as “Use deep orchestration for this task,” selects that effort. While Pantheon is active, clear instructions such as “switch Pantheon to fast,” “use normal Pantheon effort,” or “switch Pantheon to deep” change it without another skill invocation. The selected effort persists for subsequent requests; ordinary follow-ups and a repeated bare `$pantheon` do not reset it. Deactivation clears the effort, so reactivation without an effort instruction uses `normal` rather than restoring an earlier selection. “Use normal Pantheon effort” keeps Pantheon active, while a clear request to “go back to normal mode” deactivates it.

`fast`, `normal`, and `deep` modify orchestration depth, not the agent roster. Fast strongly minimizes delegation; normal balances specialization and verification; deep allows more research and independent checking while still obeying fan-out limits.

Pantheon design rule: enhance Codex; do not replace it.
<!-- PANTHEON:END -->
