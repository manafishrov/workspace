# Manafish ROV workspace

This repository brings the Manafish ROV repositories together as Git
submodules, so the whole project can be worked on from one checkout.

## Setup

```sh
git clone --recurse-submodules https://github.com/manafishrov/workspace.git manafishrov
```

For an existing clone, or after a new submodule is added:

```sh
git submodule update --init
```

## Repositories

| Repository | Responsibility |
| --- | --- |
| [`app/`](https://github.com/manafishrov/app) | Tauri desktop application for controlling the ROV |
| [`ui/`](https://github.com/manafishrov/ui) | Published SolidJS component library used by the app |
| [`firmware/`](https://github.com/manafishrov/firmware) | Raspberry Pi/NixOS service running on the ROV |
| [`mcu-firmware/`](https://github.com/manafishrov/mcu-firmware) | Raspberry Pi Pico thruster firmware |
| [`esc-firmware/`](https://github.com/manafishrov/esc-firmware) | Manafish-maintained AM32 firmware running on the thruster ESCs |
| [`infra/`](https://github.com/manafishrov/infra) | Kubernetes and OpenTofu infrastructure |

Each repository retains its own history, branches, CI, releases, and
`AGENTS.md` instructions.

## Working on a repository

Submodules are checked out at the commit pinned by this repository. To make a
change, start a branch from the repository's latest `main`:

```sh
git -C app fetch origin
git -C app switch -c feat/my-change origin/main
```

Commit, push, and open the pull request from inside the submodule, against
that repository. Renovate keeps the pinned commits in this repository up to
date.

To move every submodule to its latest `main` locally:

```sh
git submodule update --remote
```

## Secrets

The private `infra-secrets` repository is not a submodule. Maintainers who
need it can clone it into the ignored `infra-secrets/` directory, where
`infra`'s `../infra-secrets` references resolve:

```sh
git clone https://github.com/manafishrov/infra-secrets.git
```

Never expose decrypted secrets, credentials, or private keys.

## License

This project is licensed under the GNU Affero General Public License v3.0 or
later. See [LICENSE](LICENSE).
