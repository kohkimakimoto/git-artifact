---
title: new
description: Create a new Artifact and empty workspace directory.
section: reference
order: 4
---

```sh
git artifact new [options] NAME
```

Create a new Artifact on the storage branch and an empty local directory at `.artifacts/NAME/`. Writes only `.artifact.json` on the branch; the workspace never receives `.artifact.json`.

| Option | Purpose |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to update (default: `artifacts`). |
| `-n`, `--new-branch` | Create the named `-b` branch; fail if it already exists. |
| `-B`, `--base REF` | Creation base (default: `artifacts`); requires `-n`. |
| `-d`, `--description TEXT` | Initial description (default: empty). |
| `-m`, `--message TEXT` | Commit message; repeat for paragraphs (not with `-F`). |
| `-F`, `--message-file PATH` | Read a UTF-8 commit message file (not with `-m`). |
| `-h`, `--help` | Show help. |
