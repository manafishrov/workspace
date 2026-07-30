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
clone_repository AM32 AM32
clone_repository infra infra

if [[ $include_secrets == true ]]; then
  clone_repository infra-secrets infra-secrets
fi

if git -C AM32 remote get-url upstream >/dev/null 2>&1; then
  git -C AM32 remote set-url upstream https://github.com/am32-firmware/AM32.git
else
  git -C AM32 remote add upstream https://github.com/am32-firmware/AM32.git
fi
git -C AM32 remote set-url --push upstream DISABLED

echo "Manafish ROV workspace is ready."
