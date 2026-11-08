---
title: Concepts
description: Artifacts, the storage branch, and the local workspace.
section: guide
order: 4
---

| Term | Meaning |
| --- | --- |
| Artifact | A directory of related working materials plus tool-managed `.artifact.json` (the directory name is the Artifact name) |
| Storage branch | Orphan branch holding every Artifact (default: `artifacts`) |
| Local workspace | `.artifacts/` under the current Git worktree root |

## Rules that matter day to day

- `new` creates an Artifact; `save` updates an existing one.
- Local Artifact directories are created by `new` or `load`.
- `.artifact.json` stays on the storage branch; the workspace never contains it.
- `.artifact.json` is reserved: `save` and `diff` reject local entries with this name anywhere inside an Artifact.
- `save` replaces that Artifact on the branch tip with the local files.
- Publish and sync the storage branch with ordinary Git (`push`, `fetch`, `rebase`).

## Commit messages

Operations that create commits (`init`, `new`, `save`, `describe`, `delete`) accept `-m` or `-F`:

```sh
git artifact save -m "Update auth redesign notes" auth-redesign
git artifact save -m "Update notes" -m "Add benchmark results" auth-redesign
git artifact save -F /path/to/message.txt auth-redesign
```

Repeat `-m` to separate paragraphs. `-F` reads a UTF-8 file (`-F -` is unsupported). Messages cannot be empty. When omitted, a message with a `git-artifact:` prefix is generated.
