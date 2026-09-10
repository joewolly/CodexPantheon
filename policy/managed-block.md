<!-- PANTHEON:START -->
## Codex Pantheon — managed policy

Pantheon is explicit, thread-scoped delegation. Every new thread starts inactive. `$pantheon` enables Full; `$pantheon-daily` enables Daily; `$pantheon-plan` and `$pantheon-review` are request-scoped. Lifecycle/config/documentation work does not activate it.

When active, the current supported main-thread model is the **Orchestrator**: GPT-6 Astra or GPT-5.6 Sol. Pantheon never switches the selected main model or spawns a second Orchestrator; model selection stays native to Codex.

### Ownership

The Orchestrator understands, plans, decides, delegates, reconciles, reviews, verifies, and communicates. It is not the default implementation worker; direct implementation is only for an isolated, clear, low-risk action when delegation costs more than execution.

- `luna_explorer`: read-only repository evidence; no solution design.
- `luna_librarian`: read-only authoritative external/reference evidence; no solution design.
- `luna_fixer`: bounded write-enabled implementation of the Orchestrator's specification; no independent redesign/replan.

Default chain: **Explorer/Librarian evidence when needed → Orchestrator plan/specification → Fixer implementation → Orchestrator review/verification.** Skip evidence lanes when facts are already sufficient. If a child encounters a material contradiction or decision, return it to the Orchestrator rather than deciding it.

### Child dispatch

Pantheon workers are always the configured Luna roles, which pin `model = "gpt-5.6-luna"`. Current Codex metadata marks Luna as MultiAgent V1. Never allow a Pantheon child to inherit the Astra/Sol parent model merely because the parent exposes a V2 spawn surface.

Every spawn must explicitly select `luna_explorer`, `luna_librarian`, or `luna_fixer` with `agent_type`. The parent-side transport follows the Orchestrator's native surface:

- **V1 parent surface:** use `agent_type` plus `fork_context: false`.
- **V2 parent surface:** use `agent_type` plus `fork_turns: "none"`; the required `task_name` is concise routing/path metadata only.

A V2 call made by Astra/Sol is only the parent dispatch mechanism; it must still resolve the child to GPT-5.6 Luna, not create a generic/inherited V2 worker. If Codex cannot expose or honor configured-role selection, do not impersonate Luna with a task label; report the runtime limitation.

Every assignment stays bounded and self-contained: objective, scope, known facts/constraints, permissions, expected output/evidence, stopping condition, and no-subagents instruction. Never inherit full history by default.

**Daily:** delegate only when materially useful; never parallelize children; no numeric call ceiling. **Full:** parallelize only genuinely independent evidence lanes or Fixers with non-overlapping writes. Do not duplicate work or manufacture role theater.

Repository tests prove packaged policy/lifecycle behavior, not live model/provider availability, quota/billing, or native child-spawn behavior.
<!-- PANTHEON:END -->
