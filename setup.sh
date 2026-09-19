#!/usr/bin/env bash

set -euo pipefail

readonly github_org="git@github.com:manafishrov"
include_secrets=false

if [[ ${1:-} == "--with-secrets" ]]; then
  include_secrets=true
elif [[ $# -ne 0 ]]; then
  echo "Usage: $0 [--with-secrets]" >&2
  exit 2
fi

# Stop before cloning anything if an old checkout (or symlink) remains.
if [[ -e AM32 || -L AM32 ]]; then
  echo "Legacy AM32 path found; setup will not create a duplicate esc-firmware checkout." >&2
  echo "If esc-firmware also exists, reconcile both checkouts manually. See README.md: Upgrade an existing workspace." >&2
  exit 1
fi

clone_repository() {
  local directory=$1
  local repository=$2

  if [[ -d "$directory/.git" ]]; then
    echo "$directory already exists; skipping"
    return
  fi

  if [[ -e "$directory" ]]; then
    echo "$directory exists but is not a Git checkout" >&2
    exit 1
  fi

  git clone "$github_org/$repository.git" "$directory"
}

clone_repository app app
clone_repository ui ui
clone_repository firmware firmware
clone_repository mcu-firmware mcu-firmware
clone_repository esc-firmware esc-firmware
clone_repository infra infra

if [[ $include_secrets == true ]]; then
  clone_repository infra-secrets infra-secrets
fi

git -C esc-firmware remote set-url origin "$github_org/esc-firmware.git"
if git -C esc-firmware remote get-url upstream >/dev/null 2>&1; then
  git -C esc-firmware remote set-url upstream https://github.com/am32-firmware/AM32.git
else
  git -C esc-firmware remote add upstream https://github.com/am32-firmware/AM32.git
fi
git -C esc-firmware remote set-url --push upstream DISABLED

echo "Manafish ROV workspace is ready."
