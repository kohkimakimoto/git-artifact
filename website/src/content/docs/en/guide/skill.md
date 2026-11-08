---
title: Agent skill
description: Install the embedded SKILL.md for AI coding agents.
section: guide
order: 7
---

`git artifact skill` prints an embedded `SKILL.md` that explains Artifacts, workspace usage, and recommended agent workflow. Content ships inside the executable; no network access is required.

```sh
# Print the skill to stdout
git artifact skill

# Install it at the default path
git artifact skill -o

# Install it at a custom path
git artifact skill -o .claude/skills/git-artifact/SKILL.md
```

Use `-o` without a path to write `.agents/skills/git-artifact/SKILL.md`, or pass another file path. Existing files need `-f`. See [skill](/docs/reference/skill) for options.
