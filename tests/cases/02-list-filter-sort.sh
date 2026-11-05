#!/usr/bin/env bash
# list supports filter, sort, order, and JSON.
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"
git artifact init
git artifact new zebra -d 'last animal'
sleep 1
git artifact new alpha -d 'first animal'
git artifact new beta -d 'middle auth notes'

git artifact list --filter auth >"$TEST_ROOT/filtered"
grep -Eq '^beta$' "$TEST_ROOT/filtered" || fail 'Expected beta name line'
grep -Eq '^Created At:  ' "$TEST_ROOT/filtered" || fail 'Expected Created At line'
grep -Eq '^Updated At:  ' "$TEST_ROOT/filtered" || fail 'Expected Updated At line'
grep -Fq 'middle auth notes' "$TEST_ROOT/filtered" || fail 'Expected description'
grep -Fq zebra "$TEST_ROOT/filtered" && fail 'Unexpected zebra' || true
assert_eq "$(grep -c -E '^(Created At|Updated At):  ' "$TEST_ROOT/filtered" | tr -d ' ')" 2

git artifact list --sort name --order asc >"$TEST_ROOT/human.txt"
python3 -c '
from pathlib import Path
lines = Path("'"$TEST_ROOT/human.txt"'").read_text(encoding="utf-8").splitlines()
names = [
    line for i, line in enumerate(lines)
    if i + 1 < len(lines) and lines[i + 1].startswith("Created At:  ")
]
assert names == ["alpha", "beta", "zebra"], names
text = "\n".join(lines)
assert "first animal" in text
assert "middle auth notes" in text
assert "last animal" in text
'

# Multiline description is preserved without indentation.
git artifact describe alpha $'line one\nline two'
git artifact list --filter 'line one' >"$TEST_ROOT/multiline"
python3 -c '
from pathlib import Path
text = Path("'"$TEST_ROOT/multiline"'").read_text(encoding="utf-8")
assert text.startswith("alpha\n")
assert "line one\nline two\n" in text
assert "    line one" not in text
'

# Empty description omits the body block.
git artifact new bare
git artifact list --filter bare >"$TEST_ROOT/bare"
python3 -c '
from pathlib import Path
lines = Path("'"$TEST_ROOT/bare"'").read_text(encoding="utf-8").splitlines()
assert lines[0] == "bare"
assert lines[1].startswith("Created At:  ")
assert lines[2].startswith("Updated At:  ")
assert len(lines) == 3, lines
'

# Name uses git-log yellow when color.ui=always; NO_COLOR disables it.
env -u NO_COLOR git -c color.ui=always artifact list --filter bare >"$TEST_ROOT/color"
grep -Fq $'\033[33mbare\033[m' "$TEST_ROOT/color" || fail 'Expected yellow name'
NO_COLOR=1 git -c color.ui=always artifact list --filter bare >"$TEST_ROOT/nocolor"
grep -Fq $'\033[' "$TEST_ROOT/nocolor" && fail 'Unexpected color with NO_COLOR' || true
grep -Eq '^bare$' "$TEST_ROOT/nocolor" || fail 'Expected plain name with NO_COLOR'

git artifact list --sort name --order asc --json >"$TEST_ROOT/by-name.json"
python3 -c '
import json,sys
names=[i["name"] for i in json.load(open(sys.argv[1],encoding="utf-8"))]
assert names==["alpha","bare","beta","zebra"], names
' "$TEST_ROOT/by-name.json"

git artifact list --sort created_at --order desc --json >"$TEST_ROOT/by-created.json"
python3 -c '
import json,sys
names=[i["name"] for i in json.load(open(sys.argv[1],encoding="utf-8"))]
assert names[0]=="bare"
assert names[-1]=="zebra"
' "$TEST_ROOT/by-created.json"

expect_exit 2 git artifact list --sort bogus
expect_exit 2 git artifact list --order sideways
