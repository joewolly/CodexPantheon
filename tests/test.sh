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
assert_not_file() { [ ! -e "$1" ] || fail "expected missing path: $1"; }
assert_contains() { grep -Fq -- "$2" "$1" || fail "expected '$2' in $1"; }
assert_not_contains() { ! grep -Fq -- "$2" "$1" || fail "did not expect '$2' in $1"; }
assert_regular_not_symlink() { [ -f "$1" ] && [ ! -L "$1" ] || fail "expected regular non-symlink file: $1"; }
assert_equal_files() { cmp -s "$1" "$2" || fail "files differ: $1 $2"; }

bash -n "$PANTHEON" "$ROOT/install.sh" "$0"
pass "shell syntax"

assert_contains "$ROOT/VERSION" "0.4.0"
assert_contains "$PANTHEON" 'VERSION="0.4.0"'
pass "release version is v0.4.0"

POLICY="$ROOT/policy/managed-block.md"
POLICY_WORDS="$(wc -w < "$POLICY" | tr -d '[:space:]')"
POLICY_BYTES="$(wc -c < "$POLICY" | tr -d '[:space:]')"
POLICY_LINES="$(wc -l < "$POLICY" | tr -d '[:space:]')"
# v0.2 baseline: 750 words, 5,488 bytes, 62 lines. Leave margin for concise policy maintenance.
[ "$POLICY_WORDS" -lt 375 ] || fail "managed policy was not materially slimmed (${POLICY_WORDS} words)"
[ "$POLICY_BYTES" -lt 3000 ] || fail "managed policy was not materially slimmed (${POLICY_BYTES} bytes)"
[ "$POLICY_LINES" -lt 35 ] || fail "managed policy was not materially slimmed (${POLICY_LINES} lines)"
for obsolete in "### Parent ownership" "### Pantheon agents" "### Bounded delegation" "### Integration and verification" "### Effort" "Default fan-out"; do
  assert_not_contains "$POLICY" "$obsolete"
done
for marker in \
  "Every new thread starts inactive" \
  '$pantheon' \
  '$pantheon-daily' \
  "clear request to use, enable, or enter Pantheon orchestration" \
  "Pantheon Daily" \
  "Ordinary follow-ups remain in Pantheon" \
  "Explicitly invoking the other profile switches profiles" \
  "clears effort" \
  "starts at normal" \
  "never carries into another thread" \
  "request-scoped workflows, not sticky submodes" \
  "do not replace the selected profile" \
  "A named-agent request is valid" \
  "does not activate orchestration" \
  "Difficulty, quoted text, and vague discussion" \
  "Do not create persistent activation state" \
  "follow the relevant Pantheon workflow skill" \
  "First decide whether delegation materially helps" \
  "select one best-fit specialist" \
  "Stop specialist escalation when that result is sufficient" \
  "Add another specialist only" \
  "specific unresolved need" \
  "genuinely independent workstream" \
  "material verification requirement" \
  "Every additional specialist must earn its place" \
  "Do not fan out merely because a task looks complex" \
  "Daily follows its stricter quota-conscious routing ceiling" \
  "never silently escalates into full Pantheon or team mode" \
  "Full Pantheon has no Daily numeric ceiling" \
  "Any Pantheon child spawn, including a direct named-agent request" \
  'defaults to `fork_turns: "none"`' \
  "the relevant workflow skill defines bounded inheritance exceptions" \
  "Repository tests prove packaged policy/configuration" \
  "not the live Codex backend"; do
  assert_contains "$POLICY" "$marker"
done
for detailed in \
  'pantheon_fixer' \
  'pantheon_explorer' \
  'pantheon_librarian' \
  'pantheon_oracle' \
  'pantheon_designer' \
  'pantheon_reviewer' \
  'pantheon_verifier' \
  'Explorer is not a Fixer preflight' \
  'choose Reviewer or Verifier based on risk'; do
  assert_not_contains "$POLICY" "$detailed"
done
pass "managed policy is compact profile/state/dispatch guidance without detailed skill duplication"

