# Codex Pantheon

**Codex Pantheon is a slim, explicit, Codex-native multi-agent layer.**

Pantheon gives Codex a small set of specialist agents plus thin Daily, planning, review, and parallel-team workflows without replacing Codex with a separate orchestration framework.

> Enhance Codex. Don't replace it.

![Codex Pantheon — How It Works](docs/assets/codex-pantheon-how-it-works.png)

## v0.4.0

v0.4 adds **Pantheon Daily**, a quota-conscious operating profile for normal day-to-day Codex work, while keeping full Pantheon as the quality-and-confidence-first profile:

- ordinary Codex stays solo by default;
- `$pantheon-daily` activates a sticky Daily profile that prefers parent-owned work and normally uses 0-2 specialist calls per user request;
- Daily permits a third specialist only for a concrete unresolved blocker, risk, or evidence gap and never uses 4+ specialist calls for one request;
- `$pantheon` activates full Pantheon, which keeps progressive evidence-earned routing but has no Daily numeric specialist ceiling;
- Daily and full Pantheon can be switched explicitly within a thread and never persist across threads;
- `$pantheon-plan`, `$pantheon-review`, and `$pantheon-team` remain request-scoped workflows and do not replace the sticky profile;
- all child spawns retain the v0.3 `fork_turns: "none"`, minimal-context, bounded-assignment contract;
- the seven agent roles, pinned models, and reasoning levels are unchanged;
- no token accounting, quota polling, persistent budget state, daemon, scheduler, HUD, or custom orchestration runtime is introduced.

See `docs/DESIGN_DOCTRINE.md` and `docs/V0.4.0.md`.

## Documentation

- [User guide](docs/USER_GUIDE.md) — operating profiles, activation, effort levels, workflows, specialists, examples, and evidence boundaries.
- [Codex-assisted install guide](docs/CODEX_INSTALL.md) — installation, update, repair, verification, and removal.
- [CLI reference](docs/CLI_REFERENCE.md) — commands, environment variables, owned paths, outcomes, and safeguards.
- [Design doctrine](docs/DESIGN_DOCTRINE.md) — the principles and slim-test that govern the project.
- [Contributing](CONTRIBUTING.md) — development setup, change constraints, validation, and pull-request expectations.
- [Release checklist](docs/RELEASING.md) — version synchronization, validation, and publication boundaries.
- [Support](SUPPORT.md) — diagnostics and useful bug-report details.
- [Security policy](SECURITY.md) — private vulnerability reporting and security-sensitive boundaries.
- [Changelog](CHANGELOG.md) — release history.

## Core agents

| Agent | Purpose | Default model | Reasoning | Default write posture |
| --- | --- | --- | --- | --- |
| `pantheon_explorer` | Repository/system mapping, execution-path tracing, evidence | `gpt-5.6-luna` | `high` | Read-only |
| `pantheon_librarian` | Docs, APIs, standards, upstream/reference research | `gpt-5.6-luna` | `high` | Read-only |
| `pantheon_oracle` | Architecture, tradeoffs, difficult reasoning | `gpt-5.6-sol` | `high` | Read-only |
| `pantheon_fixer` | Focused implementation | `gpt-5.6-luna` | `max` | Workspace write |
| `pantheon_designer` | UI/UX critique or explicitly authorized UI implementation | `gpt-5.6-luna` | `max` | Assignment-dependent |
| `pantheon_reviewer` | Independent correctness/regression/security review | `gpt-5.6-sol` | `high` | Read-only |
| `pantheon_verifier` | Tests, builds, reproduction, acceptance evidence | `gpt-5.6-terra` | `medium` | No production-source edits |

All seven v0.4 agent roles retain the v0.3 model, reasoning, bounded-output, and context defaults. Daily changes routing policy, not the roster.

## Operating profiles

Pantheon v0.4 has three practical levels of orchestration:

| Profile | Activation | Primary objective | Typical fan-out |
| --- | --- | --- | --- |
| Ordinary Codex | default | Lowest orchestration overhead | No Pantheon subagents |
| Pantheon Daily | `$pantheon-daily` | Stretch a fixed allowance while retaining useful specialists | Usually 0-2 calls; third only for a concrete unresolved gap |
| Full Pantheon | `$pantheon` | Maximize useful quality, confidence, and independent evidence | Progressive; no Daily numeric ceiling |

### Pantheon Daily

Invoke Daily explicitly:

```text
$pantheon-daily

Implement this feature.
fix the failing tests
update the docs
```

