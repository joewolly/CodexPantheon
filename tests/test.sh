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

assert_contains "$ROOT/VERSION" "0.6.0"
assert_contains "$PANTHEON" 'VERSION="0.6.0"'
pass "release version is v0.6.0"

EXPLORER="$ROOT/agents/luna-explorer.toml"
LIBRARIAN="$ROOT/agents/luna-librarian.toml"
FIXER="$ROOT/agents/luna-fixer.toml"
for agent in "$EXPLORER" "$LIBRARIAN" "$FIXER"; do
  assert_file "$agent"
  assert_contains "$agent" 'model = "gpt-5.6-luna"'
  assert_contains "$agent" 'model_reasoning_effort = "high"'
  assert_contains "$agent" "Do not spawn, delegate to, or manage subagents"
done
assert_contains "$EXPLORER" 'name = "luna_explorer"'
assert_contains "$EXPLORER" 'sandbox_mode = "read-only"'
assert_contains "$EXPLORER" "You explore; Astra plans; Luna Fixer implements."
assert_contains "$EXPLORER" "Do not design the solution"
assert_contains "$LIBRARIAN" 'name = "luna_librarian"'
assert_contains "$LIBRARIAN" 'sandbox_mode = "read-only"'
assert_contains "$LIBRARIAN" "You research; Astra plans; Luna Fixer implements."
assert_contains "$LIBRARIAN" "Do not choose product behavior"
assert_contains "$FIXER" 'name = "luna_fixer"'
assert_contains "$FIXER" 'sandbox_mode = "workspace-write"'
assert_contains "$FIXER" "Your job is to implement, not to independently plan the mission or conduct broad research."
assert_contains "$FIXER" "Astra owns the implementation plan"
assert_contains "$FIXER" "stop and return the blocker to Astra"
pass "named Luna Explorer/Librarian/Fixer contracts have hard ownership boundaries"

