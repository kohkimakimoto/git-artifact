---
title: save
description: Replace Artifacts on the storage branch from the workspace.
section: reference
order: 6
---

```sh
git artifact save [options] NAME [NAME ...]
git artifact save [options] -a
```

Replace existing Artifacts on the storage branch with the local workspace snapshots and create a commit. Local files named `.artifact.json` anywhere under the Artifact are rejected.

| Option | Purpose |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to update (default: `artifacts`). |
| `-a`, `--all` | Save every Artifact present in the local workspace. |
| `-n`, `--new-branch` | Create the named `-b` branch; fail if it already exists. |
| `-B`, `--base REF` | Creation base (default: `artifacts`); requires `-n`. |
| `-m`, `--message TEXT` | Commit message; repeat for paragraphs (not with `-F`). |
| `-F`, `--message-file PATH` | Read a UTF-8 commit message file (not with `-m`). |
| `-h`, `--help` | Show help. |