for skill in pantheon pantheon-daily pantheon-plan pantheon-review pantheon-team; do
  skill_file="$ROOT/skills/$skill/SKILL.md"
  assert_file "$skill_file"
  assert_contains "$skill_file" 'fork_turns: "none"'
  assert_contains "$skill_file" "self-contained"
  assert_contains "$skill_file" "bounded"
  assert_contains "$skill_file" "Do not inherit context merely because it is available"
  assert_contains "$skill_file" "minimum supported inheritance"
  assert_contains "$skill_file" "required dynamic tool unavailable"
  assert_contains "$skill_file" "Never use full-history inheritance by default"
  assert_contains "$skill_file" "objective"
  assert_contains "$skill_file" "stopping condition"
  assert_contains "$skill_file" "not to spawn subagents"
  assert_contains "$skill_file" "request"
  assert_contains "$skill_file" "Repository tests prove packaged policy/configuration"
done
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Every new thread begins inactive"
assert_contains "$ROOT/skills/pantheon/SKILL.md" 'Once active, ordinary follow-ups stay in Pantheon'
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Deactivation clears the selected effort"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Activation and effort never carry into a new or unrelated thread"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "does not by itself activate orchestration"
assert_contains "$ROOT/skills/pantheon/SKILL.md" 'specialized `$pantheon-plan`, `$pantheon-review`, and `$pantheon-team` workflows apply only to the request'
assert_contains "$ROOT/skills/pantheon/SKILL.md" "A named-agent request is valid for that request only"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "The parent first decides whether delegation adds material value"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "select one best specialist first"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Add another specialist only for a specific unresolved need"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Every additional specialist must earn its place"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Do not create a complexity swarm"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Full Pantheon has no Daily-style numeric specialist ceiling"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Explorer is not a Fixer preflight"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Fixer can inspect it directly"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Use Oracle only when architecture"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Team mode is the independent-workstream exception"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "independent check defaults to Reviewer or Verifier based on risk"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "Use both only when material risk requires both static and runtime evidence"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "never make Fixer → Reviewer → Verifier the default sequence"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "minimum supported inheritance only when a genuine parent dependency requires it"
assert_contains "$ROOT/skills/pantheon/SKILL.md" "sole special exception"
assert_contains "$ROOT/skills/pantheon/SKILL.md" 'Pantheon Daily is a separate routing profile rather than an effort level'
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "quota-conscious Pantheon operating profile"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "Zero specialists is a valid and often preferred Daily result"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "Normally use no more than two specialist calls for one user request"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "A third specialist call is allowed only"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "Never use four or more specialist calls for one Daily request"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "Never silently switch Daily into full Pantheon or team mode"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "parent handles it directly when practical"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "Prefer Explorer or Librarian rather than both"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "prefer at most one independent check—Reviewer or Verifier"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "Do not default to Fixer → Reviewer → Verifier"
assert_contains "$ROOT/skills/pantheon-daily/SKILL.md" "Daily changes routing behavior, not the seven agent model/reasoning definitions"
assert_contains "$ROOT/skills/pantheon-plan/SKILL.md" "planning-only workflow"
assert_contains "$ROOT/skills/pantheon-plan/SKILL.md" "Add another specialist only for a specific unresolved need"
assert_contains "$ROOT/skills/pantheon-plan/SKILL.md" "Every additional specialist must earn its place"
assert_contains "$ROOT/skills/pantheon-plan/SKILL.md" "Never invoke Fixer merely to make a plan concrete"
assert_contains "$ROOT/skills/pantheon-plan/SKILL.md" "one actionable plan with sequencing, ownership boundaries, validation criteria"
assert_contains "$ROOT/skills/pantheon-review/SKILL.md" '`pantheon_reviewer` is required'
assert_contains "$ROOT/skills/pantheon-review/SKILL.md" '`pantheon_verifier` is optional'
assert_contains "$ROOT/skills/pantheon-review/SKILL.md" "Add another specialist only for a specific unresolved need"
assert_contains "$ROOT/skills/pantheon-review/SKILL.md" "Every additional specialist must earn its place"
assert_contains "$ROOT/skills/pantheon-review/SKILL.md" "runtime tests, builds, reproduction, or acceptance evidence materially improve confidence"
assert_contains "$ROOT/skills/pantheon-team/SKILL.md" "independent-workstream exception"
assert_contains "$ROOT/skills/pantheon-team/SKILL.md" "at least two genuinely independent workstreams"
assert_contains "$ROOT/skills/pantheon-team/SKILL.md" "Use 2-3 concurrent agents by default"
assert_contains "$ROOT/skills/pantheon-team/SKILL.md" "use 4+ only when the user explicitly requests broader fan-out"
assert_contains "$ROOT/skills/pantheon-team/SKILL.md" "Add another specialist only for a specific unresolved need"
assert_contains "$ROOT/skills/pantheon-team/SKILL.md" "Every additional team member must earn its place"
assert_contains "$ROOT/skills/pantheon-team/SKILL.md" "distinct substantial workstream or materially useful verification lane"
for surface in \
  "$POLICY" \
  "$ROOT/skills/pantheon/SKILL.md" \
  "$ROOT/skills/pantheon-daily/SKILL.md" \
  "$ROOT/skills/pantheon-plan/SKILL.md" \
  "$ROOT/skills/pantheon-review/SKILL.md" \
  "$ROOT/skills/pantheon-team/SKILL.md" \
  "$ROOT/README.md" \
  "$ROOT/docs/USER_GUIDE.md" \
  "$ROOT/docs/DESIGN_DOCTRINE.md" \
  "$ROOT/docs/V0.3.0.md" \
  "$ROOT/docs/V0.4.0.md"; do
  assert_not_contains "$surface" "Add a second"
  assert_not_contains "$surface" "add a second"
  assert_not_contains "$surface" "A second specialist"
  assert_not_contains "$surface" "a second specialist"
