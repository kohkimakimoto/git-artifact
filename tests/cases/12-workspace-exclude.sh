#!/usr/bin/env bash
# Local workspace is excluded from ordinary Git adds.
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"
git artifact init
git artifact new topic -d 'notes'
printf 'body\n' >.artifacts/topic/a.md
git add -A
git status --porcelain >"$TEST_ROOT/status"
grep -F '.artifacts' "$TEST_ROOT/status" && fail 'workspace staged' || true
assert_eq "$(git status --porcelain)" ''
