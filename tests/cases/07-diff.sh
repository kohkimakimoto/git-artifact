#!/usr/bin/env bash
# diff compares local file presence, modes, and contents to the storage tip.
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"
git artifact init
git artifact new topic -d 'notes'
printf 'one\n' >.artifacts/topic/a.md
printf 'two\n' >.artifacts/topic/b.md
git artifact save topic
git artifact diff topic >"$TEST_ROOT/diff.out"
assert_eq "$(cat "$TEST_ROOT/diff.out")" ''

printf 'changed\n' >.artifacts/topic/a.md
expect_exit 1 git artifact diff topic
grep -Fq -- '--- a/topic/a.md' "$TEST_ROOT/last.stdout" || fail 'Expected --- a/topic/a.md'
grep -Fq -- '+++ b/topic/a.md' "$TEST_ROOT/last.stdout" || fail 'Expected +++ b/topic/a.md'

rm .artifacts/topic/a.md
expect_exit 1 git artifact diff topic
grep -Fq -- '--- a/topic/a.md' "$TEST_ROOT/last.stdout" || fail 'Expected deletion diff'

rm -rf .artifacts/topic
expect_exit 0 git artifact diff topic
grep -Fq 'Absent: topic' "$TEST_ROOT/last.stdout" || fail 'Expected Absent'

git artifact load topic
git artifact new local-only -d 'x'
printf 'only\n' >.artifacts/local-only/c.md
expect_exit 1 git artifact diff local-only
grep -Fq -- '+++ b/local-only/c.md' "$TEST_ROOT/last.stdout" || fail 'Expected local-only addition'

expect_exit 2 git artifact diff
expect_exit 2 git artifact diff -a topic

git artifact new file-changes
touch .artifacts/file-changes/empty
expect_exit 1 git artifact diff file-changes
grep -Fq 'diff --git a/file-changes/empty b/file-changes/empty' "$TEST_ROOT/last.stdout" || fail 'Expected empty file addition'
grep -Fq 'new file mode 100644' "$TEST_ROOT/last.stdout" || fail 'Expected new file mode'
git artifact save file-changes
expect_exit 0 git artifact diff file-changes
rm .artifacts/file-changes/empty
expect_exit 1 git artifact diff file-changes
grep -Fq 'deleted file mode 100644' "$TEST_ROOT/last.stdout" || fail 'Expected empty file deletion'
git artifact save file-changes
expect_exit 0 git artifact diff file-changes

printf 'echo test\n' >.artifacts/file-changes/script
chmod 644 .artifacts/file-changes/script
git artifact save file-changes
chmod 755 .artifacts/file-changes/script
expect_exit 1 git artifact diff file-changes
grep -Fq 'old mode 100644' "$TEST_ROOT/last.stdout" || fail 'Expected old mode'
grep -Fq 'new mode 100755' "$TEST_ROOT/last.stdout" || fail 'Expected executable mode'
git artifact save file-changes
expect_exit 0 git artifact diff file-changes
chmod 644 .artifacts/file-changes/script
printf 'echo changed\n' >.artifacts/file-changes/script
expect_exit 1 git artifact diff file-changes
grep -Fq 'old mode 100755' "$TEST_ROOT/last.stdout" || fail 'Expected executable old mode'
grep -Fq 'new mode 100644' "$TEST_ROOT/last.stdout" || fail 'Expected regular new mode'
grep -Fq '+echo changed' "$TEST_ROOT/last.stdout" || fail 'Expected content diff alongside mode change'

# An Artifact absent from storage can contain only an empty file.
git artifact new empty-local-only
git artifact delete empty-local-only
touch .artifacts/empty-local-only/empty
expect_exit 1 git artifact diff empty-local-only
grep -Fq 'new file mode 100644' "$TEST_ROOT/last.stdout" || fail 'Expected local-only empty file addition'

# Missing final newlines must produce patches that preserve the exact bytes.
python3 - <<'PY'
import os
from pathlib import Path
import runpy
import subprocess
import tempfile

diff_text = runpy.run_path(str(Path(os.environ["PROJECT_DIR"]) / "bin/git-artifact"))["unified_diff_text"]
cases = [
    (b"old", b"new"),
    (b"old\n", b"new"),
    (b"old", b"new\n"),
    (b"same", b"same\n"),
    (b"same\n", b"same"),
    (b"old\ntail", b"new\ntail"),
    (b"", b"new"),
    (b"old", b""),
]
with tempfile.TemporaryDirectory(dir=os.environ["TEST_ROOT"]) as directory:
    path = Path(directory) / "file"
    for stored, local in cases:
        patch = diff_text("file", stored, local).encode("utf-8")
        assert b"\\ No newline at end of file\n" in patch, patch
        path.write_bytes(stored)
        subprocess.run(["git", "apply", "--check", "-"], input=patch, cwd=directory, check=True)
        subprocess.run(["git", "apply", "-"], input=patch, cwd=directory, check=True)
        assert path.read_bytes() == local, (stored, local, patch)
PY