LEGACY_AGENTS=(
  pantheon-worker.toml
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
pass "v0.4/v0.5 legacy source payload is removed"

POLICY="$ROOT/policy/managed-block.md"
POLICY_WORDS="$(wc -w < "$POLICY" | tr -d '[:space:]')"
[ "$POLICY_WORDS" -lt 700 ] || fail "managed policy is too large (${POLICY_WORDS} words)"
for marker in \
  "Every new thread starts inactive" \
  '$pantheon' \
  '$pantheon-daily' \
  "Astra is not the default implementation worker" \
  '`luna_explorer`' \
  '`luna_librarian`' \
  '`luna_fixer`' \
  'luna_explorer_<specific_assignment>' \
  'luna_librarian_<specific_assignment>' \
  'luna_fixer_<specific_assignment>' \
  "Explorer/Librarian evidence when needed" \
  'Astra then synthesizes the returned evidence and creates the implementation plan before calling `luna_fixer`' \
  "Do not use Explorer/Librarian for reconnaissance and then have Astra take over substantive implementation" \
  "There is no numeric worker-call ceiling" \
  "no parallel child calls" \
  "genuinely independent workstreams" \
  'defaults to `fork_turns: "none"`' \
  "does not activate orchestration" \
  "Repository tests prove packaged policy/configuration"; do
  assert_contains "$POLICY" "$marker"
done
for obsolete in \
  'pantheon_worker` is the single' \
  'normally use 0-1 worker calls' \
  '$pantheon-team' \
  'pantheon_oracle' \
  'pantheon_designer' \
  'pantheon_reviewer' \
  'pantheon_verifier'; do
  assert_not_contains "$POLICY" "$obsolete"
done
pass "managed policy encodes OMO-style Astra orchestration, named Luna lanes, and visible task identity"

for skill in pantheon pantheon-daily pantheon-plan pantheon-review; do
  skill_file="$ROOT/skills/$skill/SKILL.md"
  assert_file "$skill_file"
  assert_contains "$skill_file" 'fork_turns: "none"'
  assert_contains "$skill_file" "self-contained"
  assert_contains "$skill_file" "bounded"
  assert_contains "$skill_file" 'role-prefixed `task_name`'
  assert_contains "$skill_file" 'luna_explorer_<specific_assignment>'
  assert_contains "$skill_file" 'luna_librarian_<specific_assignment>'
  assert_contains "$skill_file" "Do not inherit context merely because it is available"
  assert_contains "$skill_file" "minimum supported inheritance"
  assert_contains "$skill_file" "required dynamic tool unavailable"
  assert_contains "$skill_file" "Never use full-history inheritance by default"
  assert_contains "$skill_file" "not to spawn subagents"
  assert_contains "$skill_file" "Repository tests prove packaged policy/configuration"
done
assert_contains "$ROOT/skills/pantheon/SKILL.md" 'luna_fixer_<specific_assignment>'
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" 'luna_fixer_<specific_assignment>'
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Astra is **not the default implementation worker**"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Explorer/Librarian evidence → Astra plan/specification → Fixer implementation → Astra review/verification"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "multiple Fixers may run in parallel only with clear non-overlapping write ownership"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "It changes delegation intensity, never role ownership."
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "no numeric worker-call ceiling"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "do not parallelize child agents in Daily"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "Astra plan → Fixer → Astra review"
assert_contains "$ROOT/skills/pantheon-plan/SKILL.md" "Astra owns the plan"
assert_contains "$ROOT/skills/pantheon-plan/SKILL.md" 'Do **not** use `luna_fixer`'
assert_contains "$ROOT/skills/pantheon-review/SKILL.md" "Astra performs the actual review and owns the verdict"
assert_contains "$ROOT/skills/pantheon-review/SKILL.md" 'Do not use `luna_fixer` during a review-only request'
pass "four skills preserve strict ownership and role-prefixed task identity"

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
  printf 'legacy\n' > "$CODEX_HOME/agents/$legacy"
done
mkdir -p "$PANTHEON_SKILLS_HOME/pantheon-team"
printf 'legacy team\n' > "$PANTHEON_SKILLS_HOME/pantheon-team/SKILL.md"

"$PANTHEON" install >/dev/null
assert_contains "$CODEX_HOME/AGENTS.md" "Keep this exact user-owned line."
[ "$(grep -Fxc '<!-- PANTHEON:START -->' "$CODEX_HOME/AGENTS.md")" -eq 1 ] || fail "expected one Pantheon start marker"
[ "$(grep -Fxc '<!-- PANTHEON:END -->' "$CODEX_HOME/AGENTS.md")" -eq 1 ] || fail "expected one Pantheon end marker"
assert_contains "$CODEX_HOME/.pantheon-version" "0.6.0"
assert_file "$CODEX_HOME/agents/user-custom.toml"
assert_file "$PANTHEON_SKILLS_HOME/user-skill/SKILL.md"
for agent in luna-explorer.toml luna-librarian.toml luna-fixer.toml; do
  assert_regular_not_symlink "$CODEX_HOME/agents/$agent"
  assert_equal_files "$ROOT/agents/$agent" "$CODEX_HOME/agents/$agent"
done
for legacy in "${LEGACY_AGENTS[@]}"; do
  assert_not_file "$CODEX_HOME/agents/$legacy"
done
assert_not_file "$PANTHEON_SKILLS_HOME/pantheon-team"
for skill in pantheon pantheon-daily pantheon-plan pantheon-review; do
  assert_equal_files "$ROOT/skills/$skill/SKILL.md" "$PANTHEON_SKILLS_HOME/$skill/SKILL.md"
done
assert_contains "$CODEX_HOME/AGENTS.md" "Astra is not the default implementation worker"
assert_contains "$CODEX_HOME/AGENTS.md" "There is no numeric worker-call ceiling"
assert_contains "$CODEX_HOME/AGENTS.md" 'luna_explorer_<specific_assignment>'
assert_contains "$CODEX_HOME/AGENTS.md" 'luna_librarian_<specific_assignment>'
assert_contains "$CODEX_HOME/AGENTS.md" 'luna_fixer_<specific_assignment>'
pass "install migrates v0.4/v0.5 payload and preserves unrelated configuration"

BEFORE="$(cksum "$CODEX_HOME/AGENTS.md")"
"$PANTHEON" install >/dev/null
AFTER="$(cksum "$CODEX_HOME/AGENTS.md")"
[ "$BEFORE" = "$AFTER" ] || fail "repeated install changed managed AGENTS.md unexpectedly"
[ "$(grep -Fxc '<!-- PANTHEON:START -->' "$CODEX_HOME/AGENTS.md")" -eq 1 ] || fail "repeated install duplicated block"
pass "install is idempotent"

printf 'drift\n' >> "$CODEX_HOME/agents/luna-fixer.toml"
if "$PANTHEON" doctor >/dev/null 2>&1; then
  fail "doctor should fail on drifted Fixer"
fi
"$PANTHEON" update >/dev/null
assert_equal_files "$FIXER" "$CODEX_HOME/agents/luna-fixer.toml"
"$PANTHEON" doctor >/dev/null
pass "doctor detects agent drift and update repairs it"

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
rm -f "$CODEX_HOME/agents/luna-fixer.toml"
ln -s "$SENTINEL" "$CODEX_HOME/agents/luna-fixer.toml"
"$PANTHEON" update >/dev/null
assert_regular_not_symlink "$CODEX_HOME/agents/luna-fixer.toml"
assert_contains "$SENTINEL" "SENTINEL-UNCHANGED"
assert_equal_files "$FIXER" "$CODEX_HOME/agents/luna-fixer.toml"
pass "update replaces agent symlink without following target"

printf 'legacy-v0.5\n' > "$CODEX_HOME/agents/pantheon-worker.toml"
mkdir -p "$PANTHEON_SKILLS_HOME/pantheon-team"
printf 'legacy team\n' > "$PANTHEON_SKILLS_HOME/pantheon-team/SKILL.md"
if "$PANTHEON" doctor >/dev/null 2>&1; then
  fail "doctor should fail when legacy payload reappears"
fi
"$PANTHEON" update >/dev/null
assert_not_file "$CODEX_HOME/agents/pantheon-worker.toml"
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
for agent in luna-explorer.toml luna-librarian.toml luna-fixer.toml; do
  assert_not_file "$CODEX_HOME/agents/$agent"
done
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
assert_contains "$BOOT_OUT" "Pantheon-owned files synchronized to v0.6.0."
assert_contains "$BOOT_OUT" "Status: HEALTHY"
assert_file "$CODEX_HOME/.pantheon-version"
assert_file "$CODEX_HOME/agents/luna-fixer.toml"
printf 'drift\n' >> "$CODEX_HOME/agents/luna-fixer.toml"
"$PANTHEON" bootstrap >"$BOOT_OUT" 2>&1
assert_equal_files "$FIXER" "$CODEX_HOME/agents/luna-fixer.toml"
[ "$(grep -Fxc '<!-- PANTHEON:START -->' "$CODEX_HOME/AGENTS.md")" -eq 1 ] || fail "bootstrap duplicated managed block"
assert_contains "$BOOT_OUT" "Status: HEALTHY"
pass "bootstrap performs migration-aware install/update plus doctor idempotently"

assert_contains "$ROOT/AGENTS.md" "Preserve the v0.6 orchestration architecture"
assert_contains "$ROOT/AGENTS.md" 'role-prefixed `task_name`'
assert_contains "$ROOT/README.md" "Astra = Orchestrator"
assert_contains "$ROOT/README.md" "Glanceable subagent titles"
assert_contains "$ROOT/docs/USER_GUIDE.md" "luna_explorer"
assert_contains "$ROOT/docs/USER_GUIDE.md" "Context and visible task identity"
assert_contains "$ROOT/docs/DESIGN_DOCTRINE.md" "Astra plans. Luna specialists execute their lane."
assert_contains "$ROOT/docs/CODEX_INSTALL.md" "v0.5 migration cleanup"
assert_contains "$ROOT/docs/CLI_REFERENCE.md" "luna-fixer.toml"
assert_contains "$ROOT/docs/V0.6.0.md" "Orchestrator + three Luna specialists"
assert_contains "$ROOT/CHANGELOG.md" "## 0.6.0 — 2026-09-05"
assert_contains "$ROOT/THIRD_PARTY_NOTICES.md" "oh-my-opencode-slim"
pass "v0.6 documentation matches the OMO-style Codex orchestration architecture and visible task contract"

printf '1..%d\n' "$PASS"
