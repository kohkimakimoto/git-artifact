---
title: describe
description: ファイルを変えずにアーティファクトのdescriptionを更新します。
section: reference
order: 7
---

```sh
git artifact describe [options] NAME TEXT
git artifact describe [options] NAME --clear
```

Update an アーティファクト's `description` on the storage branch without changing its files. Does not modify the local workspace.

| オプション | 用途 |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to update (default: `artifacts`). |
| `-n`, `--new-branch` | Create the named `-b` branch; fail if it already exists. |
| `-B`, `--base REF` | Creation base (default: `artifacts`); requires `-n`. |
| `--clear` | Set description to an empty string. |
| `-m`, `--message TEXT` | Commit message; repeat for paragraphs (not with `-F`). |
| `-F`, `--message-file PATH` | Read a UTF-8 commit message file (not with `-m`). |
| `-h`, `--help` | Show help. |
