---
title: Quick start
description: Create, save, and publish an Artifact in a few steps.
section: guide
order: 3
---

This example creates an Artifact for auth redesign notes and publishes the storage branch.

## Before you start

- [Install git-artifact](/docs/guide/installation) and check its [requirements](/docs/guide/introduction#requirements).
- Run the commands from the root of your application repository.
- These steps create a new local `artifacts` branch. If you already have one, follow [Clone and sync](/docs/guide/clone-and-sync).
- The publish command assumes a Git remote named `origin` is configured.

## Initialize and create

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

`init` creates an orphan `artifacts` branch without switching `HEAD`. `new` creates the Artifact; `save` updates an existing one.

## Later publishes

Rebase onto the remote tip before pushing updates that may race with others:

```sh
git artifact save auth-redesign
git fetch origin
git switch artifacts
git rebase origin/artifacts
git push origin artifacts
git switch -
```
