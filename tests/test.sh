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
assert_contains() { grep -Fq "$2" "$1" || fail "expected '$2' in $1"; }
assert_not_contains() { ! grep -Fq "$2" "$1" || fail "did not expect '$2' in $1"; }
assert_regular_not_symlink() { [ -f "$1" ] && [ ! -L "$1" ] || fail "expected regular non-symlink file: $1"; }
assert_equal_files() { cmp -s "$1" "$2" || fail "files differ: $1 $2"; }

bash -n "$PANTHEON" "$ROOT/install.sh" "$0"
pass "shell syntax"

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
assert_contains "$CODEX_HOME/.pantheon-version" "0.2.0"
assert_file "$CODEX_HOME/agents/user-custom.toml"
assert_file "$PANTHEON_SKILLS_HOME/user-skill/SKILL.md"
for f in "$ROOT"/agents/*.toml; do
  base="$(basename "$f")"
  assert_regular_not_symlink "$CODEX_HOME/agents/$base"
  assert_equal_files "$f" "$CODEX_HOME/agents/$base"
done
for d in pantheon pantheon-plan pantheon-review pantheon-team; do
  assert_equal_files "$ROOT/skills/$d/SKILL.md" "$PANTHEON_SKILLS_HOME/$d/SKILL.md"
done
pass "install preserves user configuration and installs all Pantheon payloads"

INSTALLED_PANTHEON_SKILL="$PANTHEON_SKILLS_HOME/pantheon/SKILL.md"
assert_contains "$INSTALLED_PANTHEON_SKILL" "Every new thread begins with Pantheon inactive"
assert_contains "$INSTALLED_PANTHEON_SKILL" 'When Pantheon is inactive, activating without an effort instruction selects `normal`.'
assert_contains "$INSTALLED_PANTHEON_SKILL" 'The user does not need to repeat `$pantheon`.'
assert_contains "$INSTALLED_PANTHEON_SKILL" "Activation may happen on the first message or at any later point."
assert_contains "$INSTALLED_PANTHEON_SKILL" "The selected effort remains in effect for later requests while Pantheon is active"
assert_contains "$INSTALLED_PANTHEON_SKILL" 'Ordinary follow-ups and a repeated bare `$pantheon` do not reset it.'
assert_contains "$INSTALLED_PANTHEON_SKILL" "Use deep orchestration for this task."
assert_contains "$INSTALLED_PANTHEON_SKILL" "switch Pantheon to fast"
assert_contains "$INSTALLED_PANTHEON_SKILL" "use normal Pantheon effort"
assert_contains "$INSTALLED_PANTHEON_SKILL" "switch Pantheon to deep"
assert_contains "$INSTALLED_PANTHEON_SKILL" "A clear request to disable Pantheon returns the thread to normal non-Pantheon behavior."
assert_contains "$INSTALLED_PANTHEON_SKILL" 'Reactivating without an effort instruction selects `normal`'
assert_contains "$INSTALLED_PANTHEON_SKILL" "Never activate or deactivate Pantheon merely because a request is difficult"
assert_contains "$INSTALLED_PANTHEON_SKILL" "Never carry it into a new or unrelated thread"
assert_contains "$CODEX_HOME/AGENTS.md" "Once activated, continue using Pantheon for ordinary follow-up requests in that thread"
assert_contains "$CODEX_HOME/AGENTS.md" "Deactivation clears the effort"
for unsupported in '$pantheon fast' '$pantheon normal' '$pantheon deep'; do
  assert_not_contains "$INSTALLED_PANTHEON_SKILL" "$unsupported"
  assert_not_contains "$CODEX_HOME/AGENTS.md" "$unsupported"
  assert_not_contains "$ROOT/README.md" "$unsupported"
done
for d in pantheon-plan pantheon-review pantheon-team; do
  assert_contains "$PANTHEON_SKILLS_HOME/$d/SKILL.md" "does not become a sticky"
done
pass "installed policy and skill contain the canonical thread-persistence contract"

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
for d in pantheon pantheon-plan pantheon-review pantheon-team; do
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
assert_contains "$BOOT_OUT" "Pantheon-owned files synchronized to v0.2.0."
assert_contains "$BOOT_OUT" "Status: HEALTHY"
assert_file "$CODEX_HOME/.pantheon-version"
printf 'drift\n' >> "$CODEX_HOME/agents/pantheon-fixer.toml"
"$PANTHEON" bootstrap >"$BOOT_OUT" 2>&1
assert_equal_files "$ROOT/agents/pantheon-fixer.toml" "$CODEX_HOME/agents/pantheon-fixer.toml"
[ "$(grep -Fxc '<!-- PANTHEON:START -->' "$CODEX_HOME/AGENTS.md")" -eq 1 ] || fail "bootstrap duplicated managed block"
assert_contains "$BOOT_OUT" "Status: HEALTHY"
pass "bootstrap performs install-or-update plus doctor idempotently"

assert_contains "$ROOT/AGENTS.md" 'run `./pantheon bootstrap`'
assert_contains "$ROOT/docs/CODEX_INSTALL.md" 'Install Codex Pantheon for me.'
pass "repository instructions define Codex-assisted install behavior"

printf '1..%d\n' "$PASS"
