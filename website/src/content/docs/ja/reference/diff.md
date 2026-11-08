---
title: diff
description: ローカルアーティファクトと保存用ブランチ先端を比較します。
section: reference
order: 9
---

```sh
git artifact diff [options] NAME [NAME ...]
git artifact diff [options] -a
```

Compare local アーティファクト files to the selected branch tip. Exit status is `1` when any selected アーティファクト differs, otherwise `0`. Usage errors use exit status `2`.

| オプション | 用途 |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to compare (default: `artifacts`). |
| `-a`, `--all` | Diff every アーティファクト present in the local workspace. |
| `-h`, `--help` | Show help. |
