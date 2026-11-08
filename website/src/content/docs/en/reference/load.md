---
title: load
description: Expand Artifact files into the local workspace.
section: reference
order: 5
---

```sh
git artifact load [options] NAME [NAME ...]
git artifact load [options] -a
```

Expand Artifact files into `.artifacts/NAME/`. Does not write `.artifact.json`. Without `-f`, an existing local directory is rejected.

| Option | Purpose |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to read (default: `artifacts`). |
| `-a`, `--all` | Load every Artifact on the selected branch and revision. |
| `-f`, `--force` | Overwrite existing local Artifact directories. |
| `--revision REV` | Load from a commit reachable from the selected branch tip. |
| `-h`, `--help` | Show help. |
