---
title: Working branches
description: Use -b, -n, and -B for pull-request workflows.
section: guide
order: 6
---

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

The same `-b` / `-n` / `-B` options apply to `new`, `save`, `describe`, and `delete`. Prefer names such as `artifacts-update-auth`; Git cannot have both `artifacts` and `artifacts/update-auth`.
