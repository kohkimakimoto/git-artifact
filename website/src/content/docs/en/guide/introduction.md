---
title: Introduction
description: What git-artifact is and when it fits.
section: guide
order: 1
---

`git-artifact` stores development artifacts on an orphan Git branch, separate from your application code.

AI-assisted development creates many working materials—notes, plans, prompt logs, analysis reports, and more. Saving them on the same branch as source code risks maintenance issues, such as docs drifting from the implementation. Deleting them makes past decisions hard to recover.

git-artifact stores these materials as **Artifacts** on an orphan `artifacts` branch. You load only what you need into a local `.artifacts/` workspace, edit ordinary files, and save snapshots back through Git history—without checking out the storage branch or touching your source branch index.

## Related projects

The same orphan-branch pattern appears in [git-vault](https://github.com/kohkimakimoto/git-vault), which encrypts secret files instead of storing plain development notes.

## Requirements

- Python 3.11 or later
- Git
- macOS or Linux
