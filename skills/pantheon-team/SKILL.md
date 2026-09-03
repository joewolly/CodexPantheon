---
name: pantheon-team
description: Explicit Pantheon parallel-team workflow. Use only when the user explicitly invokes $pantheon-team or explicitly requests Pantheon parallel subagents/team execution.
---

# Pantheon Team

This workflow deliberately permits broader parallelism, but it remains bounded and parent-orchestrated.

Rules:

1. Identify independent workstreams before spawning anyone.
2. Use 2-3 concurrent Pantheon agents by default.
3. Use 4+ only when the user explicitly asks for broader fan-out or the task clearly contains that many independent substantial workstreams.
4. If the task does not contain at least two useful independent workstreams, fall back to one specialist rather than manufacturing duplicate work.
5. Give each agent exclusive or clearly separated scope when writes are possible.
6. Avoid parallel write-heavy work against the same files or subsystem unless the user explicitly accepts the coordination cost.
7. Every child receives a concrete bounded assignment and an instruction not to spawn subagents.
8. The parent stays active: perform local integration/planning work while agents run when useful, then wait for required results and reconcile them.
9. Agent agreement is not verification. Use `pantheon_reviewer` or `pantheon_verifier` independently when the risk warrants it.
10. The parent owns final integration, conflict resolution, validation, and the user-facing result.

Prefer parallel read-heavy exploration/research/verification over a swarm of simultaneous editors.
