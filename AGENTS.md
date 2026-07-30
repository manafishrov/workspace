# Manafish ROV Workspace

## Purpose

This directory is the coordination root for the Manafish ROV project. It
contains several independent Git repositories. Treat the directory as one
Paseo project, but preserve each child repository's history, branches,
releases, CI, and permissions.

`setup.sh` populates a fresh workspace. Keep its repository list, directory
capitalization, and AM32 remote configuration aligned with the tables below.

## Coordination repository

The root Git repository owns only the workspace documentation and bootstrap
files. Validate root changes with:

```sh
bash -n setup.sh
git diff --check
```

Use Conventional Commits. Do not push root or child repositories without
explicit user authorization.

## Repositories

| Path | Responsibility | Important relationships |
| --- | --- | --- |
| `app/` | Tauri desktop control application | Consumes `@manafishrov/ui`; communicates with `firmware` |
| `ui/` | Published SolidJS component library | Consumed by `app` |
| `firmware/` | Raspberry Pi/NixOS ROV service | Communicates with `app` and `mcu-firmware` |
| `mcu-firmware/` | Raspberry Pi Pico thruster firmware | USB protocol consumed by `firmware` |
| `AM32/` | Manafish-maintained AM32 ESC firmware | Receives DShot commands from `mcu-firmware` |
| `infra/` | Kubernetes and OpenTofu infrastructure | Paired with `infra-secrets` |
| `infra-secrets/` | Private SOPS-encrypted manifests | Sensitive companion to `infra` |

## Required routing

1. Identify every repository affected by the task.
2. Read that repository's `AGENTS.md` completely before changing it.
3. For implementation, use a Paseo-managed worktree workspace created from
   the affected repository and owned by this Manafish ROV Paseo project.
4. Use a separate worktree workspace for each repository in a cross-repository
   task. Use the same task identifier in workspace titles and branch names.
5. Coordinate interface changes explicitly. State the compatibility and
   merge/release order when a task spans repositories.

Planning and read-only investigation may run from this coordination root.
Do not implement in the primary child checkouts unless the user explicitly
requests it.

## Git safety

- This coordination directory is not the Git history for its children.
- Child repositories are ignored by the coordination repository; never remove
  those ignore rules or stage child repository contents.
- From the coordination root, always use `git -C <repository> ...`.
- Before creating worktrees, inspect the source repository and base branch.
- Never overwrite, reset, clean, or switch a primary checkout to prepare a
  task.
- Keep commits and pull requests separate per repository.
- `AM32` is an independent Manafish product fork. Preserve its custom safety
  changes when importing fixes from `am32-firmware/AM32`.
- Never push, merge, tag, release, publish, or deploy without explicit user
  authorization.
- Pushing `ui` may publish a package. Pushing `infra` or `infra-secrets` may
  deploy. Follow each repository's instructions.

## Secrets

- Include `infra-secrets` only when the task explicitly requires it.
- Treat encrypted values as opaque.
- Never decrypt secrets into chat, logs, temporary plaintext files, or agent
  prompts.
- Never expose private keys or credentials.

## Completion

For every changed repository:

1. Run the quality gates in its `AGENTS.md`.
2. Report its branch and concise `git status`.
3. Explain cross-repository ordering or compatibility constraints.
4. Leave all remote operations to explicit user approval.
