# git-artifact

<p align="center">
  <img alt="git-artifact logo" src="./assets/logo.svg">
</p>

<p align="center">Manage development artifacts on a dedicated orphan Git branch, separate from your application code.</p>

AI-assisted development often produces notes, design decisions, plans, benchmarks, and related files. Keeping them on the same branch as source code risks treating stale documents as current specifications. Deleting them makes past decisions hard to recover.

`git artifact` stores those files as named **Artifacts** on an orphan `artifacts` branch. You load only what you need into a local `.artifacts/` workspace, edit ordinary files, and save snapshots back through Git history—without checking out the storage branch or touching your source branch index.

## Requirements

git-artifact is an external Git subcommand: an executable named `git-artifact` on your `PATH` is invoked as `git artifact`. The executable is a Python script that uses only the standard library and the system Git command.

- Python 3.11 or later
- Git
- macOS or Linux

## Installation

### Homebrew

```sh
brew install kohkimakimoto/tap/git-artifact
```

### Manual installation

Place [`bin/git-artifact`](bin/git-artifact) somewhere on your `PATH` and make it executable.

```sh
git artifact version
```

## Quick start

```sh
# Create the orphan artifacts branch
git artifact init

# Create metadata and an empty local directory
git artifact new auth-redesign -d "Auth redesign notes"

# Add files (.artifact.json is managed by the tool, outside the workspace)
printf '%s\n' '# Auth redesign' > .artifacts/auth-redesign/design.md

# Save files and publish for the first time
git artifact save auth-redesign
git push origin artifacts
```

Later publishes should rebase onto the remote tip before pushing:

```sh
git artifact save auth-redesign
git fetch origin
git switch artifacts
git rebase origin/artifacts
git push origin artifacts
git switch -
```

## Concepts

| Term | Meaning |
|---|---|
| Artifact | A named directory of related files plus tool-managed `.artifact.json` |
| Storage branch | Orphan branch holding every Artifact (default: `artifacts`) |
| Local workspace | `.artifacts/` under the current Git worktree root |

Rules that matter day to day:

- `new` creates an Artifact; `save` updates an existing one.
- Local Artifact directories are created by `new` or `load`.
- `.artifact.json` stays on the storage branch; the workspace never contains it.
- `.artifact.json` is reserved: `save` and `diff` reject local entries with this name anywhere inside an Artifact.
- `save` replaces that Artifact on the branch tip with the local files.
- Publish and sync the storage branch with ordinary Git (`push`, `fetch`, `rebase`).

## Commit messages

Operations that create commits (`init`, `new`, `save`, `describe`, `delete`) accept `-m` or `-F`:

```sh
# Set the commit message with -m
git artifact save -m "Update auth redesign notes" auth-redesign

# Repeat -m for separate paragraphs
git artifact save -m "Update notes" -m "Add benchmark results" auth-redesign

# Read the commit message from a file
git artifact save -F /path/to/message.txt auth-redesign
```

Repeat `-m` to separate paragraphs. `-F` reads a UTF-8 file (`-F -` is unsupported). Messages cannot be empty.

When omitted, a message with a `git-artifact:` prefix is generated. Git uses the usual `user.name` / `user.email` author configuration.

## Working branches and pull requests

`-b` names the local branch to operate on. `init` creates that branch and rejects an existing name. Other commands require an existing branch, unless you pass `-n` (where supported) to create one.

```sh
# Update remote-tracking branches (including origin/artifacts)
git fetch origin

# Create a working branch from the fetched artifacts tip and save a change
git artifact save -b artifacts-update-auth -n -B origin/artifacts auth-redesign

# Add another commit to the existing working branch
git artifact save -b artifacts-update-auth auth-redesign

# Publish the working branch for a pull request
git push origin artifacts-update-auth
```

Create a pull request from `artifacts-update-auth` to `artifacts` using your hosting service. If `-B` is omitted, new branches start from the local `artifacts` branch. `-n` requires an explicit `-b` and fails if that branch already exists. `-B` requires `-n`.

The same `-b` / `-n` / `-B` options apply to `new`, `save`, `describe`, and `delete`. Creation is committed only after the operation succeeds. A storage branch checked out in any worktree cannot be updated. Prefer names such as `artifacts-update-auth`; Git cannot have both `artifacts` and `artifacts/update-auth`.

## Cloning and synchronization

Remote operations use ordinary Git commands. After cloning the application branch, create a local artifacts branch from the remote:

```sh
# Fetch remote refs after cloning the application branch
git fetch origin

# Create a local artifacts branch tracking the remote branch
git branch --track artifacts origin/artifacts

# Load the Artifact you need into the workspace
git artifact load auth-redesign
```

Skip the branch creation if local `artifacts` already exists. To fast-forward an existing local artifacts branch from the remote:

```sh
git fetch origin artifacts:artifacts
```

