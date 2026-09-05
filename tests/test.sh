#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
PANTHEON="${ROOT}/pantheon"
PASS=0

pass() {
  PASS=$((PASS + 1))
  printf 'ok %d - %s\n' "$PASS" "$1"
}

fail() {
  printf 'not ok - %s\n' "$1" >&2
  exit 1
}

assert_file() { [ -f "$1" ] || fail "expected file: $1"; }
assert_not_file() { [ ! -e "$1" ] && [ ! -L "$1" ] || fail "expected missing path: $1"; }
assert_contains() { grep -Fq -- "$2" "$1" || fail "expected '$2' in $1"; }
assert_not_contains() { ! grep -Fq -- "$2" "$1" || fail "did not expect '$2' in $1"; }
assert_regular_not_symlink() { [ -f "$1" ] && [ ! -L "$1" ] || fail "expected regular non-symlink file: $1"; }
assert_equal_files() { cmp -s "$1" "$2" || fail "files differ: $1 $2"; }

bash -n "$PANTHEON" "$ROOT/install.sh" "$0"
pass "shell syntax"

assert_contains "$ROOT/VERSION" "0.5.0"
assert_contains "$PANTHEON" 'VERSION="0.5.0"'
pass "release version is v0.5.0"

WORKER="$ROOT/agents/pantheon-worker.toml"
assert_file "$WORKER"
assert_contains "$WORKER" 'name = "pantheon_worker"'
assert_contains "$WORKER" 'model = "gpt-5.6-luna"'
assert_contains "$WORKER" 'model_reasoning_effort = "high"'
assert_contains "$WORKER" 'sandbox_mode = "workspace-write"'
assert_contains "$WORKER" "the only child subagent role"
assert_contains "$WORKER" "Explore repository or local-system evidence"
assert_contains "$WORKER" "implement or fix scoped changes"
assert_contains "$WORKER" "run focused validation"
assert_contains "$WORKER" "remain read-only"
assert_contains "$WORKER" "parent owns planning, architecture"
assert_contains "$WORKER" "Do not become the orchestrator"
assert_contains "$WORKER" "do not spawn, delegate to, or manage subagents"
assert_contains "$WORKER" "Once the assigned objective is answered with sufficient evidence, stop."
pass "single Luna worker contract is bounded and parent-owned"

LEGACY_AGENTS=(
  pantheon-explorer.toml
  pantheon-librarian.toml
  pantheon-oracle.toml
  pantheon-fixer.toml
  pantheon-designer.toml
  pantheon-reviewer.toml
  pantheon-verifier.toml
)
for legacy in "${LEGACY_AGENTS[@]}"; do
  assert_not_file "$ROOT/agents/$legacy"
done
assert_not_file "$ROOT/skills/pantheon-team"
pass "legacy seven-agent and team source payload is removed"

POLICY="$ROOT/policy/managed-block.md"
POLICY_WORDS="$(wc -w < "$POLICY" | tr -d '[:space:]')"
[ "$POLICY_WORDS" -lt 450 ] || fail "managed policy is too large (${POLICY_WORDS} words)"
for marker in \
  "Every new thread starts inactive" \
  '$pantheon' \
  '$pantheon-daily' \
  "Astra thinks. Luna does." \
  '`pantheon_worker` is the single GPT-5.6 Luna child role' \
  "normally use 0-1 worker calls per user request" \
  "never parallelize workers" \
  "Full Pantheon may use multiple Luna workers" \
  "genuinely independent workstreams" \
  "Daily and full Pantheon are the only delegation-intensity profiles" \
  'defaults to `fork_turns: "none"`' \
  "does not activate orchestration" \
  "Repository tests prove packaged policy"; do
  assert_contains "$POLICY" "$marker"
done
for obsolete in \
  'pantheon_fixer' \
  'pantheon_explorer' \
  'pantheon_reviewer' \
  '$pantheon-team' \
  'fast/normal/deep'; do
  assert_not_contains "$POLICY" "$obsolete"
done
pass "managed policy encodes the Astra/Luna architecture and two-profile state"

