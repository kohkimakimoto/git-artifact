---
title: クイックスタート
description: アーティファクトの作成、保存、公開を数ステップで行います。
section: guide
order: 3
---

この例では、認証再設計のメモ用アーティファクトを作成し、保存用ブランチを公開します。

<h2 id="before-you-start">始める前に</h2>

- [git-artifactをインストール](/ja/docs/guide/installation)し、[動作要件](/ja/docs/guide/introduction#requirements)を確認してください。
- コマンドはアプリケーションリポジトリのルートで実行します。
- これらの手順は、新しいローカル `artifacts` ブランチを作成します。すでに存在する場合は、[クローンと同期](/ja/docs/guide/clone-and-sync)を参照してください。
- 公開コマンドは、`origin` という名前のGitリモートが設定されていることを前提とします。

<h2 id="initialize-and-create">初期化と作成</h2>

```sh
# 孤立したartifactsブランチを作成
git artifact init

# メタデータと空のローカルディレクトリを作成
git artifact new auth-redesign -d "Auth redesign notes"

# ファイルを追加（.artifact.jsonはワークスペースの外でツールが管理）
printf '%s\n' '# Auth redesign' > .artifacts/auth-redesign/design.md

# ファイルを保存し、初めて公開
git artifact save auth-redesign
git push origin artifacts
```

`init` は `HEAD` を切り替えずに孤立した `artifacts` ブランチを作成します。`new` はアーティファクトを作成し、`save` は既存のものを更新します。

<h2 id="later-publishes">2回目以降の公開</h2>

他の更新と競合する可能性がある場合は、pushする前にリモートの最新コミットへrebaseします。

```sh
git artifact save auth-redesign
git fetch origin
git switch artifacts
git rebase origin/artifacts
git push origin artifacts
git switch -
```
