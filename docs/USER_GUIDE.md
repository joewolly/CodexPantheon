# Codex Pantheon User Guide

Pantheon v0.5 is intentionally simple: **GPT-6 Astra stays in the main Codex thread and GPT-5.6 Luna is the single optional worker.** Pantheon stays inactive until you explicitly ask to use it.

> **Astra thinks. Luna does.**

## 1. Install and verify

Open this repository in Codex and ask:

```text
Install Codex Pantheon for me.
```

Codex runs:

```bash
./pantheon bootstrap
```

That lifecycle request does not activate Pantheon. For manual setup, see [CODEX_INSTALL.md](CODEX_INSTALL.md). For commands and owned paths, see [CLI_REFERENCE.md](CLI_REFERENCE.md).

## 2. Understand the two roles

| Role | Model | Responsibility |
| --- | --- | --- |
| Main thread / orchestrator | GPT-6 Astra | Plan, decide, architect, integrate, review, judge final verification, communicate, own final result |
| `pantheon_worker` | GPT-5.6 Luna High | Explore, research, implement, fix, run focused validation, return evidence |

Astra is not an installed subagent. Pantheon assumes you selected Astra as your main Codex model; it does not auto-switch the parent model or spawn an Astra child.

There is no longer a seven-agent specialist roster. The one Luna worker receives task-specific instructions instead of changing personalities.

## 3. Choose an operating profile

Every new thread starts in ordinary Codex mode.

| Profile | Activate with | Delegation posture |
| --- | --- | --- |
| Ordinary Codex | default / `Stop using Pantheon.` | No Pantheon worker calls |
| Pantheon Daily | `$pantheon-daily` | Conservative: normally 0-1 Luna calls per request; no parallel workers |
| Full Pantheon | `$pantheon` | Higher intensity: multiple Luna calls allowed; parallel only for genuinely independent workstreams |

The selected Pantheon profile is sticky only inside the current thread. Invoke the other profile to switch. Say `Stop using Pantheon.` to return to ordinary Codex. Nothing persists across threads.

### Pantheon Daily

```text
$pantheon-daily

Fix the API retry regression and run the focused tests.
```

Daily is designed to conserve usage. Zero Luna calls is a good outcome when Astra can finish cheaply itself. If delegation helps, Astra normally sends one cohesive task to Luna. For example, Luna can inspect the relevant code, find the implementation point, make the scoped fix, and run focused validation in one call.

Daily never parallelizes Luna workers. A second sequential call is reserved for a concrete unresolved blocker or evidence gap that Astra cannot resolve cheaply.

### Full Pantheon

```text
$pantheon

Implement the storage migration. Parallelize server and client work only if they are genuinely independent.
```

Full Pantheon uses the same roles with a higher delegation allowance. Astra may use multiple Luna workers and parallel workstreams when that materially improves execution. There is no separate `$pantheon-team` mode.

Pantheon v0.5 also removes fast/normal/deep effort levels. **Daily versus full is the intensity choice.**

## 4. What Astra should delegate

Luna is appropriate for bounded execution:

- repository or local-system exploration;
- external/reference research available to the child;
- implementation, refactoring, and bug fixes;
- focused tests, builds, reproduction, or acceptance evidence.

Astra keeps:

- problem framing and decomposition;
- architecture and tradeoff decisions;
- prioritization and sequencing;
- integration across worker results;
- final code/diff review;
- final verification judgment;
- merge/release verdicts and user communication.

Do not manufacture specialist stages. If one Luna assignment can safely cover exploration through implementation and validation, prefer that over separate calls.

## 5. Keep worker context small

Native child spawns default to `fork_turns: "none"` with a self-contained assignment. Give Luna the objective, relevant scope, constraints/known context, write permission, expected evidence/output, stopping condition, and an instruction not to spawn subagents.

Do not inherit context merely because it is available. Use the minimum supported inheritance only when a genuine parent dependency requires it. A supported inherited fork is acceptable when no inheritance would make a required dynamic tool unavailable. Never use full-history inheritance by default.

If the assignment is research, planning support, or review support, explicitly make it read-only. If it is implementation, authorize only the necessary scope.

## 6. Use the request-scoped workflows

These workflows apply only to the request that invokes them. They do not activate or replace the current sticky Daily/full profile.

### Plan without implementing

```text
$pantheon-plan Plan the multi-workspace migration, including validation and rollback, but do not implement it.
```

Astra owns the plan. Luna is optional and read-only, used only for repository or reference evidence that materially improves planning.

### Review with Pantheon

```text
$pantheon-review Review this branch against main and give me a merge verdict.
```

Astra performs the actual review and owns the verdict. Luna may gather bounded evidence: map a specific code path, confirm an external requirement, run tests/builds, reproduce a suspected regression, or provide a read-only second opinion on a narrowly defined question when independent inspection materially helps. Luna does not become a dedicated Reviewer persona.

### Direct worker request

You can explicitly request Luna for a single bounded request without activating a sticky profile:

```text
Use Pantheon Worker to map the authentication flow. Do not change files.
```

## 7. Write effective requests

You do not need to design the agent topology. State the outcome and important constraints.

Daily example:

```text
$pantheon-daily

Fix the retry regression. Preserve the public API, change only the client and its tests, and run the focused test target.
```

Full example:

```text
$pantheon

Implement the storage migration. Keep Astra responsible for architecture and review; use Luna for implementation and execution evidence. Parallelize only independent work.
```

## 8. Understand the evidence

A Luna report proves only what it actually inspected or executed. A passing test does not prove every static correctness property, and two workers agreeing is not stronger evidence by itself. Astra reconciles evidence and decides what remains unproven.

`./pantheon doctor` verifies static installation files, migration cleanup, and managed policy drift. It does not prove live child-spawn availability, model access, provider behavior, quota usage, or billing.

## 9. Upgrade from v0.4

Run:

```bash
./pantheon bootstrap
```

v0.5 removes Pantheon's old seven specialist agent files and the `pantheon-team` skill, installs `pantheon-worker.toml`, updates the four remaining workflow skills, and replaces the managed policy block.

The old direct specialist names and fast/normal/deep effort semantics are intentionally gone. Use `pantheon_worker` for bounded execution, `$pantheon-daily` for conservative delegation, and `$pantheon` when heavier/parallel delegation is justified.

## 10. Update, repair, or remove Pantheon

```bash
./pantheon bootstrap   # install/update + doctor
./pantheon doctor      # read-only verification
./pantheon uninstall   # remove Pantheon-owned current and legacy paths
```

Uninstall preserves unrelated Codex agents, skills, and text outside Pantheon's managed `AGENTS.md` block.
