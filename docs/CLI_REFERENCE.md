# Pantheon CLI Reference

Run the lifecycle CLI from a Codex Pantheon source checkout.

macOS/Linux:

```text
./pantheon <command>
```

Windows PowerShell:

```text
.\pantheon.ps1 <command>
```

The two frontends implement the same lifecycle contract and consume the same `agents/`, `skills/`, `policy/`, and `VERSION` payload.

## Commands

| Command | Changes local state | Purpose |
| --- | --- | --- |
| `bootstrap` | Yes | Install/refresh Pantheon-owned files, remove owned legacy payloads, then run `doctor` |
| `install` | Yes | Install the current source package and perform migration cleanup |
| `update` | Yes | Replace Pantheon-owned files with the current source package and perform migration cleanup |
| `doctor` | No persistent changes | Check source completeness, current payload, legacy absence, policy, drift, and Codex discovery |
| `verify` | Creates normal Codex parent/child session rollouts; no repository/config changes | Run the real parent→Luna Explorer V2 routing/context-isolation/round-trip smoke test; consumes live model usage |
| `uninstall` | Yes | Remove current and legacy Pantheon-owned files, skills, policy block, and version marker |
| `version` | No | Print the Pantheon version |
| `help` | No | Print usage and environment-variable help |

Convenience installer entrypoints are `./install.sh` on macOS/Linux and `.\install.ps1` on Windows.

## Environment variables

| Variable | macOS/Linux default | Windows default | Controls |
| --- | --- | --- | --- |
| `CODEX_HOME` | `~/.codex` | `%USERPROFILE%\.codex` | Agent definitions, managed `AGENTS.md` block, version marker, and Codex session rollouts used by `verify` |
| `PANTHEON_SKILLS_HOME` | `~/.agents/skills` | `%USERPROFILE%\.agents\skills` | Pantheon workflow skills |

## Current owned paths

- `<Codex home>/agents/luna-explorer.toml`
- `<Codex home>/agents/luna-librarian.toml`
- `<Codex home>/agents/luna-fixer.toml`
- `<skills home>/pantheon/`
- `<skills home>/pantheon-daily/`
- `<skills home>/pantheon-plan/`
- `<skills home>/pantheon-review/`
- the single `<!-- PANTHEON:START -->` through `<!-- PANTHEON:END -->` block in `<Codex home>/AGENTS.md`
- `<Codex home>/.pantheon-version`

Codex's own session rollouts are **not Pantheon-owned lifecycle files**. `verify` creates ordinary parent/child Codex session records under the configured Codex home because it executes a real turn; uninstall does not remove those records.

## Legacy paths owned for migration/removal

The current payload treats these former Pantheon names as owned cleanup targets:

- `pantheon-worker.toml` (v0.5)
- `pantheon-explorer.toml`
- `pantheon-librarian.toml`
- `pantheon-oracle.toml`
- `pantheon-fixer.toml`
- `pantheon-designer.toml`
- `pantheon-reviewer.toml`
- `pantheon-verifier.toml`
- the `pantheon-team` skill directory

`install`, `update`, and `bootstrap` remove those paths before installing the current payload. `doctor` reports them as unhealthy if they reappear. `uninstall` removes them too.

## Doctor outcomes

- `HEALTHY` — static checks passed.
- `HEALTHY WITH WARNINGS` — checks passed but Codex discovery or possible unmanaged Pantheon text needs attention.
- `UNHEALTHY` — source, install, migration-cleanup, drift, symlink/reparse-point, or marker checks failed.

Doctor may invoke `codex --version` but does not rewrite installed configuration. It validates static installation integrity, not model/provider availability or a successful live child spawn.

## Live verification

Run live verification only when you explicitly want to exercise the installed Codex runtime:

macOS/Linux:

```text
./pantheon verify
```

Windows PowerShell:

```text
.\pantheon.ps1 verify
```

`verify` first runs the static Doctor preflight, then executes one real read-only Codex parent turn. The parent must use native MultiAgent V2 to spawn exactly one `luna_explorer` with `fork_turns: "none"` and task name `explorer_pantheon_verify`, then wait for that child through native `wait_agent` before finalizing.

The verifier fails closed. It requires all of the following evidence from the same run:

- the parent's **exact** final reply from `codex exec --output-last-message`;
- the exact parent thread ID from Codex's JSON event stream;
- exactly one total parent-rollout `spawn_agent` function call, with the expected agent type, task name, `fork_turns` value, and verification nonce;
- one correlated function-call result for that spawn;
- at least one real parent-rollout `wait_agent` call whose correlated result reports `timed_out: false`;
- exactly one correlated child rollout whose `session_meta` records the matching parent, Luna Explorer role, and task path;
- child `turn_context` showing effective `gpt-5.6-luna` with `high` reasoning;
- one exact child assistant `output_text` verification reply;
- one terminal child `task_complete` event carrying that same expected final message;
- absence of the concrete parent-only sentinel from the child rollout.

Prompt text or other raw substring co-occurrence is not accepted as proof. The verifier identifies the exact parent rollout by thread ID, correlates spawn/wait calls to their actual outputs, and identifies the child by the current parent thread ID plus Luna Explorer role/task-path provenance rather than filesystem timestamps or content-scanning the user's entire session store.

A successful run ends with `Status: VERIFIED`. Failure is visible and non-fallback: missing authentication/provider/model availability, unavailable V2 control, wrong role/task metadata, an extra or missing spawn, a missing correlated spawn result, no non-timeout `wait_agent` mailbox update, missing terminal child completion, wrong effective model/effort, failed round trip, or context-isolation failure all make `verify` fail.

The command does not run automatically from `install`, `update`, `bootstrap`, or `doctor` because it consumes live model usage. Temporary verifier artifacts are deleted on success or failure. Normal Codex parent/child session rollouts created by the real turn remain in the Codex session store under normal Codex retention behavior.

### Codex discovery

The Bash frontend checks PATH and the standard macOS ChatGPT/Codex bundle location already supported by the project.

The PowerShell frontend checks PATH plus native Windows locations under `%LOCALAPPDATA%`, including:

- the standalone CLI shim under `Programs\OpenAI\Codex\bin`
- the Codex desktop runtime under `OpenAI\Codex\bin`
- the Microsoft Store package LocalCache runtime path
- versioned runtime directories beneath those roots

Failure to locate Codex is a warning for `doctor`, because the remaining static checks can still validate the installed Pantheon payload. It is an error for `verify`, which requires a real Codex executable.

## Fail-closed safeguards

Lifecycle operations refuse to guess when managed `AGENTS.md` markers are malformed/duplicated or when that file is not a regular managed file. Bash protects against symlinks; PowerShell protects against Windows reparse points. Resolve the ownership/marker problem manually rather than overwriting unrelated configuration.
