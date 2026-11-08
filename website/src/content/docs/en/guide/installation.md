---
title: Installation
description: Install git-artifact with Homebrew or manually.
section: guide
order: 2
---

## Homebrew

```sh
brew install kohkimakimoto/tap/git-artifact
```

## Manual installation

Place [`bin/git-artifact`](https://github.com/kohkimakimoto/git-artifact/blob/main/bin/git-artifact) somewhere on your `PATH` and make it executable.

```sh
git artifact version
```

git-artifact is an external Git subcommand: Git allows an executable named `git-xxx` on your PATH to be invoked as `git xxx`. The executable is a Python script that uses only the standard library and the system Git command.
