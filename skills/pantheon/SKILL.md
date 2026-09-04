---
name: pantheon
description: Explicit, thread-scoped Codex Pantheon orchestration. Activate on $pantheon or a clear request to use, enable, or enter Pantheon orchestration. Do not activate merely because Pantheon is mentioned or is the subject or target of lifecycle, configuration, documentation, or repository work. Complexity alone never activates it.
---

# Pantheon

Pantheon is an explicit, thread-scoped routing layer. The parent Codex thread remains responsible for the mission, delegation, integration, validation, user communication, and final result.

## Thread-scoped activation state

Treat activation as conversational state in the current thread:

- Every new thread begins inactive and uses ordinary Codex behavior.
- `$pantheon` or a clear natural-language request to use, enable, or enter Pantheon orchestration activates the current thread. Activation can happen on the first message or later.
- Once active, ordinary follow-ups stay in Pantheon without repeating `$pantheon`.
- A clear request to disable Pantheon—such as “disable Pantheon,” “stop using Pantheon,” “leave Pantheon mode,” or “go back to normal mode”—returns the thread to ordinary behavior. Do not infer deactivation from vague wording.
- Deactivation clears the selected effort. Later reactivation starts at `normal` unless the user supplies an effort instruction.
- Activation and effort never carry into a new or unrelated thread, global preference, or external persistent storage. Do not create a daemon, database, background process, or hidden cross-thread state for this purpose.
- Difficulty, task length, parallelizability, quoted examples, and mere discussion do not activate or deactivate Pantheon.

### Subject versus orchestrator

Mentioning, discussing, inspecting, installing, updating, repairing, verifying, configuring, documenting, modifying, or uninstalling Codex Pantheon does not by itself activate orchestration. Those requests operate on the product, repository, or configuration and leave an inactive thread in normal Codex behavior. Activation requires separate clear intent to use, enable, or enter Pantheon as the orchestration mechanism.

For example, `Install Codex Pantheon for me.`, `Run Pantheon doctor.`, `Update the Pantheon README.`, and `How does Pantheon work?` do not activate. `$pantheon`, `Use Pantheon for this.`, `Enable Pantheon mode.`, and `Use Pantheon to update the Pantheon installer.` do activate.

The specialized `$pantheon-plan`, `$pantheon-review`, and `$pantheon-team` workflows apply only to the request that invokes them; they do not become sticky submodes. A named-agent request is valid for that request only and does not create a permanent named-agent mode.

## Progressive specialist dispatch

The parent first decides whether delegation adds material value. If it does, select one best specialist first and stop when that result is sufficient. Add another specialist only for a specific unresolved need, genuinely independent workstream, or material verification requirement. Every additional specialist must earn its place. Do not create a complexity swarm.

Use the smallest matching role:

- Known scoped change → `pantheon_fixer`.
- Unknown repository path or ownership → `pantheon_explorer`.
- Unknown external documentation or reference → `pantheon_librarian`.
- Unresolved architecture or tradeoff → `pantheon_oracle`.
- UI/UX or interaction work → `pantheon_designer`.
- Static correctness, diff, security, or regression review → `pantheon_reviewer`.
- Executable tests, builds, reproduction, or acceptance evidence → `pantheon_verifier`.

Explorer is not a Fixer preflight: when the target is known, Fixer can inspect it directly. Use Oracle only when architecture or a material tradeoff remains unresolved. Team mode is the independent-workstream exception.

For ordinary implementation, the independent check defaults to Reviewer or Verifier based on risk. Use both only when material risk requires both static and runtime evidence; never make Fixer → Reviewer → Verifier the default sequence.

## Native child context and bounded assignments

Use native child spawning and default every child to `fork_turns: "none"`. Give each child a self-contained, bounded assignment with the objective, relevant scope, constraints and known context, write permission, expected evidence/output, stopping condition, and a direct instruction not to spawn subagents.

Do not inherit context merely because it is available. Use the minimum supported inheritance only when a genuine parent dependency requires it. The sole special exception is a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default. Keep every child bounded and keep mission ownership in the parent.

## Effort

Effort changes orchestration depth, not the roster:

- Activating while inactive without an effort instruction selects `normal`.
- Say “Use deep orchestration for this task” alongside activation, or say “switch Pantheon to fast,” “use normal Pantheon effort,” or “switch Pantheon to deep” while active.
- The selected effort persists through ordinary follow-ups and a repeated bare `$pantheon` while active. It changes only when the user selects another effort or disables Pantheon.
- `fast` strongly prefers zero or one specialist; `normal` balances delegation and independent evidence; `deep` allows additional sequential research/checks within the same bounded routing rules.

## Completion and evidence

Reconcile child findings against evidence, never treat agreement as verification, and stop once the objective is answered with sufficient evidence. Ask for independent review or verification only when the risk warrants it.

Repository tests prove packaged policy/configuration and lifecycle behavior. They do not prove live Codex backend, provider, runtime, or native child-spawn availability.
