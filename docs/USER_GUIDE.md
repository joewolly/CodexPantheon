# Codex Pantheon User Guide

Pantheon adds a small set of specialist agents and explicit workflows to Codex. It stays inactive until you ask to use it, and the parent Codex thread always remains responsible for the mission.

## 1. Install and verify

The recommended path is to open this repository in Codex and ask:

```text
Install Codex Pantheon for me.
```

Codex runs the bounded bootstrap command:

```bash
./pantheon bootstrap
```

For manual setup and troubleshooting, see [CODEX_INSTALL.md](CODEX_INSTALL.md).
For a consolidated command, path, environment-variable, and exit-behavior reference, see the [CLI reference](CLI_REFERENCE.md).

## 2. Activate Pantheon

Invoke the `$pantheon` skill, then give Codex a concrete task:

```text
$pantheon

Trace the authentication flow, fix the stale-session bug, and verify the change.
```

A clear request such as `Use Pantheon for this task` also activates it. Pantheon remains active for ordinary follow-ups in that thread:

```text
Now add the regression test.
Review the final diff.
```

You do not need to invoke `$pantheon` again. Activation never carries into a different thread.

To return the current thread to ordinary Codex behavior, say:

```text
Stop using Pantheon.
```

Mentioning Pantheon is not the same as activating it. Requests such as `Update the Pantheon README` or `Run Pantheon doctor` operate on the project without activating orchestration unless you separately ask to use Pantheon.

## 3. Choose an effort level

Pantheon starts at normal effort unless you say otherwise. Effort changes orchestration depth, not the available agents.

| Effort | Best for | Typical delegation |
| --- | --- | --- |
| Fast | Small, well-understood tasks | Zero or one specialist |
| Normal | Most implementation and diagnosis work | One specialist, with independent review or verification when useful |
| Deep | High-risk decisions or broad, uncertain work | More research and independent checking within Pantheon's fan-out limits |

Select an effort in ordinary language:

```text
$pantheon

Use deep orchestration for this migration.
```

Change it later while Pantheon remains active:

```text
Switch Pantheon to fast.
Use normal Pantheon effort.
```

The selected effort persists within the active thread. Disabling Pantheon clears it.

## 4. Dispatch progressively and keep context small

The parent decides whether delegation adds material value, then selects one best specialist first and stops when its result is sufficient. Add a second only for a specific unresolved need, a genuinely independent workstream, or materially useful independent verification. Do not create a complexity swarm.

Use the smallest matching role: known scoped change → Fixer; unknown repository path or ownership → Explorer; unknown external documentation or reference → Librarian; unresolved architecture → Oracle; UI/UX → Designer; static correctness/diff/security/regression → Reviewer; executable tests/builds/reproduction/acceptance → Verifier. Explorer is not a Fixer preflight, Fixer can inspect a known target, Oracle is only for unresolved architecture, and team mode is the independent-workstream exception.

Native child spawns default to `fork_turns: "none"` with a self-contained assignment and minimal context. Inherit only the minimum supported context when a genuine parent dependency requires it, with an inherited-fork exception only when no inheritance would make a required dynamic tool unavailable. Never use full-history inheritance by default. For ordinary implementation, choose Reviewer or Verifier based on risk; use both only when material risk requires static and runtime evidence.

## 5. Use the specialized workflows

The focused workflow skills apply only to the request that invokes them. They do not create sticky planning, review, or team submodes.

### Plan without implementing

```text
$pantheon-plan Plan the storage migration, including rollback and validation, but do not implement it.
```

The result should be an actionable plan grounded in repository evidence.

### Request an independent review

```text
$pantheon-review Review this branch against main and give me a merge verdict.
```

The Reviewer inspects the actual target. A Verifier may reproduce tests or acceptance criteria when that materially improves confidence.

### Run genuinely independent workstreams

```text
$pantheon-team Split the API migration and client migration into separate workstreams, then integrate and verify them.
```

Team mode is for work that truly separates. The parent thread still owns integration and conflict resolution; child agents do not create further agents.

## 6. Ask for a named specialist

You can request a particular role when you know which perspective you need:

| Specialist | Use it for |
| --- | --- |
| Explorer | Read-only repository mapping and execution-path tracing |
| Librarian | Authoritative external docs, APIs, and version-specific research |
| Oracle | Architecture, tradeoffs, difficult debugging, and second opinions |
| Fixer | Focused implementation after the scope is understood |
| Designer | UI/UX critique or explicitly permitted interface implementation |
| Reviewer | Independent correctness, regression, security, and maintainability review |
| Verifier | Independent tests, builds, reproduction, and acceptance evidence |

For example:

```text
Use Pantheon Explorer to map where authorization decisions are made. Do not change files.
```

Named-agent requests are bounded to that request; they do not create a permanent named-agent mode.

## 7. Write effective requests

Pantheon works best when the task states the outcome and the important boundaries. Include the target, constraints, authorized mutations, expected evidence, and stopping point when they matter.

```text
$pantheon

Fix the retry regression in the API client. Preserve the public API, modify only the client and its tests, run the focused and full test suites, and stop before commit or push.
```

You do not need to design the agent team yourself. The parent Codex thread chooses the minimum useful specialists and remains accountable for the final result.

## 8. Understand the evidence

Pantheon distinguishes different kinds of proof:

- an Explorer report establishes repository evidence, not runtime behavior;
- a Reviewer finding is an independent code assessment, not a passing test;
- a Verifier result proves only the commands and environment it actually exercised;
- `./pantheon doctor` verifies installation files and policy drift, not live subagent availability.

Ask for the specific lane you need: unit tests, a build, a rendered UI, hosted CI, live-provider behavior, or packaged-artifact verification are separate claims.

## 9. Update, repair, or remove Pantheon

Run the bootstrap flow after updating the source package:

```bash
./pantheon bootstrap
```

It refreshes Pantheon-owned files and runs `doctor`. To verify without modifying the installation:

```bash
./pantheon doctor
```

To remove Pantheon-owned files and the managed policy block while preserving unrelated Codex configuration:

```bash
./pantheon uninstall
```

For support and reporting guidance, see [SUPPORT.md](../SUPPORT.md).
