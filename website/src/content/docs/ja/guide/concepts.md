---
title: 基本概念
description: アーティファクト、保存用ブランチ、ローカルワークスペース。
section: guide
order: 4
---

| 用語 | 意味 |
| --- | --- |
| アーティファクト | 開発時の生成物をまとめたディレクトリ。関連ファイルと、ツールが管理する `.artifact.json` を含む（ディレクトリ名がアーティファクト名） |
| 保存用ブランチ | すべてのアーティファクトを保持する孤立ブランチ（デフォルト: `artifacts`） |
| ローカルワークスペース | 現在のGitワークツリーのルートにある `.artifacts/` |

<h2 id="rules-that-matter-day-to-day">日常の操作で重要なルール</h2>

- `new` はアーティファクトを作成し、`save` は既存のアーティファクトを更新します。
- ローカルのアーティファクトディレクトリは、`new` または `load` で作成します。
- `.artifact.json` は保存用ブランチにのみ存在し、ワークスペースには置かれません。
- `.artifact.json` は予約名です。アーティファクト内のどの階層であっても、この名前のローカルエントリがあると `save` と `diff` はエラーになります。
- `save` は、ブランチ先端の対象アーティファクトをローカルファイルで置き換えます。
- 保存用ブランチの公開と同期には、通常のGitコマンド（`push`、`fetch`、`rebase`）を使います。

<h2 id="commit-messages">コミットメッセージ</h2>

コミットを作成する操作（`init`、`new`、`save`、`describe`、`delete`）では、`-m` または `-F` を指定できます。

```sh
git artifact save -m "Update auth redesign notes" auth-redesign
git artifact save -m "Update notes" -m "Add benchmark results" auth-redesign
git artifact save -F /path/to/message.txt auth-redesign
```

`-m` を繰り返すと段落が分かれます。`-F` はUTF-8ファイルを読みます（`-F -` は未対応）。メッセージは空にできません。省略すると、`git-artifact:` プレフィックス付きのメッセージが生成されます。
