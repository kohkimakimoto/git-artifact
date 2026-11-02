#!/usr/bin/env bash
# New branches require an explicit request and retain the specified base.
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"
git artifact init
git artifact new topic -d 'notes'
printf 'value\n' >.artifacts/topic/a.md
remember_app_state
base="$(git rev-parse artifacts)"
expect_exit 1 git artifact save -b typo topic
expect_exit 2 git artifact save -n topic
expect_exit 2 git artifact save -B artifacts topic
git artifact save -b artifacts-change -n -B artifacts topic
assert_eq "$(git rev-parse artifacts)" "$base"
assert_eq "$(git rev-parse artifacts-change^)" "$base"
printf 'value2\n' >.artifacts/topic/a.md
git artifact save -b artifacts-change topic
expect_exit 1 git artifact save -b artifacts-change -n topic
expect_exit 1 git artifact save -b failed-change -n -B missing topic
expect_exit 1 git show-ref --verify --quiet refs/heads/failed-change
expect_exit 1 git artifact load --revision main -f topic
assert_app_unchanged

git worktree add -q "$TEST_ROOT/merge-tree" artifacts
expect_exit 1 git artifact save topic
git worktree remove "$TEST_ROOT/merge-tree"
assert_eq "$(git artifact list --json | python3 -c 'import json,sys; print(json.load(sys.stdin)[0]["name"])')" topic