done
pass "all five skills define native child defaults, bounded assignments, escalation, and static/runtime evidence boundaries"

AGENT_FILES=(
  pantheon-explorer.toml
  pantheon-librarian.toml
  pantheon-oracle.toml
  pantheon-fixer.toml
  pantheon-designer.toml
  pantheon-reviewer.toml
  pantheon-verifier.toml
)
for agent in "${AGENT_FILES[@]}"; do
  agent_file="$ROOT/agents/$agent"
  assert_file "$agent_file"
  assert_contains "$agent_file" "Do not restate the assignment."
  assert_contains "$agent_file" "Do not summarize unchanged code or context the parent already supplied."
  assert_contains "$agent_file" "Return only new findings, changes, evidence, blockers, unknowns, and verdicts that the parent needs."
  assert_contains "$agent_file" "Once the assigned objective is answered with sufficient evidence, stop."
  assert_contains "$agent_file" "Do not continue exploring adjacent code or generating extra recommendations merely for completeness."
  assert_contains "$agent_file" "Preserve concrete evidence where it matters."
  assert_not_contains "$agent_file" "Recommended next action"
done
assert_contains "$ROOT/agents/pantheon-explorer.toml" "- Findings"
assert_contains "$ROOT/agents/pantheon-explorer.toml" "- Evidence"
assert_contains "$ROOT/agents/pantheon-explorer.toml" "- Unknowns/blockers only if material"
assert_contains "$ROOT/agents/pantheon-librarian.toml" "- Answer/findings"
assert_contains "$ROOT/agents/pantheon-librarian.toml" "- Source/reference evidence"
assert_contains "$ROOT/agents/pantheon-librarian.toml" "- Unknowns only if material"
assert_contains "$ROOT/agents/pantheon-oracle.toml" "- Recommendation/decision"
assert_contains "$ROOT/agents/pantheon-oracle.toml" "- Material tradeoffs/constraints"
assert_contains "$ROOT/agents/pantheon-oracle.toml" "- Risks/unknowns only if material"
assert_contains "$ROOT/agents/pantheon-fixer.toml" "- Changes made"
assert_contains "$ROOT/agents/pantheon-fixer.toml" "- Validation"
assert_contains "$ROOT/agents/pantheon-fixer.toml" "- Remaining issue only if it exists"
assert_contains "$ROOT/agents/pantheon-designer.toml" "- Findings or changes"
assert_contains "$ROOT/agents/pantheon-designer.toml" "- Relevant evidence/validation"
assert_contains "$ROOT/agents/pantheon-designer.toml" "- Remaining issue only if it exists"
assert_contains "$ROOT/agents/pantheon-reviewer.toml" "- Material findings ordered by severity, with inline evidence"
assert_contains "$ROOT/agents/pantheon-reviewer.toml" "- Verdict"
assert_contains "$ROOT/agents/pantheon-verifier.toml" "- Checks/results"
assert_contains "$ROOT/agents/pantheon-verifier.toml" "- Unproven claims only if any"
assert_contains "$ROOT/agents/pantheon-verifier.toml" "- Verdict"
assert_contains "$ROOT/agents/pantheon-explorer.toml" 'model = "gpt-5.6-luna"'
assert_contains "$ROOT/agents/pantheon-explorer.toml" 'model_reasoning_effort = "high"'
assert_contains "$ROOT/agents/pantheon-librarian.toml" 'model = "gpt-5.6-luna"'
assert_contains "$ROOT/agents/pantheon-librarian.toml" 'model_reasoning_effort = "high"'
assert_contains "$ROOT/agents/pantheon-oracle.toml" 'model = "gpt-5.6-sol"'
assert_contains "$ROOT/agents/pantheon-oracle.toml" 'model_reasoning_effort = "high"'
assert_contains "$ROOT/agents/pantheon-fixer.toml" 'model = "gpt-5.6-luna"'
assert_contains "$ROOT/agents/pantheon-fixer.toml" 'model_reasoning_effort = "max"'
assert_contains "$ROOT/agents/pantheon-designer.toml" 'model = "gpt-5.6-luna"'
assert_contains "$ROOT/agents/pantheon-designer.toml" 'model_reasoning_effort = "max"'
assert_contains "$ROOT/agents/pantheon-reviewer.toml" 'model = "gpt-5.6-sol"'
assert_contains "$ROOT/agents/pantheon-reviewer.toml" 'model_reasoning_effort = "high"'
assert_contains "$ROOT/agents/pantheon-verifier.toml" 'model = "gpt-5.6-terra"'
assert_contains "$ROOT/agents/pantheon-verifier.toml" 'model_reasoning_effort = "medium"'
pass "all seven role payloads are delta-only, stop-bounded, concise, and retain model assignments"

TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT
export HOME="$TMP/home"
export CODEX_HOME="$TMP/codex-home"
export PANTHEON_SKILLS_HOME="$TMP/skills"
mkdir -p "$HOME" "$CODEX_HOME" "$PANTHEON_SKILLS_HOME"

cat > "$CODEX_HOME/AGENTS.md" <<'PRE'
# User instructions

Keep this exact user-owned line.
PRE
printf 'user-agent\n' > "$CODEX_HOME/agents-user-sentinel" 2>/dev/null || true
mkdir -p "$CODEX_HOME/agents"
printf 'do-not-touch\n' > "$CODEX_HOME/agents/user-custom.toml"
mkdir -p "$PANTHEON_SKILLS_HOME/user-skill"
printf '%s\n' 'user skill' > "$PANTHEON_SKILLS_HOME/user-skill/SKILL.md"

"$PANTHEON" install >/dev/null
assert_contains "$CODEX_HOME/AGENTS.md" "Keep this exact user-owned line."
[ "$(grep -Fxc '<!-- PANTHEON:START -->' "$CODEX_HOME/AGENTS.md")" -eq 1 ] || fail "expected one Pantheon start marker"
[ "$(grep -Fxc '<!-- PANTHEON:END -->' "$CODEX_HOME/AGENTS.md")" -eq 1 ] || fail "expected one Pantheon end marker"
assert_file "$CODEX_HOME/.pantheon-version"
assert_contains "$CODEX_HOME/.pantheon-version" "0.4.0"
assert_file "$CODEX_HOME/agents/user-custom.toml"
assert_file "$PANTHEON_SKILLS_HOME/user-skill/SKILL.md"
for f in "$ROOT"/agents/*.toml; do
  base="$(basename "$f")"
  assert_regular_not_symlink "$CODEX_HOME/agents/$base"
  assert_equal_files "$f" "$CODEX_HOME/agents/$base"
done
for d in pantheon pantheon-daily pantheon-plan pantheon-review pantheon-team; do
  assert_equal_files "$ROOT/skills/$d/SKILL.md" "$PANTHEON_SKILLS_HOME/$d/SKILL.md"
done
INSTALLED_PANTHEON_SKILL="$PANTHEON_SKILLS_HOME/pantheon/SKILL.md"
INSTALLED_DAILY_SKILL="$PANTHEON_SKILLS_HOME/pantheon-daily/SKILL.md"
assert_contains "$INSTALLED_PANTHEON_SKILL" "Every new thread begins inactive"
assert_contains "$INSTALLED_PANTHEON_SKILL" "Once active, ordinary follow-ups stay in Pantheon"
assert_contains "$INSTALLED_PANTHEON_SKILL" "Deactivation clears the selected effort"
assert_contains "$INSTALLED_PANTHEON_SKILL" "does not by itself activate orchestration"
assert_contains "$INSTALLED_PANTHEON_SKILL" 'fork_turns: "none"'
assert_contains "$INSTALLED_DAILY_SKILL" "Every new thread begins inactive"
assert_contains "$INSTALLED_DAILY_SKILL" "Once Daily is active, ordinary follow-ups stay in Daily"
assert_contains "$INSTALLED_DAILY_SKILL" "Normally use no more than two specialist calls for one user request"
assert_contains "$INSTALLED_DAILY_SKILL" "Never use four or more specialist calls for one Daily request"
assert_contains "$INSTALLED_DAILY_SKILL" 'fork_turns: "none"'
for d in pantheon-plan pantheon-review pantheon-team; do
  assert_contains "$PANTHEON_SKILLS_HOME/$d/SKILL.md" "request-scoped"
done
assert_contains "$CODEX_HOME/AGENTS.md" "follow the relevant Pantheon workflow skill"
assert_contains "$CODEX_HOME/AGENTS.md" '$pantheon-daily'
assert_contains "$CODEX_HOME/AGENTS.md" "Daily follows its stricter quota-conscious routing ceiling"
assert_contains "$CODEX_HOME/AGENTS.md" 'Any Pantheon child spawn, including a direct named-agent request, defaults to `fork_turns: "none"`'
assert_contains "$CODEX_HOME/AGENTS.md" "Repository tests prove packaged policy/configuration"
pass "install preserves user configuration and installs all v0.4 payloads"

BEFORE="$(cksum "$CODEX_HOME/AGENTS.md")"
"$PANTHEON" install >/dev/null
AFTER="$(cksum "$CODEX_HOME/AGENTS.md")"
[ "$BEFORE" = "$AFTER" ] || fail "repeated install changed managed AGENTS.md unexpectedly"
[ "$(grep -Fxc '<!-- PANTHEON:START -->' "$CODEX_HOME/AGENTS.md")" -eq 1 ] || fail "repeated install duplicated block"
pass "install is idempotent"

printf 'drift\n' >> "$CODEX_HOME/agents/pantheon-explorer.toml"
if "$PANTHEON" doctor >/dev/null 2>&1; then
  fail "doctor should fail on drifted agent"
fi
"$PANTHEON" update >/dev/null
assert_equal_files "$ROOT/agents/pantheon-explorer.toml" "$CODEX_HOME/agents/pantheon-explorer.toml"
"$PANTHEON" doctor >/dev/null
pass "doctor detects drift and update repairs Pantheon-owned files"

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
rm -f "$CODEX_HOME/agents/pantheon-librarian.toml"
ln -s "$SENTINEL" "$CODEX_HOME/agents/pantheon-librarian.toml"
"$PANTHEON" update >/dev/null
assert_regular_not_symlink "$CODEX_HOME/agents/pantheon-librarian.toml"
assert_contains "$SENTINEL" "SENTINEL-UNCHANGED"
assert_equal_files "$ROOT/agents/pantheon-librarian.toml" "$CODEX_HOME/agents/pantheon-librarian.toml"
pass "update replaces agent symlinks with regular files without following the symlink target"

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
pass "doctor warns about possible legacy unmanaged Pantheon text"

"$PANTHEON" uninstall >/dev/null
assert_not_contains "$CODEX_HOME/AGENTS.md" "<!-- PANTHEON:START -->"
assert_contains "$CODEX_HOME/AGENTS.md" "Keep this exact user-owned line."
assert_contains "$CODEX_HOME/AGENTS.md" "Legacy Codex Pantheon note outside managed block."
assert_file "$CODEX_HOME/agents/user-custom.toml"
assert_file "$PANTHEON_SKILLS_HOME/user-skill/SKILL.md"
assert_not_file "$CODEX_HOME/.pantheon-version"
for f in "$ROOT"/agents/*.toml; do
  assert_not_file "$CODEX_HOME/agents/$(basename "$f")"
done
for d in pantheon pantheon-daily pantheon-plan pantheon-review pantheon-team; do
  assert_not_file "$PANTHEON_SKILLS_HOME/$d"
done
pass "uninstall removes only Pantheon-owned state"

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
mkdir -p "$HOME"
BOOT_OUT="$BOOT/bootstrap.out"
mkdir -p "$BOOT"
"$PANTHEON" bootstrap >"$BOOT_OUT" 2>&1
assert_contains "$BOOT_OUT" "Pantheon-owned files synchronized to v0.4.0."
assert_contains "$BOOT_OUT" "Status: HEALTHY"
assert_file "$CODEX_HOME/.pantheon-version"
assert_file "$PANTHEON_SKILLS_HOME/pantheon-daily/SKILL.md"
printf 'drift\n' >> "$CODEX_HOME/agents/pantheon-fixer.toml"
"$PANTHEON" bootstrap >"$BOOT_OUT" 2>&1
assert_equal_files "$ROOT/agents/pantheon-fixer.toml" "$CODEX_HOME/agents/pantheon-fixer.toml"
[ "$(grep -Fxc '<!-- PANTHEON:START -->' "$CODEX_HOME/AGENTS.md")" -eq 1 ] || fail "bootstrap duplicated managed block"
assert_contains "$BOOT_OUT" "Status: HEALTHY"
pass "bootstrap performs install-or-update plus doctor idempotently"

assert_contains "$ROOT/AGENTS.md" 'run `./pantheon bootstrap`'
assert_contains "$ROOT/AGENTS.md" 'Install Codex Pantheon for me.'
assert_contains "$ROOT/AGENTS.md" 'MUST NOT by itself activate Pantheon orchestration.'
assert_contains "$ROOT/README.md" 'operates on Pantheon and leaves Pantheon mode OFF.'
assert_contains "$ROOT/README.md" 'fork_turns: "none"'
assert_contains "$ROOT/README.md" "including direct named-agent requests"
assert_contains "$ROOT/README.md" '$pantheon-daily'
assert_contains "$ROOT/README.md" "normally uses 0-2 specialist calls"
assert_contains "$ROOT/docs/CODEX_INSTALL.md" 'Install Codex Pantheon for me.'
assert_contains "$ROOT/docs/CODEX_INSTALL.md" 'does not activate Pantheon orchestration.'
assert_contains "$ROOT/docs/CODEX_INSTALL.md" 'packaged policy/configuration and lifecycle safeguards'
assert_contains "$ROOT/docs/CODEX_INSTALL.md" 'pantheon-daily'
assert_contains "$ROOT/docs/USER_GUIDE.md" 'Native child spawns, including direct named-agent requests, default to `fork_turns: "none"`'
assert_contains "$ROOT/docs/USER_GUIDE.md" 'Pantheon Daily'
assert_contains "$ROOT/docs/DESIGN_DOCTRINE.md" 'context is a cost'
assert_contains "$ROOT/docs/DESIGN_DOCTRINE.md" 'Distinct operating profiles'
assert_contains "$ROOT/docs/V0.4.0.md" 'Daily Mode'
assert_contains "$ROOT/docs/V0.4.0.md" 'normally uses no more than two specialist calls'
pass "repository instructions and v0.4 documentation define lifecycle, Daily routing, efficiency, and evidence boundaries"

printf '1..%d\n' "$PASS"