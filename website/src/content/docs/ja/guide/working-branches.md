---
title: 作業用ブランチ
description: プルリクエスト向けに -b、-n、-B を使います。
section: guide
order: 6
---

`-b` は操作対象のローカルブランチ名です。`init` はそのブランチを作成し、既存名は拒否します。他のコマンドは既存ブランチが必要ですが、対応している場合は `-n` で新規作成できます。

```sh
# リモート追跡ブランチ（origin/artifactsを含む）を更新
git fetch origin

# 取得したartifacts先端から作業用ブランチを作り、変更を保存
git artifact save -b artifacts-update-auth -n -B origin/artifacts auth-redesign

# 既存の作業用ブランチへ別のコミットを追加
git artifact save -b artifacts-update-auth auth-redesign

# プルリクエスト用に作業用ブランチを公開
git push origin artifacts-update-auth
```

ホスティングサービス上で、`artifacts-update-auth` から `artifacts` へのプルリクエストを作成します。`-B` を省略すると、新しいブランチはローカルの `artifacts` から始まります。`-n` には明示的な `-b` が必要で、そのブランチが既に存在すると失敗します。`-B` には `-n` が必要です。

同じ `-b` / `-n` / `-B` は `new`、`save`、`describe`、`delete` に使えます。`artifacts-update-auth` のような名前を推奨します。Gitでは `artifacts` と `artifacts/update-auth` を同時に持てません。
