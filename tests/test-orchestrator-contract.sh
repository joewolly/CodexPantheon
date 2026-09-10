#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
POLICY="$ROOT/policy/managed-block.md"
FULL="$ROOT/skills/pantheon/SKILL.md"
DAILY="$ROOT/skills/pantheon-daily/SKILL.md"
EXPLORER="$ROOT/agents/luna-explorer.toml"
LIBRARIAN="$ROOT/agents/luna-librarian.toml"
FIXER="$ROOT/agents/luna-fixer.toml"

fail() { printf 'not ok - %s\n' "$1" >&2; exit 1; }
contains() { grep -Fq -- "$2" "$1" || fail "expected '$2' in $1"; }
not_contains() { ! grep -Fq -- "$2" "$1" || fail "did not expect '$2' in $1"; }

contains "$POLICY" "exclusive workflow manager"
contains "$POLICY" "it never implements repository changes"
contains "$POLICY" "There is no size or delegation-overhead exception"
contains "$POLICY" 'every implementation edit routes to `luna_fixer`'
contains "$POLICY" "never take over implementation"
contains "$POLICY" "dependency-aware work graph"

contains "$FULL" "Route every repository implementation edit to Fixer, regardless of size or obviousness"
contains "$FULL" "Never fall back to Orchestrator implementation"
contains "$DAILY" "Fixer is mandatory for every repository implementation edit, including tiny or obvious changes"
contains "$DAILY" "never fall back to direct Orchestrator implementation"

contains "$EXPLORER" "fast read-only codebase navigation specialist"
contains "$EXPLORER" "Run independent searches in parallel when useful"
contains "$EXPLORER" "Do not design the solution"
contains "$EXPLORER" "delegate/spawn subagents"
contains "$LIBRARIAN" "read-only external research specialist"
contains "$LIBRARIAN" "Prefer primary/official sources"
contains "$LIBRARIAN" "distinguish authoritative behavior from community convention"
contains "$LIBRARIAN" "create the implementation plan"
contains "$FIXER" "fast focused implementation specialist"
contains "$FIXER" "complete bounded specification"
contains "$FIXER" "implement, do not plan or research"
contains "$FIXER" "No external research"
contains "$FIXER" "Do not act as the primary reviewer"
contains "$FIXER" "stop and return the blocker"

not_contains "$POLICY" "direct implementation is only"
not_contains "$POLICY" "delegation costs more than execution"
not_contains "$FULL" "substantive implementation"
not_contains "$DAILY" "Delegate only when a specialist materially reduces"

printf 'ok - Pantheon role ownership contracts are strict and implementation stays with Fixer\n'
