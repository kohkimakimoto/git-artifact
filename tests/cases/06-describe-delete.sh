#!/usr/bin/env bash
# describe updates metadata; delete removes storage and leaves local alone.
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"
git artifact init
git artifact new topic -d 'first'
printf 'body\n' >.artifacts/topic/a.md
git artifact save topic
git artifact describe topic 'second'
meta="$(git show artifacts:topic/.artifact.json)"
python3 -c '
import json,sys
meta=json.loads(sys.argv[1])
assert meta["description"]=="second"
assert meta["created_at"]
' "$meta"
git artifact describe topic --clear
meta="$(git show artifacts:topic/.artifact.json)"
python3 -c '
import json,sys
meta=json.loads(sys.argv[1])
assert meta["description"]==""
' "$meta"
expect_exit 2 git artifact describe topic
expect_exit 2 git artifact describe topic --clear 'x'
expect_exit 2 git artifact describe topic ''
expect_exit 1 git artifact describe missing 'x'

git artifact new other -d 'keep'
git artifact delete topic
expect_exit 128 git show artifacts:topic/a.md
[[ -f .artifacts/topic/a.md ]] || fail 'delete touched local workspace'
git show artifacts:other/.artifact.json >/dev/null
expect_exit 1 git artifact delete missing
expect_exit 2 git artifact delete
