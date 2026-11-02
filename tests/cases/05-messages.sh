#!/usr/bin/env bash
# Commit messages accept -m / -F and reject empty or conflicting options.
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"
git artifact init -m 'Custom init'
assert_eq "$(git log -1 --format=%s artifacts)" 'Custom init'
git artifact new topic -m 'Create topic'
assert_eq "$(git log -1 --format=%s artifacts)" 'Create topic'
printf 'body\n' >.artifacts/topic/a.md
printf 'From file\n\nSecond paragraph\n' >"$TEST_ROOT/msg.txt"
git artifact save -F "$TEST_ROOT/msg.txt" topic
assert_eq "$(git log -1 --format=%s artifacts)" 'From file'
assert_eq "$(git log -1 --format=%b artifacts)" 'Second paragraph'
expect_exit 2 git artifact save -m 'x' -F "$TEST_ROOT/msg.txt" topic
printf '' >"$TEST_ROOT/empty.txt"
expect_exit 2 git artifact save -F "$TEST_ROOT/empty.txt" topic
expect_exit 2 git artifact save -F - topic
