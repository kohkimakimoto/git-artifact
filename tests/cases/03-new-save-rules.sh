#!/usr/bin/env bash
# new is create-only; save is update-only; local mkdir is not enough for save.
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"
git artifact init
git artifact new topic -d 'notes'
expect_exit 1 git artifact new topic
printf 'x\n' >.artifacts/topic/a.md
git artifact save topic

# Reserved names at any depth fail without moving the branch or changing local files.
printf 'not metadata\n' >.artifacts/topic/.artifact.json
tip_before=$(git rev-parse artifacts)
expect_exit 1 git artifact save topic
grep -Fq 'Reserved filename .artifact.json: .artifact.json' "$TEST_ROOT/last.stderr" || fail 'Expected reserved filename error'
assert_eq "$(git rev-parse artifacts)" "$tip_before"
assert_eq "$(cat .artifacts/topic/.artifact.json)" 'not metadata'
expect_exit 1 git artifact diff topic
grep -Fq 'Reserved filename .artifact.json: .artifact.json' "$TEST_ROOT/last.stderr" || fail 'Expected reserved filename error'
rm .artifacts/topic/.artifact.json
mkdir -p .artifacts/topic/nested/deeper
printf 'keep me\n' >.artifacts/topic/nested/deeper/.artifact.json
tip_before=$(git rev-parse artifacts)
expect_exit 1 git artifact save topic
grep -Fq 'Reserved filename .artifact.json: nested/deeper/.artifact.json' "$TEST_ROOT/last.stderr" || fail 'Expected reserved filename error'
assert_eq "$(git rev-parse artifacts)" "$tip_before"
assert_eq "$(cat .artifacts/topic/nested/deeper/.artifact.json)" 'keep me'
expect_exit 1 git artifact diff topic
grep -Fq 'Reserved filename .artifact.json: nested/deeper/.artifact.json' "$TEST_ROOT/last.stderr" || fail 'Expected reserved filename error'
rm .artifacts/topic/nested/deeper/.artifact.json
mkdir .artifacts/topic/nested/deeper/.artifact.json
expect_exit 1 git artifact save -a
assert_eq "$(git rev-parse artifacts)" "$tip_before"
rm -rf .artifacts/topic/nested

mkdir -p .artifacts/orphan
printf 'y\n' >.artifacts/orphan/a.md
expect_exit 1 git artifact save orphan
expect_exit 1 git artifact save missing

rm -rf .artifacts/topic
expect_exit 1 git artifact save topic
git artifact load topic
expect_exit 1 git artifact load topic
git artifact load -f topic

expect_exit 2 git artifact save
expect_exit 2 git artifact save -a topic
expect_exit 2 git artifact new

# Reject a workspace file before committing; creation can be retried after removal.
mv .artifacts "$TEST_ROOT/workspace-backup"
printf 'occupied\n' >.artifacts
tip_before=$(git rev-parse artifacts)
expect_exit 1 git artifact new retry-topic
grep -Fq 'Not a directory: .artifacts' "$TEST_ROOT/last.stderr" || fail 'Expected workspace directory error'
assert_eq "$(git rev-parse artifacts)" "$tip_before"
assert_eq "$(cat .artifacts)" 'occupied'
rm .artifacts
git artifact new retry-topic
[[ -d .artifacts/retry-topic ]] || fail 'Expected local Artifact directory'
git show artifacts:retry-topic/.artifact.json >/dev/null