Daily remains active for ordinary follow-ups in that thread. The parent handles low-risk, well-scoped work directly when that is cheaper than delegation. When a specialist materially reduces uncertainty, rework, or parent effort, Daily selects one best-fit role first.

Daily normally uses no more than two specialist calls for one user request. A third is allowed only for a concrete unresolved blocker, risk, or evidence gap that the parent cannot resolve efficiently. It never uses four or more specialist calls for one request and never silently escalates into full Pantheon or `$pantheon-team`.

### Full Pantheon

Invoke full Pantheon explicitly:

```text
$pantheon

Implement this feature.
fix the failing tests
review the implementation
address the review findings
```

Full Pantheon remains active for ordinary follow-ups in that thread. It still uses progressive dispatch—one best specialist first, then additional specialists only for specific unresolved needs, independent workstreams, or material verification—but it is not constrained by Daily's numeric ceiling when extra specialist work materially improves the result.

Activation can also happen midway through a thread:

```text
Explain how this subsystem works.

$pantheon-daily

Now implement the refactor.
```

The first request uses ordinary Codex behavior. Daily becomes active at `$pantheon-daily`. A clear natural-language request such as `use Pantheon Daily for this` or `use Pantheon for this` activates the corresponding profile.

### Switch profiles or leave Pantheon

Switch from Daily to full Pantheon with:

```text
$pantheon
```

Switch from full Pantheon to Daily with:

```text
$pantheon-daily
```

The profiles are mutually exclusive. Switching away from full Pantheon clears its selected effort. Entering full Pantheon from Daily without an effort instruction starts at `normal`.

To leave either profile, state that intent clearly:

```text
stop using Pantheon
```

Subsequent messages use normal non-Pantheon behavior until a profile is explicitly activated again. Activation never carries into a new thread.

## Full-Pantheon effort

Fast / normal / deep are effort levels for full Pantheon. Daily is a separate profile, not an effort level.

Select full Pantheon with `$pantheon`, then express the effort as ordinary language:

```text
$pantheon

Use deep orchestration for this task.
```

Once full Pantheon is active, change its effort without invoking the skill again:

```text
switch Pantheon to fast
use normal Pantheon effort
switch Pantheon to deep
```

Activation without an effort instruction starts at `normal`. A repeated bare `$pantheon` while full Pantheon is active preserves the current effort. Switching to Daily or disabling Pantheon clears that selection.

## Specialized workflow skills

The focused workflows remain available for an explicit request without becoming sticky submodes or replacing the active Daily/full profile:

```text
$pantheon-plan plan the multi-workspace migration without implementing it
$pantheon-review review this branch against main
$pantheon-team split this migration into independent workstreams
```

You can also name an agent directly in natural language, for example:

```text
Use Pantheon Explorer to map the authentication flow.
Use Pantheon Reviewer to independently inspect the current diff.
```

A named-agent request is request-scoped and does not create a permanent named-agent mode.

Pantheon does not activate merely because a task looks difficult. Thread persistence is a conversational contract interpreted from explicit activation, profile switching, and deactivation in that thread; Pantheon does not add a daemon, database, global preference, quota store, or cross-thread state store.

### Progressive dispatch and context efficiency

The parent decides whether delegation adds material value, then chooses one best specialist first and stops when the result is sufficient. Add another specialist only for a specific unresolved need, genuinely independent workstream, or material verification requirement. Every additional specialist must earn its place; complexity alone never creates a swarm. The concise routing map is: known scoped change → Fixer; unknown repository path/ownership → Explorer; unknown external reference → Librarian; unresolved architecture → Oracle; UI/UX → Designer; static correctness/diff/security/regression → Reviewer; executable tests/builds/reproduction/acceptance → Verifier. Explorer is not a Fixer preflight, Fixer can inspect a known target, Oracle is only for unresolved architecture, and team mode is the independent-workstream exception.

Daily applies additional quota-conscious constraints: it may keep low-risk implementation in the parent, normally stays within 0-2 specialist calls per request, uses a third only for a concrete unresolved gap, and prefers at most one independent implementation check—Reviewer or Verifier—based on the dominant risk.

Native child spawns, including direct named-agent requests, default to `fork_turns: "none"` and self-contained minimal context. Inherit only the minimum supported context for a genuine parent dependency, with an inherited-fork exception only when no inheritance would make a required dynamic tool unavailable. Full-history inheritance is never the default. Every child remains bounded and cannot spawn another child.

## Install with Codex (recommended)

Open the Pantheon source directory as your Codex workspace and simply ask:

```text
Install Codex Pantheon for me.
```

