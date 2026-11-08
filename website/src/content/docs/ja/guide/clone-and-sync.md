---
title: クローンと同期
description: artifactsブランチを取得し、別マシンでアーティファクトを読み込みます。
section: guide
order: 5
---

リモート操作には通常のGitコマンドを使います。アプリケーションブランチをクローンしたあと、リモートからローカルのartifactsブランチを作成します。

```sh
# アプリケーションブランチをクローンしたあと、リモートの参照を取得
git fetch origin

# リモートブランチを追跡するローカルartifactsブランチを作成
git branch --track artifacts origin/artifacts

# 必要なアーティファクトをワークスペースへ読み込む
git artifact load auth-redesign
```

ローカルの `artifacts` がすでに存在する場合は、ブランチ作成を省略できます。既存のローカルartifactsブランチをリモートからfast-forwardするには:

```sh
git fetch origin artifacts:artifacts
```

通常の `git fetch origin` は `origin/artifacts` を更新し、ローカルの `artifacts` は更新しません。他の更新と競合する可能性がある公開では、pushする前にリモートの最新へrebaseしてください（[クイックスタート](/ja/docs/guide/quick-start)を参照）。
