#!/usr/bin/env bash
# Artifact names reject path separators and reserved forms.
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"
git artifact init
expect_exit 2 git artifact new '.'
expect_exit 2 git artifact new '..'
expect_exit 2 git artifact new 'a/b'
expect_exit 2 git artifact new 'a\b'
expect_exit 2 git artifact new 'README.md'
git artifact new '日本語'
git artifact new -- '-leading'
printf 'ok\n' >.artifacts/日本語/a.md
printf 'ok\n' >.artifacts/-leading/a.md
git artifact save -- '日本語' '-leading'
git artifact list --json >"$TEST_ROOT/names.json"
python3 -c '
import json,sys
names={i["name"] for i in json.load(open(sys.argv[1],encoding="utf-8"))}
assert names=={"日本語","-leading"}, names
' "$TEST_ROOT/names.json"
