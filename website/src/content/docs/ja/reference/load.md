---
title: load
description: アーティファクトのファイルをローカルワークスペースへ展開します。
section: reference
order: 5
---

```sh
git artifact load [options] NAME [NAME ...]
git artifact load [options] -a
```

Expand アーティファクト files into `.artifacts/NAME/`. Does not write `.artifact.json`. Without `-f`, an existing local directory is rejected.

| オプション | 用途 |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to read (default: `artifacts`). |
| `-a`, `--all` | Load every アーティファクト on the selected branch and revision. |
| `-f`, `--force` | Overwrite existing local アーティファクト directories. |
| `--revision REV` | Load from a commit reachable from the selected branch tip. |
| `-h`, `--help` | Show help. |
