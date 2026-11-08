---
title: エージェントスキル
description: AIコーディングエージェント向けの埋め込みSKILL.mdをインストールします。
section: guide
order: 7
---

`git artifact skill` は、アーティファクト、ワークスペースの使い方、推奨エージェントワークフローを説明する埋め込み `SKILL.md` を出力します。内容は実行ファイルに同梱されており、ネットワークアクセスは不要です。

```sh
# スキルを標準出力へ表示
git artifact skill

# デフォルトパスへインストール
git artifact skill -o

# 任意のパスへインストール
git artifact skill -o .claude/skills/git-artifact/SKILL.md
```

パスなしの `-o` は `.agents/skills/git-artifact/SKILL.md` へ書き込みます。既存ファイルには `-f` が必要です。オプションは [skill](/ja/docs/reference/skill) を参照してください。
