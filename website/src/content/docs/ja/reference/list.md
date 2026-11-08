---
title: list
description: 保存用ブランチ上のアーティファクトを一覧表示します。
section: reference
order: 3
---

```sh
git artifact list [options]
```

List アーティファクト on the selected branch. Human output is one vertical record per アーティファクト. `--json` prints the same fields (timestamps in UTC with `Z`) and is never colored.

| オプション | 用途 |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to read (default: `artifacts`). |
| `--sort FIELD` | Sort by `name`, `created_at`, or `updated_at` (default: `name`). |
| `--order ORDER` | `asc` or `desc` (default: `asc`). |
| `--filter TEXT` | Keep アーティファクト whose name or description contains `TEXT`. |
| `--json` | Print JSON. |
| `-h`, `--help` | Show help. |