for skill in pantheon pantheon-daily pantheon-plan pantheon-review; do
  skill_file="$ROOT/skills/$skill/SKILL.md"
  assert_file "$skill_file"
  assert_contains "$skill_file" 'fork_turns: "none"'
  assert_contains "$skill_file" "self-contained"
  assert_contains "$skill_file" "bounded"
  assert_contains "$skill_file" "Do not inherit context merely because it is available"
  assert_contains "$skill_file" "minimum supported inheritance"
  assert_contains "$skill_file" "required dynamic tool unavailable"
  assert_contains "$skill_file" "Never use full-history inheritance by default"
  assert_contains "$skill_file" "not to spawn subagents"
  assert_contains "$skill_file" "Repository tests prove packaged policy/configuration"
done
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Every new thread begins inactive"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Astra thinks. Luna does."
assert_contains "$ROOT/skills/pantheon/SKILL.md" "one child role: `pantheon_worker`"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Parallel workers are allowed only for genuinely independent workstreams"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "no fast/normal/deep effort layer"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "normally use **0-1 worker calls per user request**"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "do not parallelize workers in Daily"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "one cohesive assignment"
assert_contains "$ROOT/skills/pantheon-plan/SKILL.md" "planning-only, request-scoped workflow"
assert_contains "$ROOT/skills/pantheon-plan/SKILL.md" "Any worker assignment in this workflow is **read-only**"
assert_contains "$ROOT/skills/pantheon-review/SKILL.md" "parent Codex thread performs the review and owns the verdict"
assert_contains "$ROOT/skills/pantheon-review/SKILL.md" "`pantheon_worker` is optional"
pass "four skills preserve bounded native delegation with slim routing"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/home"
export CODEX_HOME="$TMP/codex-home"
export PANTHEON_SKILLS_HOME="$TMP/skills"
mkdir -p "$HOME" "$CODEX_HOME/agents" "$PANTHEON_SKILLS_HOME"

cat > "$CODEX_HOME/AGENTS.md" <<'PRE'
# User instructions

Keep this exact user-owned line.
PRE
printf 'do-not-touch\n' > "$CODEX_HOME/agents/user-custom.toml"
mkdir -p "$PANTHEON_SKILLS_HOME/user-skill"
printf '%s\n' 'user skill' > "$PANTHEON_SKILLS_HOME/user-skill/SKILL.md"

for legacy in "${LEGACY_AGENTS[@]}"; do
  printf 'legacy-v0.4\n' > "$CODEX_HOME/agents/$legacy"
done
mkdir -p "$PANTHEON_SKILLS_HOME/pantheon-team"
printf 'legacy team\n' > "$PANTHEON_SKILLS_HOME/pantheon-team/SKILL.md"

"$PANTHEON" install >/dev/null
assert_contains "$CODEX_HOME/AGENTS.md" "Keep this exact user-owned line."
[ "$(grep -Fxc '<!-- PANTHEON:START -->' "$CODEX_HOME/AGENTS.md")" -eq 1 ] || fail "expected one Pantheon start marker"
[ "$(grep -Fxc '<!-- PANTHEON:END -->' "$CODEX_HOME/AGENTS.md")" -eq 1 ] || fail "expected one Pantheon end marker"
assert_contains "$CODEX_HOME/.pantheon-version" "0.5.0"
assert_file "$CODEX_HOME/agents/user-custom.toml"
assert_file "$PANTHEON_SKILLS_HOME/user-skill/SKILL.md"
assert_regular_not_symlink "$CODEX_HOME/agents/pantheon-worker.toml"
assert_equal_files "$WORKER" "$CODEX_HOME/agents/pantheon-worker.toml"
for legacy in "${LEGACY_AGENTS[@]}"; do
  assert_not_file "$CODEX_HOME/agents/$legacy"
done
assert_not_file "$PANTHEON_SKILLS_HOME/pantheon-team"
for skill in pantheon pantheon-daily pantheon-plan pantheon-review; do
  assert_equal_files "$ROOT/skills/$skill/SKILL.md" "$PANTHEON_SKILLS_HOME/$skill/SKILL.md"
done
assert_contains "$CODEX_HOME/AGENTS.md" "Astra thinks. Luna does."
assert_contains "$CODEX_HOME/AGENTS.md" "normally use 0-1 worker calls per user request"
pass "install migrates v0.4 payload and preserves unrelated configuration"

