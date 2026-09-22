#!/usr/bin/env bash
set -euo pipefail

ROOT="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
AGENTS="$ROOT/AGENTS.md"
POLICY="$ROOT/policy/managed-block.md"
FULL="$ROOT/skills/pantheon/SKILL.md"
DAILY="$ROOT/skills/pantheon-daily/SKILL.md"
PLAN="$ROOT/skills/pantheon-plan/SKILL.md"
REVIEW="$ROOT/skills/pantheon-review/SKILL.md"
EXPLORER="$ROOT/agents/luna-explorer.toml"
LIBRARIAN="$ROOT/agents/luna-librarian.toml"
FIXER="$ROOT/agents/luna-fixer.toml"

fail() { printf 'not ok - %s\n' "$1" >&2; exit 1; }
contains() { grep -Fq -- "$2" "$1" || fail "expected '$2' in $1"; }
not_contains() { ! grep -Fq -- "$2" "$1" || fail "did not expect '$2' in $1"; }

contains "$POLICY" "The Orchestrator never implements repository changes"
contains "$POLICY" "Choose the shortest safe flow"
contains "$POLICY" "structured receipts separating confirmed facts, inference, unknowns, and decision impact"
contains "$POLICY" "bounded packet: objective; scope/non-goals; owned files/surfaces"
contains "$POLICY" "unfinished evidence cannot change an issued Fixer specification"
contains "$POLICY" "Fixer owns focused implementation checks"
contains "$POLICY" "Corrections are delta-only"
contains "$POLICY" 'Use `send_message` only for the same running assignment'
contains "$POLICY" 'Fresh-spawn new/unrelated completed work'
contains "$POLICY" "never take over implementation"

contains "$AGENTS" "Choose the shortest safe flow for each request"
contains "$AGENTS" "structured evidence receipts"
contains "$AGENTS" "bounded implementation packet"
contains "$AGENTS" "Correction loops are delta-only"
contains "$AGENTS" "fresh-spawn new or unrelated completed work"
contains "$AGENTS" "Never delegate review judgment to Explorer"

contains "$FULL" "Choose the shortest safe flow"
contains "$FULL" "Reconcile required evidence receipts"
contains "$FULL" "Multiple Fixers may run in parallel only with explicit non-overlapping write ownership"
contains "$FULL" "structured implementation receipt"
contains "$FULL" "Corrections send only the verification delta"
contains "$FULL" "fresh-spawn new/unrelated completed work"
contains "$FULL" "never implement directly"

contains "$DAILY" "Choose the shortest safe flow"
contains "$DAILY" "Fixer is mandatory for every repository implementation edit"
contains "$DAILY" "Never parallelize children"
contains "$DAILY" "bounded packet"
contains "$DAILY" "structured implementation receipt"
contains "$DAILY" "verification delta"
contains "$DAILY" "fresh-spawn new completed work"

contains "$PLAN" "hard dependency barrier"
contains "$PLAN" "do not use Fixer"
contains "$REVIEW" "hard dependency barrier"
contains "$REVIEW" "do not use Fixer"
contains "$REVIEW" "The main-thread Orchestrator owns review and verdict"

contains "$EXPLORER" "Return this evidence receipt"
contains "$EXPLORER" "Confirmed:"
contains "$EXPLORER" "Inference:"
contains "$EXPLORER" "Decision impact:"
contains "$EXPLORER" "During review workflows"
contains "$LIBRARIAN" "Return this evidence receipt"
contains "$LIBRARIAN" "authoritative source/reference"
contains "$LIBRARIAN" "Decision impact:"
contains "$FIXER" "bounded packet"
contains "$FIXER" "acceptance criteria"
contains "$FIXER" "Do not act as primary reviewer"
contains "$FIXER" "final acceptance/regression judgment belongs to the Orchestrator"
contains "$FIXER" "Status: completed | partial | blocked"
contains "$FIXER" "PASS | FAIL | SKIPPED | UNKNOWN"
contains "$FIXER" "Parent verification"

not_contains "$POLICY" "direct implementation is only"
not_contains "$FULL" "substantive implementation"
not_contains "$DAILY" "Delegate only when a specialist materially reduces"

printf 'ok - Pantheon optimized workflow contracts are strict\n'
