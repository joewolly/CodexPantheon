# Security Policy

Codex Pantheon installs local agent definitions, skills, a version marker, and one managed policy block in the user's Codex configuration. Changes that can overwrite unrelated configuration, escape the documented install roots, follow unsafe symlinks, or weaken fail-closed validation are security-sensitive.

## Supported versions

Security fixes are applied to the current release line and the default branch. Older releases may not receive backports; upgrade to the latest release before reporting behavior that may already be fixed.

## Reporting a vulnerability

Do not disclose a suspected vulnerability in a public issue.

Use GitHub's [private vulnerability-reporting flow](https://docs.github.com/en/code-security/how-tos/report-and-fix-vulnerabilities/report-privately) when it is available for this repository. Otherwise, contact [the repository owner](https://github.com/joewolly) privately through a trusted channel. If you do not already have one, [open a minimal issue](https://github.com/joewolly/CodexPantheon/issues/new) requesting secure contact without including exploit details, secrets, personal data, or affected-user information; the maintainer can then establish a private channel.

Please include:

- the affected Pantheon version or commit;
- the operating system and Codex version;
- the command or workflow involved;
- the expected and observed security boundary;
- minimal reproduction steps;
- the potential impact;
- any suggested mitigation.

Remove API keys, tokens, credentials, private prompts, home-directory contents, and unrelated Codex configuration from logs and examples.

## Security boundaries of interest

Reports are especially useful when they involve:

- writes outside `${CODEX_HOME:-~/.codex}` or the configured skill root;
- modification or deletion of user-owned configuration;
- unsafe handling of files or symlinks during install, update, doctor, or uninstall;
- malformed managed markers being accepted or rewritten ambiguously;
- unexpected automatic activation, recursive delegation, or persistent hidden state;
- a mismatch between documented read-only/write permissions and installed agent behavior.

Vulnerabilities in the upstream Codex app, service, models, or providers that are not caused by Pantheon's installed files are outside this repository's scope and should be reported through the applicable upstream security channel.

## Response expectations

This project is maintained on a best-effort basis and does not promise a fixed response or remediation time. Reports will be acknowledged and assessed as promptly as practical. Please allow time for a fix and coordinated disclosure before publishing details.
