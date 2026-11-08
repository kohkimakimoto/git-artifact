---
title: skill
description: Print or install the embedded agent skill.
section: reference
order: 10
---

```sh
git artifact skill
git artifact skill -o
git artifact skill -o .claude/skills/git-artifact/SKILL.md
```

Print agent skill content (`SKILL.md`) to stdout, or write it with `-o`.

| Option | Purpose |
| --- | --- |
| `-o`, `--output [PATH]` | Write the skill to a file; default path `.agents/skills/git-artifact/SKILL.md`. |
| `-f`, `--force` | Overwrite an existing output file; requires `-o`. |
| `-h`, `--help` | Show help. |
