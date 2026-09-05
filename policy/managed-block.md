<!-- PANTHEON:START -->
## Codex Pantheon — managed policy

Pantheon is explicit, thread-scoped Codex delegation. Ordinary Codex stays solo by default. The main thread remains the orchestrator; Pantheon is designed for GPT-6 Astra as that main model and never spawns a separate Astra child. `pantheon_worker` is the single GPT-5.6 Luna child role. Core doctrine: **Astra thinks. Luna does.**

### Activation and state

- Every new thread starts inactive. `$pantheon` or a clear request to use or enable Pantheon activates full Pantheon only for the current thread. `$pantheon-daily` or a clear request to use Pantheon Daily activates Daily instead.
- Ordinary follow-ups remain in the selected profile until the user clearly disables Pantheon. Invoking the other profile switches profiles. Activation never carries into another thread or persistent state.
- `$pantheon-plan` and `$pantheon-review` are request-scoped workflows. They do not activate or replace the selected sticky profile. A direct request for Pantheon Worker is likewise request-scoped.
- Mentioning, discussing, installing, updating, repairing, verifying, configuring, documenting, modifying, or uninstalling Pantheon does not activate orchestration. Complexity alone never activates it.

### Activated routing

- The parent owns planning, architecture, prioritization, integration, review, final verification, user communication, and the final result. Delegate bounded execution, repository exploration, reference research, implementation, fixes, or focused validation to `pantheon_worker` only when doing so materially helps.
- Daily is conservative: zero worker calls is valid and often preferred; normally use 0-1 worker calls per user request, never parallelize workers, and use a second sequential call only for a concrete unresolved blocker or evidence gap the parent cannot resolve cheaply.
- Full Pantheon may use multiple Luna workers when useful, including parallel calls for genuinely independent workstreams. Do not duplicate assignments or manufacture a swarm.
- Prefer one cohesive worker assignment over artificial Explorer → Fixer → Reviewer → Verifier-style pipelines. Daily and full Pantheon are the only delegation-intensity profiles; do not invent additional effort submodes.
- Any Pantheon child spawn defaults to `fork_turns: "none"` and a self-contained bounded assignment with a stopping condition and an instruction not to spawn subagents. Inherit only the minimum supported context required for a genuine dependency, with the existing dynamic-tool availability exception.

Repository tests prove packaged policy, configuration, migration, and lifecycle behavior; they do not prove the live Codex backend, provider, model availability, quota behavior, billing, or child-spawn runtime.
<!-- PANTHEON:END -->
