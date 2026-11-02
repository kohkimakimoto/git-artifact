#!/usr/bin/env bash
# Create, save, load, list, and keep the application branch untouched.
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"
remember_app_state
git artifact init
assert_eq "$(git rev-list --parents artifacts)" "$(git rev-parse artifacts)"
initial="$(git rev-parse artifacts)"
expect_exit 1 git artifact init

git artifact new auth-redesign -d 'Auth redesign notes'
assert_eq "$(git rev-parse artifacts^)" "$initial"
[[ -d .artifacts/auth-redesign ]] || fail 'new did not create local directory'
assert_absent .artifacts/auth-redesign/.artifact.json
printf '%s\n' '# Auth redesign' >.artifacts/auth-redesign/design.md
mkdir -p .artifacts/auth-redesign/data
printf 'a,b\n1,2\n' >.artifacts/auth-redesign/data/bench.csv
printf 'plain\000\377\n' >.artifacts/auth-redesign/binary.bin

after_new="$(git rev-parse artifacts)"
git artifact save auth-redesign
saved="$(git rev-parse artifacts)"
assert_eq "$(git rev-parse artifacts^)" "$after_new"
git show artifacts:auth-redesign/.artifact.json >"$TEST_ROOT/meta.json"
python3 -c '
import json,sys
meta=json.load(open(sys.argv[1],encoding="utf-8"))
assert meta["description"]=="Auth redesign notes"
assert meta["created_at"].endswith("Z")
assert meta["updated_at"].endswith("Z")
' "$TEST_ROOT/meta.json"

rm -rf .artifacts/auth-redesign
git artifact load auth-redesign
assert_absent .artifacts/auth-redesign/.artifact.json
cmp .artifacts/auth-redesign/design.md <(printf '%s\n' '# Auth redesign')
cmp .artifacts/auth-redesign/data/bench.csv <(printf 'a,b\n1,2\n')
cmp .artifacts/auth-redesign/binary.bin <(printf 'plain\000\377\n')

printf 'changed\n' >.artifacts/auth-redesign/design.md
git artifact save auth-redesign
git artifact load -f --revision "$saved" auth-redesign
cmp .artifacts/auth-redesign/design.md <(printf '%s\n' '# Auth redesign')

git artifact list --json >"$TEST_ROOT/list.json"
python3 -c '
import json,sys
items=json.load(open(sys.argv[1],encoding="utf-8"))
assert len(items)==1
assert items[0]["name"]=="auth-redesign"
assert items[0]["description"]=="Auth redesign notes"
' "$TEST_ROOT/list.json"

assert_app_unchanged
if git ls-files | grep -F '.artifacts'; then
    fail 'workspace tracked on application branch'
fi
