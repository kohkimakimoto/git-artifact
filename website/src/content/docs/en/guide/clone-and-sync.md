---
title: Clone and sync
description: Fetch the artifacts branch and load Artifacts on another machine.
section: guide
order: 5
---

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

A plain `git fetch origin` normally updates `origin/artifacts`, not local `artifacts`. When publishing updates that may race with others, rebase onto the remote tip before pushing (see [Quick start](/docs/guide/quick-start)).
