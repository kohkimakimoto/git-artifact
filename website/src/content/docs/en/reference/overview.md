---
title: Overview
description: Conventions shared by every git artifact command.
section: reference
order: 1
---

Options follow the operation: `git artifact save auth-redesign`, or `git artifact list --filter auth`.

Artifact names are single directory names (no `/` or `\`). Use `--` before names beginning with `-`. For `load`, `save`, and `diff`, pass one or more names or `-a`, not both. When `-m` and `-F` are omitted, a message with a `git-artifact:` prefix is generated.

## Common options

| Option | Purpose |
| --- | --- |
| `-b`, `--branch NAME` | Local artifacts branch (default: `artifacts`). |
| `-n`, `--new-branch` | Create the named `-b` branch; fail if it already exists. |
| `-B`, `--base REF` | Creation base (default: `artifacts`); requires `-n`. |
| `-m`, `--message TEXT` | Commit message; repeat for paragraphs (not with `-F`). |
| `-F`, `--message-file PATH` | Read a UTF-8 commit message file (not with `-m`). |
| `-h`, `--help` | Show help. |

## Exit codes

| Code | Meaning |
| --- | --- |
| 0 | Success (`diff`: no differences) |
| 1 | Runtime error, or `diff` found differences |
| 2 | Usage error |
| 3 | Concurrent branch update rejected |