BEFORE="$(cksum "$CODEX_HOME/AGENTS.md")"
"$PANTHEON" install >/dev/null
AFTER="$(cksum "$CODEX_HOME/AGENTS.md")"
[ "$BEFORE" = "$AFTER" ] || fail "repeated install changed managed AGENTS.md unexpectedly"
[ "$(grep -Fxc '<!-- PANTHEON:START -->' "$CODEX_HOME/AGENTS.md")" -eq 1 ] || fail "repeated install duplicated block"
pass "install is idempotent"

printf 'drift\n' >> "$CODEX_HOME/agents/pantheon-worker.toml"
if "$PANTHEON" doctor >/dev/null 2>&1; then
  fail "doctor should fail on drifted worker"
fi
"$PANTHEON" update >/dev/null
assert_equal_files "$WORKER" "$CODEX_HOME/agents/pantheon-worker.toml"
"$PANTHEON" doctor >/dev/null
pass "doctor detects worker drift and update repairs it"

printf 'drift\n' >> "$PANTHEON_SKILLS_HOME/pantheon-daily/SKILL.md"
if "$PANTHEON" doctor >/dev/null 2>&1; then
  fail "doctor should fail on drifted Daily skill"
fi
"$PANTHEON" update >/dev/null
assert_equal_files "$ROOT/skills/pantheon-daily/SKILL.md" "$PANTHEON_SKILLS_HOME/pantheon-daily/SKILL.md"
"$PANTHEON" doctor >/dev/null
pass "doctor detects Daily skill drift and update repairs it"

SENTINEL="$TMP/symlink-target"
printf 'SENTINEL-UNCHANGED\n' > "$SENTINEL"
rm -f "$CODEX_HOME/agents/pantheon-worker.toml"
ln -s "$SENTINEL" "$CODEX_HOME/agents/pantheon-worker.toml"
"$PANTHEON" update >/dev/null
assert_regular_not_symlink "$CODEX_HOME/agents/pantheon-worker.toml"
assert_contains "$SENTINEL" "SENTINEL-UNCHANGED"
assert_equal_files "$WORKER" "$CODEX_HOME/agents/pantheon-worker.toml"
pass "update replaces worker symlink without following target"

printf 'legacy-v0.4\n' > "$CODEX_HOME/agents/pantheon-explorer.toml"
mkdir -p "$PANTHEON_SKILLS_HOME/pantheon-team"
printf 'legacy team\n' > "$PANTHEON_SKILLS_HOME/pantheon-team/SKILL.md"
if "$PANTHEON" doctor >/dev/null 2>&1; then
  fail "doctor should fail when legacy payload reappears"
fi
"$PANTHEON" update >/dev/null
assert_not_file "$CODEX_HOME/agents/pantheon-explorer.toml"
assert_not_file "$PANTHEON_SKILLS_HOME/pantheon-team"
"$PANTHEON" doctor >/dev/null
pass "doctor detects legacy payload and update removes it"

GOOD_AGENTS="$TMP/good-agents.md"
cp "$CODEX_HOME/AGENTS.md" "$GOOD_AGENTS"
printf '\n<!-- PANTHEON:START -->\ncorrupt duplicate\n' >> "$CODEX_HOME/AGENTS.md"
BROKEN_BEFORE="$(cksum "$CODEX_HOME/AGENTS.md")"
if "$PANTHEON" update >/dev/null 2>&1; then
  fail "update should refuse duplicate markers"
fi
BROKEN_AFTER="$(cksum "$CODEX_HOME/AGENTS.md")"
[ "$BROKEN_BEFORE" = "$BROKEN_AFTER" ] || fail "failed update modified malformed AGENTS.md"
cp "$GOOD_AGENTS" "$CODEX_HOME/AGENTS.md"
pass "malformed markers fail closed without modifying AGENTS.md"

printf '\nLegacy Codex Pantheon note outside managed block.\n' >> "$CODEX_HOME/AGENTS.md"
DOCTOR_OUT="$TMP/doctor.out"
"$PANTHEON" doctor >"$DOCTOR_OUT" 2>&1
assert_contains "$DOCTOR_OUT" "legacy/unmanaged Pantheon instructions"
pass "doctor warns about possible unmanaged Pantheon text"

