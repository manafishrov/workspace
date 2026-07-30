# Manafish ROV workspace

This directory is the coordination root for the Manafish ROV project. It is
one Paseo project containing several independent Git repositories.

## Setup

Clone the workspace, then populate its child repositories:

```sh
git clone git@github.com:manafishrov/workspace.git manafishrov
cd manafishrov
./setup.sh
```

Maintainers with access to the private secrets repository can include it with:

```sh
./setup.sh --with-secrets
```

The setup script is idempotent: existing Git checkouts are preserved. It also
configures the Manafish AM32 fork with the community repository as a
fetch-only `upstream` remote.

## Repositories

| Repository | Responsibility |
| --- | --- |
| `app/` | Tauri desktop application for controlling the ROV |
| `ui/` | Published SolidJS component library used by the app |
| `firmware/` | Raspberry Pi/NixOS service running on the ROV |
| `mcu-firmware/` | Raspberry Pi Pico thruster firmware |
| `AM32/` | Manafish-maintained AM32 firmware running on the thruster ESCs |
| `infra/` | Kubernetes and OpenTofu infrastructure |
| `infra-secrets/` | Private SOPS-encrypted infrastructure secrets |

Each repository retains its own history, branches, CI, releases, and
`AGENTS.md` instructions. This directory is not a monorepo, and the child
repositories are not submodules.

## Using Paseo

Open the `manafishrov` project in Paseo and work from its coordination
workspace. Describe the outcome you want; the coordinating agent will identify
the affected repositories and create native Paseo-managed worktree workspaces
for implementation.

For a task affecting one repository:

> Implement configurable thruster dead zones in `mcu-firmware`. Create an
> isolated worktree, run the required checks, and do not push.

For a cross-repository task:

> Add a new MCU telemetry message consumed by `firmware`. Create separate
> worktrees for both repositories, coordinate the protocol change, and do not
> push.

Paseo groups the resulting workspaces under the same project:

```text
manafishrov
├── coordination workspace
├── Telemetry: mcu-firmware
└── Telemetry: firmware
```

Each repository still receives its own branch, commits, and pull request.

## Workflow

1. Use the coordination workspace for planning and cross-repository
   investigation.
2. Use a Paseo-managed worktree workspace for implementation.
3. Read the affected repository's `AGENTS.md` before changing it.
4. Run that repository's required quality checks.
5. Review the local branch and diff.
6. Push, publish, release, deploy, or merge only after explicit approval.

The detailed CLI workflow is documented in [PASEO.md](PASEO.md). Agent routing
and safety rules are documented in [AGENTS.md](AGENTS.md).

## Useful commands

List active Paseo workspaces:

```sh
paseo workspace ls
```

Inspect all primary repository checkouts:

```sh
for repo in app ui firmware mcu-firmware AM32 infra infra-secrets; do
  git -C "$repo" status --short --branch
done
```

The primary checkouts are for coordination and inspection. Feature
implementation should normally happen in isolated worktrees.

## Secrets

`infra-secrets` is private and must only be included when a task explicitly
requires it. Treat encrypted values as opaque and never expose decrypted
secrets, credentials, or private keys in prompts, logs, or temporary files.

## License

This project is licensed under the GNU Affero General Public License v3.0 or
later. See [LICENSE](LICENSE).
