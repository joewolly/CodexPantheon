#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
PANTHEON="$ROOT/pantheon"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

export HOME="$TMP/home"
export CODEX_HOME="$TMP/codex"
export PANTHEON_SKILLS_HOME="$TMP/skills"
export TMPDIR="$TMP/runtime-tmp"
FAKE_BIN="$TMP/bin"
mkdir -p "$HOME" "$CODEX_HOME" "$PANTHEON_SKILLS_HOME" "$TMPDIR" "$FAKE_BIN"

cat > "$FAKE_BIN/codex" <<'FAKE_CODEX'
#!/usr/bin/env bash
set -euo pipefail

if [ "${1:-}" = "--version" ]; then
  printf '%s\n' 'codex-cli pantheon-verify-test'
  exit 0
fi

mode="${PANTHEON_VERIFY_FAKE_MODE:-success}"
last_message=""
prompt=""
prev=""
for arg in "$@"; do
  if [ "$prev" = "--output-last-message" ]; then
    last_message="$arg"
  fi
  prev="$arg"
  prompt="$arg"
done
[ -n "$last_message" ] || { printf '%s\n' 'fake codex missing --output-last-message' >&2; exit 2; }

nonce="$(printf '%s\n' "$prompt" | sed -n 's/.*Pantheon verify nonce: \([^ .]*\).*/\1/p' | head -n 1)"
secret="$(printf '%s\n' "$prompt" | sed -n 's/^Parent-only secret: \(.*\)$/\1/p' | head -n 1)"
[ -n "$nonce" ] || { printf '%s\n' 'fake codex could not find verify nonce' >&2; exit 2; }

parent_id="parent-${nonce}"
child_id="child-${nonce}"
session_dir="$CODEX_HOME/sessions/fake"
mkdir -p "$session_dir"
parent_file="$session_dir/rollout-${parent_id}.jsonl"
child_file="$session_dir/rollout-${child_id}.jsonl"
call_id="call-${nonce}"

printf '%s\n' 'fake codex diagnostic on stderr' >&2
printf '{"type":"thread.started","thread_id":"%s"}\n' "$parent_id"
printf '%s\n' '{"type":"turn.started"}'

printf '{"type":"session_meta","payload":{"id":"%s","source":"cli"}}\n' "$parent_id" > "$parent_file"
printf '{"type":"event_msg","payload":{"type":"user_message","message":"spawn_agent luna_explorer explorer_pantheon_verify fork_turns none PANTHEON_VERIFY_OK_%s"}}\n' "$nonce" >> "$parent_file"

if [ "$mode" != "prompt-only" ]; then
  printf '{"type":"response_item","payload":{"type":"function_call","name":"spawn_agent","arguments":"{\\"message\\":\\"Pantheon verify nonce: %s. Return evidence.\\",\\"agent_type\\":\\"luna_explorer\\",\\"fork_turns\\":\\"none\\",\\"task_name\\":\\"explorer_pantheon_verify\\"}","call_id":"%s"}}\n' "$nonce" "$call_id" >> "$parent_file"
  if [ "$mode" != "missing-output" ]; then
    printf '{"type":"response_item","payload":{"type":"function_call_output","call_id":"%s","output":"{\\"task_name\\":\\"/root/explorer_pantheon_verify\\"}"}}\n' "$call_id" >> "$parent_file"
  fi
fi

if [ "$mode" = "multiple-spawn" ]; then
  printf '{"type":"response_item","payload":{"type":"function_call","name":"spawn_agent","arguments":"{\\"message\\":\\"Pantheon verify nonce: %s. Duplicate.\\",\\"agent_type\\":\\"luna_explorer\\",\\"fork_turns\\":\\"none\\",\\"task_name\\":\\"explorer_pantheon_verify\\"}","call_id":"duplicate-%s"}}\n' "$nonce" "$nonce" >> "$parent_file"
fi