"$PANTHEON" uninstall >/dev/null
assert_not_contains "$CODEX_HOME/AGENTS.md" "<!-- PANTHEON:START -->"
assert_contains "$CODEX_HOME/AGENTS.md" "Keep this exact user-owned line."
assert_contains "$CODEX_HOME/AGENTS.md" "Legacy Codex Pantheon note outside managed block."
assert_file "$CODEX_HOME/agents/user-custom.toml"
assert_file "$PANTHEON_SKILLS_HOME/user-skill/SKILL.md"
assert_not_file "$CODEX_HOME/.pantheon-version"
assert_not_file "$CODEX_HOME/agents/pantheon-worker.toml"
for legacy in "${LEGACY_AGENTS[@]}"; do
  assert_not_file "$CODEX_HOME/agents/$legacy"
done
for skill in pantheon pantheon-daily pantheon-plan pantheon-review pantheon-team; do
  assert_not_file "$PANTHEON_SKILLS_HOME/$skill"
done
pass "uninstall removes current and legacy Pantheon-owned state only"

EMPTY="$TMP/empty"
export HOME="$EMPTY/home"
export CODEX_HOME="$EMPTY/codex"
export PANTHEON_SKILLS_HOME="$EMPTY/skills"
mkdir -p "$HOME"
"$PANTHEON" install >/dev/null
assert_file "$CODEX_HOME/AGENTS.md"
"$PANTHEON" uninstall >/dev/null
assert_not_file "$CODEX_HOME/AGENTS.md"
pass "uninstall removes AGENTS.md when Pantheon was its only content"

BOOT="$TMP/bootstrap"
export HOME="$BOOT/home"
export CODEX_HOME="$BOOT/codex"
export PANTHEON_SKILLS_HOME="$BOOT/skills"
mkdir -p "$HOME" "$BOOT"
BOOT_OUT="$BOOT/bootstrap.out"
"$PANTHEON" bootstrap >"$BOOT_OUT" 2>&1
assert_contains "$BOOT_OUT" "Pantheon-owned files synchronized to v0.5.0."
assert_contains "$BOOT_OUT" "Status: HEALTHY"
assert_file "$CODEX_HOME/.pantheon-version"
assert_file "$CODEX_HOME/agents/pantheon-worker.toml"
printf 'drift\n' >> "$CODEX_HOME/agents/pantheon-worker.toml"
"$PANTHEON" bootstrap >"$BOOT_OUT" 2>&1
assert_equal_files "$WORKER" "$CODEX_HOME/agents/pantheon-worker.toml"
[ "$(grep -Fxc '<!-- PANTHEON:START -->' "$CODEX_HOME/AGENTS.md")" -eq 1 ] || fail "bootstrap duplicated managed block"
assert_contains "$BOOT_OUT" "Status: HEALTHY"
pass "bootstrap performs migration-aware install/update plus doctor idempotently"

assert_contains "$ROOT/AGENTS.md" "Astra remains the main-thread orchestrator"
assert_contains "$ROOT/README.md" "Astra thinks. Luna does. Pantheon controls how much Luna Astra is allowed to use."
assert_contains "$ROOT/README.md" "installs exactly one custom child-agent definition"
assert_contains "$ROOT/README.md" "removes fast/normal/deep effort levels"
assert_contains "$ROOT/docs/USER_GUIDE.md" "There is no longer a seven-agent specialist roster"
assert_contains "$ROOT/docs/DESIGN_DOCTRINE.md" "One child role"
assert_contains "$ROOT/docs/CODEX_INSTALL.md" "v0.4 migration cleanup"
assert_contains "$ROOT/docs/CLI_REFERENCE.md" "Legacy paths owned for migration/removal"
assert_contains "$ROOT/docs/V0.5.0.md" "Astra + Luna Slim"
assert_contains "$ROOT/CHANGELOG.md" "## 0.5.0 — 2026-09-05"
pass "v0.5 documentation matches the Astra/Luna slim architecture"

printf '1..%d\n' "$PASS"
