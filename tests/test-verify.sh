#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
PANTHEON="$ROOT/pantheon"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

export HOME="$TMP/home"
export CODEX_HOME="$TMP/codex"
export PANTHEON_SKILLS_HOME="$TMP/skills"
FAKE_BIN="$TMP/bin"
mkdir -p "$HOME" "$CODEX_HOME" "$PANTHEON_SKILLS_HOME" "$FAKE_BIN"

cat > "$FAKE_BIN/codex" <<'FAKE_CODEX'
#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "--version" ]; then
  printf '%s\n' 'codex-cli pantheon-verify-test'
  exit 0
fi

all_args="$(printf '%s\n' "$@")"
nonce="$(printf '%s\n' "$all_args" | sed -n 's/.*Pantheon verify nonce: \([^ .]*\).*/\1/p' | head -n 1)"
[ -n "$nonce" ] || { printf '%s\n' 'fake codex could not find verify nonce' >&2; exit 2; }

session_dir="$CODEX_HOME/sessions/fake"
mkdir -p "$session_dir"
printf '{"nonce":"%s","tool":"spawn_agent","agent_type":"luna_explorer","task_name":"explorer_pantheon_verify","fork_turns":"none"}\n' "$nonce" > "$session_dir/parent.jsonl"
printf '{"nonce":"%s","type":"subagent.thread_spawn","agent_path":"%s/agents/luna-explorer.toml","model":"gpt-5.6-luna","message":"PANTHEON_CHILD_OK_%s_NO_PARENT_SECRET"}\n' "$nonce" "$CODEX_HOME" "$nonce" > "$session_dir/child.jsonl"
printf '{"type":"item.completed","text":"PANTHEON_VERIFY_OK_%s"}\n' "$nonce"
FAKE_CODEX
chmod +x "$FAKE_BIN/codex"
export PATH="$FAKE_BIN:$PATH"

"$PANTHEON" install >/dev/null
OUT="$TMP/verify.out"
"$PANTHEON" verify >"$OUT" 2>&1

grep -Fq 'Parent received and reconciled the child result' "$OUT"
grep -Fq 'V2 spawn used luna_explorer, fork_turns none, and explorer_pantheon_verify' "$OUT"
grep -Fq 'Configured Explorer resolved to GPT-5.6 Luna' "$OUT"
grep -Fq 'fork_turns none kept the parent-only secret out of the child context' "$OUT"
grep -Fq 'Status: VERIFIED' "$OUT"

printf '%s\n' 'ok - pantheon verify proves the live V2 routing/isolation round-trip contract'
