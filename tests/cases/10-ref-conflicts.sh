#!/usr/bin/env bash
# Concurrent branch updates fail the compare-and-swap without dropping the winner.
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"
git artifact init
git artifact new topic -d 'notes'
printf 'value\n' >.artifacts/topic/a.md
export REAL_GIT="$(command -v git)"
tree="$(git rev-parse 'artifacts^{tree}')"
export RACE_OID="$(git commit-tree "$tree" -p artifacts -m 'Competing update')"
export RACE_REF=refs/heads/artifacts
original_path="$PATH"
export PATH="$TESTS_DIR/helpers:$PATH"
export GIT_EXEC_PATH="$TESTS_DIR/helpers"
expect_exit 3 git artifact save topic
assert_eq "$(git rev-parse artifacts)" "$RACE_OID"
export RACE_REF=refs/heads/artifacts-race
expect_exit 3 git artifact save -b artifacts-race -n -B artifacts topic
assert_eq "$(git rev-parse artifacts-race)" "$RACE_OID"
export PATH="$original_path"
unset GIT_EXEC_PATH
