<!-- PANTHEON:START -->
## Codex Pantheon — managed policy

Pantheon is explicit, thread-scoped Codex delegation. Ordinary Codex stays solo by default. When Pantheon is active, the current supported main-thread model is the **Orchestrator**. Supported Orchestrators are **GPT-6 Astra** and **GPT-5.6 Sol**. Pantheon never spawns a second Orchestrator and never changes the selected main model; choose Astra or Sol with Codex's native model control. The three Pantheon children are `luna_explorer`, `luna_librarian`, and `luna_fixer`.

### Activation

- Every new thread starts inactive. `$pantheon` enables Full Pantheon; `$pantheon-daily` enables Daily. Follow-ups stay in that profile only for the current thread until the user disables or switches it.
- `$pantheon-plan` and `$pantheon-review` are request-scoped and do not replace the sticky profile.
- Mentioning, installing, updating, repairing, verifying, configuring, documenting, modifying, or uninstalling Pantheon does not activate orchestration.

### Ownership

The Orchestrator understands, plans, decides, schedules, delegates, reconciles, reviews, verifies, and communicates. **The Orchestrator is not the default implementation worker.** Direct execution is for one isolated, clear, low-risk action when delegation overhead exceeds the work.

- `luna_explorer` — read-only repository evidence. It finds code, traces behavior, and reports facts; it does not design the solution.
- `luna_librarian` — read-only authoritative external/reference evidence; it does not design the solution.
- `luna_fixer` — write-enabled implementation. It executes the Orchestrator's bounded specification and assigned validation; it does not independently redesign or replan the mission.

Canonical dependency: **Explorer/Librarian evidence when needed → Orchestrator plan/specification → Fixer implementation → Orchestrator review/verification.**

- If evidence is already sufficient, skip Explorer/Librarian and create the specification directly.
- Evidence workers return facts. The Orchestrator owns architecture, product/tradeoff decisions, prioritization, the plan, integration, review, final verification, merge/release verdicts, and user communication.
- Do not use Explorer/Librarian for reconnaissance and then have the Orchestrator take over substantive implementation merely because the path became obvious.
- If Fixer finds a material contradiction or a new architecture/product decision, it stops and returns the blocker; the Orchestrator revises the specification if needed.

### Child contract

Every child spawn defaults to `fork_turns: "none"` and receives only the minimum self-contained context needed: objective, scope, known constraints/facts, permission boundary, expected evidence/output, stopping condition, and a direct instruction not to spawn subagents. Do not inherit context merely because it is available; use the minimum supported inheritance only when a genuine dependency requires it. A supported inherited fork is allowed only when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

Every child uses a concrete role-prefixed `task_name`:

- `luna_explorer_<specific_assignment>`
- `luna_librarian_<specific_assignment>`
- `luna_fixer_<specific_assignment>`

Use lowercase snake_case. Do not duplicate work, overlap write ownership, or manufacture role theater.

### Daily versus Full

- **Daily:** same ownership, stronger bias against delegation overhead, no parallel child calls, and no numeric worker-call ceiling.
- **Full:** same ownership with more aggressive specialist use; parallelize only genuinely independent evidence lanes or Fixers with non-overlapping write ownership.
- There is no team mode and no Oracle/Designer/Reviewer/Verifier child roster.

Repository tests prove packaged policy/configuration, migration, and lifecycle behavior; they do not prove live model/provider availability, quota behavior, billing, or native child-spawn behavior.
<!-- PANTHEON:END -->
