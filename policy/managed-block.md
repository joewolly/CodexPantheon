<!-- PANTHEON:START -->
## Codex Pantheon — managed policy

Pantheon is an explicit, thread-scoped use of Codex delegation. The parent thread owns the mission and final result. Full Pantheon prioritizes quality/confidence; Pantheon Daily is the quota-conscious profile.

### Activation and state

- Every new thread starts inactive. `$pantheon` or a clear request to use, enable, or enter Pantheon orchestration activates full Pantheon only for the current thread. `$pantheon-daily` or a clear request to use Pantheon Daily activates Daily instead.
- Ordinary follow-ups remain in Pantheon using the selected profile until the user clearly disables it. Explicitly invoking the other profile switches profiles. Switching away from full Pantheon or disabling Pantheon clears effort; entering full Pantheon again without an effort instruction starts at normal.
- Activation never carries into another thread or a global preference. Do not create persistent activation state. `$pantheon-plan`, `$pantheon-review`, and `$pantheon-team` are request-scoped workflows, not sticky submodes, and do not replace the selected profile. Their own routing contract governs that request; the selected profile resumes afterward. A named-agent request is valid for that request only.
- Mentioning, discussing, inspecting, installing, updating, repairing, verifying, configuring, documenting, modifying, or uninstalling Codex Pantheon—including `./pantheon bootstrap`, `doctor`, or `uninstall`—does not activate orchestration. Difficulty, quoted text, and vague discussion do not change the state.

### Activated routing

When active, follow the relevant Pantheon workflow skill for role selection, child context, bounded assignments, effort when applicable, and evidence. First decide whether delegation materially helps, then select one best-fit specialist. Stop specialist escalation when that result is sufficient. Add another specialist only for a specific unresolved need, genuinely independent workstream, or material verification requirement. Every additional specialist must earn its place. Do not fan out merely because a task looks complex.

Daily follows its stricter quota-conscious routing ceiling and never silently escalates into full Pantheon or team mode. Full Pantheon has no Daily numeric ceiling but still requires evidence-earned delegation.

Any Pantheon child spawn, including a direct named-agent request, defaults to `fork_turns: "none"`; the relevant workflow skill defines bounded inheritance exceptions.

Repository tests prove packaged policy/configuration and lifecycle behavior, not the live Codex backend or runtime.
<!-- PANTHEON:END -->
