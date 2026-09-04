---
name: pantheon-team
description: Explicit Pantheon parallel-team workflow. Use only when the user explicitly invokes $pantheon-team or explicitly requests Pantheon parallel subagents/team execution.
---

# Pantheon Team

This request-scoped workflow is the independent-workstream exception. It remains parent-orchestrated and does not become a sticky team submode or change base Pantheon state or effort. The parent integrates results, resolves conflicts, validates the outcome, and owns the final answer.

## Independent workstreams only

Identify at least two genuinely independent workstreams before parallelizing. Use 2-3 concurrent agents by default; use 4+ only when the user explicitly requests broader fan-out or the task clearly contains that many substantial independent workstreams. If the work does not separate materially, use one best specialist instead of manufacturing a team. Complexity alone is not a reason to fan out. Keep workstreams exclusive or clearly separated and stop each when its assigned result is sufficient.

Add another specialist only for a specific unresolved need, genuinely independent workstream, or material verification requirement. Every additional team member must earn its place by owning a distinct substantial workstream or materially useful verification lane. Team mode permits concurrent independent workstreams, but it does not justify a complexity swarm or a default chain of Fixer → Reviewer → Verifier.

For every native child spawn, default to `fork_turns: "none"` and provide a self-contained, bounded assignment with objective, exclusive scope, constraints and known context, write permission, expected evidence/output, stopping condition, and a direct instruction not to spawn subagents. Do not inherit context merely because it is available. Use the minimum supported inheritance only when genuine parent context is required, with the sole special exception of a supported inherited fork when `fork_turns: "none"` would make a required dynamic tool unavailable. Never use full-history inheritance by default.

Keep all child work bounded and preserve unrelated changes. Independent agreement is not verification; add Reviewer or Verifier only when the material risk calls for static or runtime evidence.

Repository tests prove packaged policy/configuration and lifecycle behavior, not live backend, provider, runtime, or native child-spawn behavior.