This is an ordinary Codex lifecycle request: it operates on Pantheon and leaves Pantheon mode OFF. By contrast, `$pantheon` or `$pantheon-daily` followed by an implementation request explicitly activates the selected profile, and `Use Pantheon to update the Pantheon installer.` combines explicit full-Pantheon activation with a Pantheon operation.

The repository instructions direct Codex to run the bounded bootstrap flow:

```bash
./pantheon bootstrap
```

`bootstrap` installs or refreshes Pantheon-owned files and immediately runs `doctor`. If a safety check fails, Codex is instructed to report the failure instead of bypassing Pantheon's safeguards with manual overwrites. See `docs/CODEX_INSTALL.md`.

### Manual install

From the Pantheon source directory:

```bash
./pantheon install
./pantheon doctor
```

The v0.1-compatible entry point still works:

```bash
./install.sh
```

Pantheon installs:

- custom agent TOMLs into `${CODEX_HOME:-~/.codex}/agents/`;
- workflow skills into `${PANTHEON_SKILLS_HOME:-~/.agents/skills}`;
- one managed policy block into `${CODEX_HOME:-~/.codex}/AGENTS.md`;
- a small version marker at `${CODEX_HOME:-~/.codex}/.pantheon-version`.

Those exact Pantheon-named agent files and skill directories are Pantheon-owned: install/update replaces them and uninstall removes them without making backups. Move unrelated content using the same names before installing. Other agent names, other skills, and text outside Pantheon's managed `AGENTS.md` markers remain user-owned. See the [CLI reference](docs/CLI_REFERENCE.md#owned-paths).

Agent files are copied as regular files. Pantheon does not install custom agent roles as symlinks.

The installer is idempotent: running it repeatedly should produce the same installed state without duplicating the managed `AGENTS.md` block.

## Bootstrap / Update

For Codex-assisted setup and the simplest manual install-or-update flow:

```bash
./pantheon bootstrap
```

For an explicit update after replacing/pulling the Pantheon source with a newer version:

```bash
./pantheon update
```

`update` replaces only Pantheon-owned agent/skill files and Pantheon's managed `AGENTS.md` block. Text outside the markers remains user-owned.

## Doctor

```bash
./pantheon doctor
```

Doctor is read-only. It checks:

- source package completeness;
- installed version marker;
- all seven custom-agent files;
- regular-file/no-symlink status;
- agent and skill drift against this package;
- all five workflow skills;
- managed `AGENTS.md` marker integrity and content;
- possible legacy/unmanaged Pantheon text;
- whether a Codex executable can be found and its reported version.

Doctor validates the installation, not the live Codex service/backend. A healthy doctor result therefore does not claim that a real subagent spawn has been exercised successfully in the current Codex build/provider or that Daily consumed any particular amount of quota.

## Uninstall

```bash
./pantheon uninstall
```

Uninstall removes only Pantheon-owned agent files, Pantheon skill directories, the Pantheon managed block, and the Pantheon version marker. Other Codex configuration and other skills are preserved.

## Managed `AGENTS.md` policy

Pantheon owns only the region bounded by:

```text
<!-- PANTHEON:START -->
...
<!-- PANTHEON:END -->
```

If the markers are malformed or duplicated, install/update/uninstall refuses to rewrite `AGENTS.md` rather than guessing.

### Upgrading from v0.1

If v0.1 left unmarked Pantheon instructions in `~/.codex/AGENTS.md`, v0.4.0 intentionally does not delete them because they are indistinguishable from user-owned text. Install v0.4.0, run `./pantheon doctor`, then review any legacy-warning text manually once the managed block is present.

## Configuration locations

Pantheon honors `CODEX_HOME` for Codex-owned files:

```bash
CODEX_HOME=/tmp/codex-home ./pantheon install
```

For tests or unusual environments, the skill root can be overridden with:

```bash
PANTHEON_SKILLS_HOME=/tmp/skills ./pantheon install
```

## Development validation

Run:

```bash
./tests/test.sh
```

The test suite uses isolated temporary homes and does not touch your real Codex configuration.

## What Pantheon intentionally does not do

Core Pantheon has no:

- automatic prompt interception or mode detection;
- proactive activation on ordinary Codex prompts;
- recursive child-agent orchestration;
- background daemon or service;
- persistent mission/task database;
- tmux/worktree scheduler;
- orchestration dashboard/HUD;
- token or rate-limit manager;
- large agent marketplace;
- custom MCP orchestration server.

If a future feature requires Pantheon to become its own agent platform rather than improving native Codex delegation, it fails the project's slim test by default.

## License

Codex Pantheon is available under the [MIT License](LICENSE).