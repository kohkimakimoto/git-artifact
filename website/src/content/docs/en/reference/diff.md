---
title: diff
description: Compare local Artifact files to the storage branch tip.
section: reference
order: 9
---

```sh
git artifact diff [options] NAME [NAME ...]
git artifact diff [options] -a
```

Compare local Artifact files to the selected branch tip. Exit status is `1` when any selected Artifact differs, otherwise `0`. Usage errors use exit status `2`.

| Option | Purpose |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to compare (default: `artifacts`). |
| `-a`, `--all` | Diff every Artifact present in the local workspace. |
| `-h`, `--help` | Show help. |
