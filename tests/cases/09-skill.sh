#!/usr/bin/env bash
# Skill output works outside Git, and installation is explicit and non-clobbering.
source "$(dirname "${BASH_SOURCE[0]}")/../common.sh"
mkdir "$TEST_ROOT/plain-directory"
cd "$TEST_ROOT/plain-directory"
git artifact skill >"$TEST_ROOT/skill.stdout" 2>"$TEST_ROOT/skill.stderr"
[[ -s "$TEST_ROOT/skill.stdout" ]] || fail 'Skill output was empty'
[[ ! -s "$TEST_ROOT/skill.stderr" ]] || fail 'Unexpected stdout-mode diagnostics'
assert_absent .agents

python_bin="$(python3 -c 'import sys; print(sys.executable)')"
PATH='' "$python_bin" "$PROJECT_DIR/bin/git-artifact" skill >"$TEST_ROOT/standalone"
cmp "$TEST_ROOT/skill.stdout" "$TEST_ROOT/standalone"

git artifact skill -o >"$TEST_ROOT/file.stdout" 2>"$TEST_ROOT/file.stderr"
[[ ! -s "$TEST_ROOT/file.stdout" ]] || fail 'File mode wrote to stdout'
cmp "$TEST_ROOT/skill.stdout" .agents/skills/git-artifact/SKILL.md
printf 'existing instructions\n' >.agents/skills/git-artifact/SKILL.md
expect_exit 1 git artifact skill -o
assert_eq "$(cat .agents/skills/git-artifact/SKILL.md)" 'existing instructions'
git artifact skill --output --force
cmp "$TEST_ROOT/skill.stdout" .agents/skills/git-artifact/SKILL.md

git artifact skill -o .claude/skills/git-artifact/SKILL.md
cmp "$TEST_ROOT/skill.stdout" .claude/skills/git-artifact/SKILL.md
git artifact skill -o "$TEST_ROOT/absolute path/nested/SKILL.md"
cmp "$TEST_ROOT/skill.stdout" "$TEST_ROOT/absolute path/nested/SKILL.md"
expect_exit 2 git artifact skill -f
expect_exit 1 git artifact skill -o .agents -f
printf 'keep this\n' >"$TEST_ROOT/target"
ln -s "$TEST_ROOT/target" linked-skill
expect_exit 1 git artifact skill -o linked-skill -f
assert_eq "$(cat "$TEST_ROOT/target")" 'keep this'
git artifact skill -h >/dev/null
