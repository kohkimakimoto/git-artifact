---
title: delete
description: 保存用ブランチ先端からアーティファクトを削除します。
section: reference
order: 8
---

```sh
git artifact delete [options] NAME [NAME ...]
```

Remove the named アーティファクト directories from the storage branch tip in one commit. The local workspace is not modified. There is no `-a`.

| オプション | 用途 |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to update (default: `artifacts`). |
| `-n`, `--new-branch` | Create the named `-b` branch; fail if it already exists. |
| `-B`, `--base REF` | Creation base (default: `artifacts`); requires `-n`. |
| `-m`, `--message TEXT` | Commit message; repeat for paragraphs (not with `-F`). |
| `-F`, `--message-file PATH` | Read a UTF-8 commit message file (not with `-m`). |
| `-h`, `--help` | Show help. |
