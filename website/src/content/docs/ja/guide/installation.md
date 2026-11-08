---
title: インストール
description: Homebrewまたは手動でgit-artifactをインストールします。
section: guide
order: 2
---

<h2 id="homebrew">Homebrew</h2>

```sh
brew install kohkimakimoto/tap/git-artifact
```

<h2 id="manual-installation">手動インストール</h2>

[`bin/git-artifact`](https://github.com/kohkimakimoto/git-artifact/blob/main/bin/git-artifact) を `PATH` 上のディレクトリに配置し、実行権限を付けます。

```sh
git artifact version
```

git-artifactはGitの外部サブコマンドです。`PATH` 上にある `git-xxx` という実行ファイルを、`git xxx` として呼び出せます。この実行ファイルは、標準ライブラリとシステムのGitコマンドだけを使うPythonスクリプトです。
