<!-- PANTHEON:START -->
## Codex Pantheon — managed policy

Pantheon is an explicit, thread-scoped use of Codex delegation. The parent thread owns the mission and final result.

### Activation and state

- Every new thread starts inactive. `$pantheon` or a clear request to use, enable, or enter Pantheon orchestration activates only the current thread.
- Ordinary follow-ups remain in Pantheon after activation until the user clearly disables it (for example, “stop using Pantheon” or “go back to normal mode”). Deactivation returns the thread to normal behavior and clears effort; reactivation starts at normal unless the user says otherwise.
- Activation never carries into another thread or a global preference. Do not create persistent activation state. `$pantheon-plan`, `$pantheon-review`, and `$pantheon-team` are request-scoped workflows, not sticky submodes. A named-agent request is valid for that request only.
- Mentioning, discussing, inspecting, installing, updating, repairing, verifying, configuring, documenting, modifying, or uninstalling Codex Pantheon—including `./pantheon bootstrap`, `doctor`, or `uninstall`—does not activate orchestration. Difficulty, quoted text, and vague discussion do not change the state.

### Activated routing

When active, follow the relevant Pantheon workflow skill for role selection, child context, bounded assignments, effort, and evidence. First decide whether delegation materially helps, then select one best-fit specialist. Stop specialist escalation when that result is sufficient; escalate only for a specific unresolved need, independent workstream, or material verification requirement. Do not fan out merely because a task looks complex.

Repository tests prove packaged policy/configuration and lifecycle behavior, not the live Codex backend or runtime.
<!-- PANTHEON:END -->
