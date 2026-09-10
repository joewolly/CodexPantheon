---
name: pantheon
description: Explicit, thread-scoped full Codex Pantheon orchestration. Activate only on $pantheon or a clear request to use or enable Pantheon.
---

# Pantheon — Full

Activate Full Pantheon for the current thread; follow-ups remain Full until the user disables Pantheon or invokes `$pantheon-daily`. Do not persist activation across threads. This skill never switches the main model; the selected supported Codex model is the Orchestrator under the managed Pantheon policy.

For each request:
1. Understand the outcome, constraints, unknowns, and risk.
2. Use Explorer and/or Librarian only for evidence gaps that materially affect the plan. Independent read-only lanes may run in parallel.
3. The Orchestrator synthesizes evidence and creates the implementation specification before non-trivial implementation.
4. Route substantive implementation to Fixer. Multiple Fixers may run in parallel only with explicit non-overlapping write ownership.
5. Reconcile actual changes/evidence; the Orchestrator owns final review, verification, and user communication.

Do not spend an evidence call and then move substantive implementation back to the Orchestrator merely because the path became clear. Do not duplicate work or manufacture parallelism.

All child dispatch follows the managed policy's backend-native minimum-context contract: V1 uses the configured role with `fork_context: false`; V2 uses `fork_turns: "none"` and only the task-name metadata its native schema requires. Do not require a role-prefixed `task_name`; role identity comes from the configured agent selection, never the label. If the requested Luna role cannot actually be selected, fail visibly rather than impersonating it. Keep assignments bounded, self-contained, and no-subagents.
