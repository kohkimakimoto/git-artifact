#!/usr/bin/env bash
# -a scopes correctly; save -a does not create or delete missing Artifacts.
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"
git artifact init
git artifact new one -d '1'
git artifact new two -d '2'
printf '1\n' >.artifacts/one/a.md
printf '2\n' >.artifacts/two/a.md
git artifact save -a
rm -rf .artifacts
git artifact load -a
cmp .artifacts/one/a.md <(printf '1\n')
cmp .artifacts/two/a.md <(printf '2\n')

printf '1b\n' >.artifacts/one/a.md
rm -rf .artifacts/two
git artifact save -a
git show artifacts:one/a.md | cmp - <(printf '1b\n')
git show artifacts:two/a.md | cmp - <(printf '2\n')

git artifact new three -d '3'
before="$(git rev-parse artifacts)"
git artifact save -a
# three is empty locally and empty on storage aside from metadata timestamps;
# updated_at changes so a commit may be created. Accept either no-op or update.
after="$(git rev-parse artifacts)"
[[ "$after" == "$before" || "$(git rev-parse "$after"^)" == "$before" ]] || fail 'unexpected history'

# Dot-prefixed Artifact names participate in every bulk operation.
git artifact new .hidden
printf 'hidden\n' >.artifacts/.hidden/a.md
expect_exit 1 git artifact diff -a
grep -Fq '+++ b/.hidden/a.md' "$TEST_ROOT/last.stdout" || fail 'Expected dot-prefixed Artifact diff'
git artifact save -a
git show artifacts:.hidden/a.md | cmp - <(printf 'hidden\n')
expect_exit 0 git artifact diff -a
rm -rf .artifacts/.hidden
git artifact load -a -f
cmp .artifacts/.hidden/a.md <(printf 'hidden\n')
