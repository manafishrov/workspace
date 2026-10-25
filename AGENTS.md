# Manafish ROV Workspace

## Purpose

This repository pins the Manafish ROV repositories as Git submodules so the
whole project can be opened, searched, and changed from one checkout. It is not
a monorepo: each submodule keeps its own history, branches, CI, releases, and
pull requests.

If the submodule directories are empty, run:

```sh
git submodule update --init
```

## Repositories

| Path | Responsibility | Important relationships |
| --- | --- | --- |
| `app/` | Tauri desktop control application | Consumes `@manafishrov/ui`; communicates with `firmware` |
| `ui/` | Published SolidJS component library | Consumed by `app` |
| `firmware/` | Raspberry Pi/NixOS ROV service | Communicates with `app` and `mcu-firmware` |
| `mcu-firmware/` | Raspberry Pi Pico thruster firmware | USB protocol consumed by `firmware` |
| `esc-firmware/` | Manafish-maintained AM32 ESC firmware | Receives DShot commands from `mcu-firmware` |
| `infra/` | Kubernetes and OpenTofu infrastructure | Secrets live in the separate private `infra-secrets` repository |

## Working in a repository

1. Identify every repository affected by the task.
2. Read that repository's `AGENTS.md` completely before changing it.
3. Submodules are checked out at a pinned commit with a detached HEAD. Before
   changing one, start a branch from its latest `main`:

   ```sh
   git -C <repository> fetch origin
   git -C <repository> switch -c <branch> origin/main
   ```

4. Commit, push, and open pull requests from inside the submodule. Each
   repository gets its own commits and pull request against its own `main`.
5. For a cross-repository task, use the same branch name in every affected
   repository. State the compatibility and merge/release order explicitly.

## Workspace repository

The workspace repository owns only this documentation, `.gitmodules`, and the
pinned submodule commits. Renovate updates the pinned commits, so do not
commit submodule pointer changes as part of feature work unless asked.

Validate workspace changes with:

```sh
git diff --check
git submodule status
```

Use Conventional Commits.

## Git safety

- Never push, merge, tag, release, publish, or deploy without explicit user
  authorization.
- Pushing `ui` may publish a package. Pushing `infra` may deploy. Follow each
  repository's instructions.
- Never discard, reset, or clean work in a submodule you did not create.
- `esc-firmware` is an independent Manafish AM32 product fork. Preserve its
  custom safety changes when importing fixes from `am32-firmware/AM32`. Add
  the upstream as a fetch-only remote when needed:

  ```sh
  git -C esc-firmware remote add upstream https://github.com/am32-firmware/AM32.git
  git -C esc-firmware remote set-url --push upstream DISABLED
  ```

## Secrets

`infra-secrets` is not part of this workspace. Include it only when a task
explicitly requires it. Treat encrypted values as opaque and never decrypt
secrets into chat, logs, temporary plaintext files, or prompts.

## Completion

For every changed repository:

1. Run the quality gates in its `AGENTS.md`.
2. Report its branch and concise `git status`.
3. Explain cross-repository ordering or compatibility constraints.
4. Leave all remote operations to explicit user approval.
