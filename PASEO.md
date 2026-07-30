# Paseo workflow

Manafish ROV is one Paseo project containing multiple independent Git
repositories. Paseo natively groups repository-specific worktree workspaces
under the existing project.

## Project

- Project ID: the absolute path to the cloned workspace root
- Coordination workspace: the cloned workspace root

List the current workspaces:

```sh
paseo workspace ls
```

## Create an isolated repository workspace

Fetch the repository without changing its checked-out branch:

```sh
git -C app fetch origin
```

Create a worktree workspace owned by the Manafish ROV project:

```sh
workspace_root=$(pwd -P)

paseo workspace create \
  --isolation worktree \
  --path "$workspace_root/app" \
  --project "$workspace_root" \
  --title "TASK: app" \
  --mode branch-off \
  --worktree-slug task-app \
  --new-branch feat/task \
  --base origin/main
```

The command returns a workspace ID. Start an agent in that workspace:

```sh
paseo run \
  --workspace <workspace-id> \
  --title "Implement TASK in app" \
  --label project=manafishrov \
  --label task=TASK \
  "Read AGENTS.md, implement TASK, run the required checks, and do not push."
```

For a cross-repository task, repeat workspace creation for each affected
repository. Use matching task labels and branch-name suffixes. Each repository
still receives its own commit and pull request.

## Existing branches and pull requests

Use `--mode checkout-branch --branch <branch>` for an existing branch.

Use `--mode checkout-pr --pr-number <number>` for a pull request. Add
`--forge <forge>` only when Paseo cannot infer the source forge.

## Archive

Inspect the worktree and ensure all wanted work is committed before archiving:

```sh
git -C <worktree-path> status --short --branch
paseo workspace archive <workspace-id>
```

Archiving a Paseo-owned worktree workspace archives its agents and terminals
and lets Paseo clean up the owned worktree after its final active reference is
gone. The local branch is intentionally retained. After confirming that its
work is merged or disposable, remove it explicitly from the source repository:

```sh
git -C <repository> branch -d <branch>
```

## Working rules

- Use the coordination workspace for planning and cross-repository inspection.
- Use worktree workspaces for implementation.
- Never use a primary checkout as a disposable branch.
- In `AM32`, keep `origin` pointed at the Manafish fork and `upstream` pointed
  at `am32-firmware/AM32`; import upstream changes deliberately.
- Never push, release, publish, or deploy unless the user explicitly asks.
- Keep `infra-secrets` out of ordinary tasks.
