#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"

fail() { printf 'not ok - %s\n' "$1" >&2; exit 1; }
contains() { grep -Fq -- "$2" "$1" || fail "expected '$2' in ${1#"$ROOT/"}"; }

README="$ROOT/README.md"
GUIDE="$ROOT/docs/USER_GUIDE.md"
DOCTRINE="$ROOT/docs/DESIGN_DOCTRINE.md"
INSTALL="$ROOT/docs/CODEX_INSTALL.md"
CLI="$ROOT/docs/CLI_REFERENCE.md"
CHANGELOG="$ROOT/CHANGELOG.md"

for file in "$README" "$GUIDE" "$DOCTRINE" "$INSTALL" "$CLI" "$CHANGELOG"; do
  [ -f "$file" ] || fail "missing documentation file: ${file#"$ROOT/"}"
done

# User-facing architecture must stay aligned with the managed policy.
contains "$README" "hard dependency barrier"
contains "$README" "structured implementation receipt"
contains "$README" "unfinished evidence cannot change an already-issued Fixer specification"
contains "$README" "./pantheon verify"
contains "$README" "normal parent/child session rollouts"

contains "$GUIDE" "Every **required** child result is a hard dependency barrier"
contains "$GUIDE" "structured implementation receipt"
contains "$GUIDE" "unrelated Explorer/Librarian/Fixer tasks may overlap"
contains "$GUIDE" "./pantheon verify"
contains "$GUIDE" "session rollouts remain"

contains "$DOCTRINE" "Fixer returns evidence, not a bare claim"
contains "$DOCTRINE" "Required results are hard barriers"
contains "$DOCTRINE" "Full Pantheon earns parallelism"
contains "$DOCTRINE" "Live verification is explicit and fail-closed"

# Lifecycle docs must distinguish static validation from live runtime proof.
contains "$INSTALL" 'Evidence boundary: `doctor` versus `verify`'
contains "$INSTALL" "one Luna Explorer child turn"
contains "$INSTALL" "session rollouts"

contains "$CLI" '`verify` | Creates normal Codex parent/child session rollouts'
contains "$CLI" '`codex exec --output-last-message`'
contains "$CLI" "one real parent-rollout `spawn_agent` function call"
contains "$CLI" "effective `gpt-5.6-luna` with `high` reasoning"
contains "$CLI" "Prompt text or other raw substring co-occurrence is not accepted as proof"
contains "$CLI" "Normal Codex parent/child session rollouts created by the real turn remain"

# Unreleased notes must describe the same post-v0.7 contract.
contains "$CHANGELOG" 'Structured `luna_fixer` implementation receipts'
contains "$CHANGELOG" "Hard dependency/reconciliation barriers"
contains "$CHANGELOG" "cross-role overlap"
contains "$CHANGELOG" "Live verification now fails closed"

printf '%s\n' 'ok - public documentation matches receipts, dependency barriers, concurrency, and live verification contracts'
