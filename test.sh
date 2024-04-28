#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash mise
# shellcheck shell=bash

eval "$(mise activate bash)"

declare -a packages=(
  shellcheck
  shfmt
  python3
  nodejs
  nixpkgs-unstable/shellcheck
  release-23.11/shellcheck
)

mise plugin install --force file://$PWD

for package in "${packages[@]}"; do
  echo "test install: $package"
  mise install nix@$package
done
