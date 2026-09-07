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
| `uninstall` | Yes | Remove current and legacy Pantheon-owned files, skills, policy block, and version marker |
| `version` | No | Print the Pantheon version |
| `help` | No | Print usage and environment-variable help |

Convenience installer entrypoints are `./install.sh` on macOS/Linux and `.\install.ps1` on Windows.

## Environment variables

| Variable | macOS/Linux default | Windows default | Controls |
| --- | --- | --- | --- |
| `CODEX_HOME` | `~/.codex` | `%USERPROFILE%\.codex` | Agent definitions, managed `AGENTS.md` block, version marker |
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

## Legacy paths owned for migration/removal

v0.6 treats the following former Pantheon names as owned cleanup targets:

- `pantheon-worker.toml` (v0.5)
- `pantheon-explorer.toml`
- `pantheon-librarian.toml`
- `pantheon-oracle.toml`
- `pantheon-fixer.toml`
- `pantheon-designer.toml`
- `pantheon-reviewer.toml`
- `pantheon-verifier.toml`
- the `pantheon-team` skill directory

`install`, `update`, and `bootstrap` remove those paths before installing the current v0.6 payload. `doctor` reports them as unhealthy if they reappear. `uninstall` removes them too.

## Doctor outcomes

- `HEALTHY` — static checks passed.
- `HEALTHY WITH WARNINGS` — checks passed but Codex discovery or possible unmanaged Pantheon text needs attention.
- `UNHEALTHY` — source, install, migration-cleanup, drift, symlink/reparse-point, or marker checks failed.

Doctor may invoke `codex --version` but does not rewrite installed configuration. It validates static installation integrity, not model/provider availability, quota behavior, billing, or a successful live child spawn.

### Codex discovery

The Bash frontend checks PATH and the standard macOS ChatGPT/Codex bundle location already supported by the project.

The PowerShell frontend checks PATH plus native Windows locations under `%LOCALAPPDATA%`, including:

- the standalone CLI shim under `Programs\OpenAI\Codex\bin`
- the Codex desktop runtime under `OpenAI\Codex\bin`
- the Microsoft Store package LocalCache runtime path
- versioned runtime directories beneath those roots

Failure to locate Codex is a warning because the remaining Doctor checks can still validate the installed Pantheon payload.

## Fail-closed safeguards

Lifecycle operations refuse to guess when managed `AGENTS.md` markers are malformed/duplicated or when that file is not a regular managed file. Bash protects against symlinks; PowerShell protects against Windows reparse points. Resolve the ownership/marker problem manually rather than overwriting unrelated configuration.
