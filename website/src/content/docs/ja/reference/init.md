---
title: init
description: 孤立したartifactsブランチを作成します。
section: reference
order: 2
---

```sh
git artifact init [options]
```

Create a local orphan artifacts branch (default name `artifacts`) with a root `README.md` describing the branch. The branch must not already exist. Does not switch `HEAD` or rewrite application history.

| オプション | 用途 |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to create (default: `artifacts`). |
| `-m`, `--message TEXT` | Commit message; repeat for paragraphs (not with `-F`). |
| `-F`, `--message-file PATH` | Read a UTF-8 commit message file (not with `-m`). |
| `-h`, `--help` | Show help. |
