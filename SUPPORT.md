# Codex Pantheon Support

## Start here

- For installation and upgrades, see the [Codex-assisted install guide](docs/CODEX_INSTALL.md).
- For day-to-day use, see the [user guide](docs/USER_GUIDE.md).
- For commands and installation ownership, see the [CLI reference](docs/CLI_REFERENCE.md).
- For the project's architectural boundaries, see the [design doctrine](docs/DESIGN_DOCTRINE.md).
- For release changes, see the [changelog](CHANGELOG.md).

## Diagnose an installation

From the Pantheon source directory, run:

```bash
./pantheon version
./pantheon doctor
```

`doctor` is read-only. Include its output when asking for help, but remove usernames, home-directory paths, private repository names, tokens, credentials, and unrelated configuration first.

## Ask for help or report a bug

Use the repository's GitHub issues for reproducible installation problems, lifecycle failures, policy drift, documentation errors, and feature requests. Before filing an issue, check that you are using the current release and search for an existing report.

A useful report includes:

- Pantheon version or commit;
- Codex version reported by `./pantheon doctor`;
- operating system and shell;
- the exact command or explicit Pantheon request;
- expected and observed behavior;
- sanitized output and the smallest reproduction you can provide.

Pantheon depends on native Codex agent and skill capabilities. A healthy `doctor` result confirms local installation integrity, not live backend/provider availability. If installation is healthy but delegation fails, say whether ordinary Codex subagents work in the same environment.

For suspected security vulnerabilities, follow [SECURITY.md](SECURITY.md) instead of opening a detailed public issue.
