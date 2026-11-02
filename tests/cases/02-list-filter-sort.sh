#!/usr/bin/env bash
# list supports filter, sort, order, and JSON.
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"
git artifact init
git artifact new zebra -d 'last animal'
sleep 1
git artifact new alpha -d 'first animal'
git artifact new beta -d 'middle auth notes'

git artifact list --filter auth >"$TEST_ROOT/filtered"
grep -Eq '^NAME +DESCRIPTION +CREATED_AT +UPDATED_AT$' "$TEST_ROOT/filtered" || fail 'Expected header row'
grep -Fq beta "$TEST_ROOT/filtered" || fail 'Expected beta in filter'
grep -Fq zebra "$TEST_ROOT/filtered" && fail 'Unexpected zebra' || true
assert_eq "$(wc -l <"$TEST_ROOT/filtered" | tr -d ' ')" 2

git artifact list --sort name --order asc --json >"$TEST_ROOT/by-name.json"
python3 -c '
import json,sys
names=[i["name"] for i in json.load(open(sys.argv[1],encoding="utf-8"))]
assert names==["alpha","beta","zebra"], names
' "$TEST_ROOT/by-name.json"

git artifact list --sort created_at --order desc --json >"$TEST_ROOT/by-created.json"
python3 -c '
import json,sys
names=[i["name"] for i in json.load(open(sys.argv[1],encoding="utf-8"))]
assert names[0]=="beta"
assert names[-1]=="zebra"
' "$TEST_ROOT/by-created.json"

expect_exit 2 git artifact list --sort bogus
expect_exit 2 git artifact list --order sideways