A plain `git fetch origin` normally updates `origin/artifacts`, not local `artifacts`. When publishing updates that may race with others, rebase onto the remote tip before pushing (see [Quick start](#quick-start)).

## Command reference

Options follow the operation: `git artifact save auth-redesign`, or `git artifact list --filter auth`.

Artifact names are single directory names (no `/` or `\`). Use `--` before names beginning with `-`. For `load`, `save`, and `diff`, pass one or more names or `-a`, not both. When `-m` and `-F` are omitted, a message with a `git-artifact:` prefix is generated.

### `init`

```sh
git artifact init [options]
```

Create a local orphan artifacts branch (default name `artifacts`) with a root `README.md` describing the branch. The branch must not already exist. Does not switch `HEAD` or rewrite application history.

| Option | Purpose |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to create (default: `artifacts`). |
| `-m`, `--message TEXT` | Commit message; repeat for paragraphs (not with `-F`). |
| `-F`, `--message-file PATH` | Read a UTF-8 commit message file (not with `-m`). |
| `-h`, `--help` | Show help. |

### `list`

```sh
git artifact list [options]
```

List Artifacts on the selected branch. Human output is a headered table of `name`, `description`, `created_at`, and `updated_at` (timestamps in the local timezone). `--json` prints the same fields (timestamps in UTC with `Z`). Local workspace contents do not affect the list.

| Option | Purpose |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to read (default: `artifacts`). |
| `--sort FIELD` | Sort by `name`, `created_at`, or `updated_at` (default: `name`). |
| `--order ORDER` | `asc` or `desc` (default: `asc`). |
| `--filter TEXT` | Keep Artifacts whose name or description contains `TEXT` (case-sensitive substring). |
| `--json` | Print JSON. |
| `-h`, `--help` | Show help. |

```sh
git artifact list
git artifact list --sort updated_at --order desc
git artifact list --filter auth --json
```

### `new`

```sh
git artifact new [options] NAME
```

Create a new Artifact on the storage branch and an empty local directory at `.artifacts/NAME/`. The storage branch must not already contain `NAME`, and the local directory must not already exist. Writes only `.artifact.json` on the branch (`description`, `created_at`, `updated_at`); the workspace never receives `.artifact.json`.

| Option | Purpose |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to update (default: `artifacts`). |
| `-n`, `--new-branch` | Create the named `-b` branch; fail if it already exists. |
| `-B`, `--base REF` | Creation base (default: `artifacts`); requires `-n`. |
| `-d`, `--description TEXT` | Initial description (default: empty). |
| `-m`, `--message TEXT` | Commit message; repeat for paragraphs (not with `-F`). |
| `-F`, `--message-file PATH` | Read a UTF-8 commit message file (not with `-m`). |
| `-h`, `--help` | Show help. |

```sh
git artifact new auth-redesign -d "Auth redesign notes"
# edit files under .artifacts/auth-redesign/
git artifact save auth-redesign
```

### `load`

```sh
git artifact load [options] NAME [NAME ...]
git artifact load [options] -a
```

Expand Artifact files into `.artifacts/NAME/`. Does not write `.artifact.json`. Without `-f`, an existing local directory is rejected. With `-f`, the local directory is replaced (unsaved local changes are discarded).

| Option | Purpose |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to read (default: `artifacts`). |
| `-a`, `--all` | Load every Artifact on the selected branch and revision; cannot be combined with explicit names. |
| `-f`, `--force` | Overwrite existing local Artifact directories. |
| `--revision REV` | Load from a commit reachable from the selected branch tip (default: tip). |
| `-h`, `--help` | Show help. |

`--revision` must resolve to a commit that is the selected branch tip or one of its ancestors. Existence checks and file reads use that commit.

### `save`

```sh
git artifact save [options] NAME [NAME ...]
git artifact save [options] -a
```

Replace existing Artifacts on the storage branch with the local workspace snapshots and create a commit. The named Artifact must already exist on the branch, and the local directory must exist. Updates `updated_at` in `.artifact.json`; leaves `description` and `created_at` unchanged. Local files named `.artifact.json` anywhere under the Artifact are rejected. Other Artifacts on the branch are left alone. Local directories that are absent are not deleted from the branch.

| Option | Purpose |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to update (default: `artifacts`). |
| `-a`, `--all` | Save every Artifact present in the local workspace; cannot be combined with explicit names. |
| `-n`, `--new-branch` | Create the named `-b` branch; fail if it already exists. |
| `-B`, `--base REF` | Creation base (default: `artifacts`); requires `-n`. |
| `-m`, `--message TEXT` | Commit message; repeat for paragraphs (not with `-F`). |
| `-F`, `--message-file PATH` | Read a UTF-8 commit message file (not with `-m`). |
| `-h`, `--help` | Show help. |

After syncing others' updates, use `load -f` before editing if you need their content. Files removed locally are removed from the branch tip on `save`.

### `describe`

```sh
git artifact describe [options] NAME TEXT
git artifact describe [options] NAME --clear
```

Update an Artifact's `description` on the storage branch without changing its files. `TEXT` and `--clear` are exclusive; an empty `TEXT` is rejected (use `--clear`). Updates `updated_at` and leaves `created_at` unchanged. Does not modify the local workspace.

| Option | Purpose |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to update (default: `artifacts`). |
| `-n`, `--new-branch` | Create the named `-b` branch; fail if it already exists. |
| `-B`, `--base REF` | Creation base (default: `artifacts`); requires `-n`. |
| `--clear` | Set description to an empty string. |
| `-m`, `--message TEXT` | Commit message; repeat for paragraphs (not with `-F`). |
| `-F`, `--message-file PATH` | Read a UTF-8 commit message file (not with `-m`). |
| `-h`, `--help` | Show help. |

```sh
git artifact describe auth-redesign "Updated summary"
git artifact describe auth-redesign --clear
```

### `delete`

```sh
git artifact delete [options] NAME [NAME ...]
```

Remove the named Artifact directories from the storage branch tip in one commit. Other Artifacts are unchanged. The local workspace is not modified. Older commits remain in history. There is no `-a`.

| Option | Purpose |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to update (default: `artifacts`). |
| `-n`, `--new-branch` | Create the named `-b` branch; fail if it already exists. |
| `-B`, `--base REF` | Creation base (default: `artifacts`); requires `-n`. |
| `-m`, `--message TEXT` | Commit message; repeat for paragraphs (not with `-F`). |
| `-F`, `--message-file PATH` | Read a UTF-8 commit message file (not with `-m`). |
| `-h`, `--help` | Show help. |

```sh
git artifact delete old-spike
rm -rf .artifacts/old-spike   # local cleanup only; storage is unchanged
```

### `diff`

```sh
git artifact diff [options] NAME [NAME ...]
git artifact diff [options] -a
```

Compare local Artifact files to the selected branch tip. Prints unified diffs (`a/` is storage, `b/` is local), including new/deleted file headers and mode changes. `.artifact.json` is not compared; a local entry with that name is an error. Missing local directories are reported as absent. Exit status is `1` when any selected Artifact differs, otherwise `0`. Usage errors use exit status `2`.

| Option | Purpose |
| --- | --- |
| `-b`, `--branch NAME` | Local branch to compare (default: `artifacts`). |
| `-a`, `--all` | Diff every Artifact present in the local workspace; cannot be combined with explicit names. |
| `-h`, `--help` | Show help. |

### `skill`

```sh
# Print the skill to stdout
git artifact skill

# Install it at the default path (.agents/skills/git-artifact/SKILL.md)
git artifact skill -o

# Install it at a custom path
git artifact skill -o .claude/skills/git-artifact/SKILL.md
```

Print agent skill content (`SKILL.md`) to stdout. The skill covers Artifacts, workspace usage, and recommended agent workflow. Content is embedded in the executable; no network access is required.

Use `-o` without a path to write `.agents/skills/git-artifact/SKILL.md`, or pass another file path. Relative paths start from the current directory; missing parents are created. File mode writes the skill to the file and a confirmation to stderr. Existing files need `-f`; symlink targets are always rejected.

| Option | Purpose |
| --- | --- |
| `-o`, `--output [PATH]` | Write the skill to a file; an omitted path defaults to `.agents/skills/git-artifact/SKILL.md`. Without this option, print to stdout. |
| `-f`, `--force` | Overwrite an existing output file; requires `-o`. |
| `-h`, `--help` | Show help. |

### `version`

```sh
git artifact version
```

Print the version.

| Option | Purpose |
| --- | --- |
| `-h`, `--help` | Show help. |

## Storage layout

Each Artifact is a top-level directory on the storage branch. A `README.md` at that root explains that the branch is managed by git-artifact:

```text
README.md
auth-redesign/
  .artifact.json
  design.md
  plan.md
cache-improvement/
  .artifact.json
  notes.md
```

`.artifact.json` holds `description`, `created_at`, and `updated_at` (UTC, `YYYY-MM-DDTHH:MM:SSZ`). The Artifact name is the directory name and is not duplicated inside the JSON.

## Testing

```sh
./tests/run.sh
```

Each script in `tests/cases/` exercises one scenario by running `git artifact` and ordinary Git commands. To run just one scenario:

```sh
bash tests/cases/01-roundtrip.sh
```

## Related projects

- [git-vault](https://github.com/kohkimakimoto/git-vault) — Store encrypted files on a dedicated orphan Git branch. Same pattern as git-artifact: an external Git subcommand that keeps data on an independent orphan branch, separate from application code.

## License

The MIT License (MIT)

Copyright (c) Kohki Makimoto \<kohki.makimoto@gmail.com\>
