---
title: list
description: List Artifacts on the storage branch.
section: reference
order: 3
---

```sh
git artifact list [options]
```

List Artifacts on the selected branch. Human output is one vertical record per Artifact. `--json` prints the same fields (timestamps in UTC with `Z`) and is never colored.

| Option | Purpose |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to read (default: `artifacts`). |
| `--sort FIELD` | Sort by `name`, `created_at`, or `updated_at` (default: `name`). |
| `--order ORDER` | `asc` or `desc` (default: `asc`). |
| `--filter TEXT` | Keep Artifacts whose name or description contains `TEXT`. |
| `--json` | Print JSON. |
| `-h`, `--help` | Show help. |