if [ "$mode" != "no-child" ]; then
  printf '{"type":"session_meta","payload":{"id":"%s","source":{"subagent":{"thread_spawn":{"parent_thread_id":"%s","depth":1,"agent_path":"/root/explorer_pantheon_verify","agent_role":"luna_explorer"}}}}}\n' "$child_id" "$parent_id" > "$child_file"
  effort="high"
  [ "$mode" = "wrong-effort" ] && effort="medium"
  printf '{"type":"turn_context","payload":{"model":"gpt-5.6-luna","effort":"%s"}}\n' "$effort" >> "$child_file"
  printf '{"type":"response_item","payload":{"type":"message","role":"assistant","content":[{"type":"input_text","text":"Reply exactly PANTHEON_CHILD_OK_%s_NO_PARENT_SECRET"}]}}\n' "$nonce" >> "$child_file"
  if [ "$mode" = "secret-leak" ]; then
    printf '{"type":"event_msg","payload":{"type":"debug","message":"%s"}}\n' "$secret" >> "$child_file"
  fi
  if [ "$mode" = "child-prompt-only" ]; then
    printf '{"type":"response_item","payload":{"type":"message","role":"assistant","content":[{"type":"output_text","text":"PANTHEON_CHILD_FAIL_%s_PARENT_SECRET_SEEN"}]}}\n' "$nonce" >> "$child_file"
  else
    printf '{"type":"response_item","payload":{"type":"message","role":"assistant","content":[{"type":"output_text","text":"PANTHEON_CHILD_OK_%s_NO_PARENT_SECRET"}]}}\n' "$nonce" >> "$child_file"
  fi
fi

parent_reply="PANTHEON_VERIFY_OK_${nonce}"
[ "$mode" = "misleading-parent" ] && parent_reply="Expected PANTHEON_VERIFY_OK_${nonce}, but child failed"
printf '%s\n' "$parent_reply" > "$last_message"
printf '{"type":"item.completed","item":{"id":"item_1","type":"agent_message","text":"%s"}}\n' "$parent_reply"
printf '%s\n' '{"type":"turn.completed","usage":{"input_tokens":1,"cached_input_tokens":0,"output_tokens":1}}'
FAKE_CODEX
chmod +x "$FAKE_BIN/codex"
export PATH="$FAKE_BIN:$PATH"

"$PANTHEON" install >/dev/null

run_success() {
  local out="$TMP/verify-success.out"
  PANTHEON_VERIFY_FAKE_MODE=success "$PANTHEON" verify >"$out" 2>&1
  grep -Fq 'Parent received and reconciled the child result' "$out"
  grep -Fq 'V2 spawn used luna_explorer, fork_turns none, and explorer_pantheon_verify' "$out"
  grep -Fq 'Configured Explorer resolved to GPT-5.6 Luna High' "$out"
  grep -Fq 'fork_turns none kept the parent-only secret out of the child context' "$out"
  grep -Fq 'Status: VERIFIED' "$out"
}

expect_failure() {
  local mode="$1"
  local out="$TMP/verify-${mode}.out"
  if PANTHEON_VERIFY_FAKE_MODE="$mode" "$PANTHEON" verify >"$out" 2>&1; then
    printf 'verify unexpectedly passed in mode %s\n' "$mode" >&2
    cat "$out" >&2
    exit 1
  fi
}

run_success
for mode in misleading-parent prompt-only missing-output multiple-spawn child-prompt-only wrong-effort secret-leak no-child; do
  expect_failure "$mode"
done

if find "$TMPDIR" -mindepth 1 -maxdepth 1 -name 'pantheon-verify.*' -print -quit | grep -q .; then
  printf '%s\n' 'verify leaked temporary files after a failure' >&2
  find "$TMPDIR" -mindepth 1 -maxdepth 1 -print >&2
  exit 1
fi

printf '%s\n' 'ok - pantheon verify fails closed on misleading evidence and cleans temporary state'
