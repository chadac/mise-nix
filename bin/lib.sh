#!/usr/bin/env bash

check() {
  (command -v $1 > /dev/null)
  echo "$?"
}

HAS_NIX=$(check nix)
NIX_ERROR=0

# installs straight from nixpkgs
install_nixpkgs() {
  local package=$1
  local destdir=$2

  local ref=""
  case $package in
    *:*)
      # this is an absolute reference
      ref=$package
      ;;
    *)
      ref="github:NixOS/nixpkgs/nixpkgs-unstable#${package}"
      ;;
  esac

  if [ ! HAS_NIX ]; then
    >&2 echo "nix must be installed to proceed; see https://nixos.org/download/"
    exit 1
  fi

  # delete existing directory
  rm -r $destdir

  # have nix build the package to the given directory
  nix --extra-experimental-features nix-command --extra-experimental-features flakes build ${ref} -o $destdir

  exit $?
}

install_nix() {
  local package=$1
  local destdir=$2

  install_nixpkgs $package $destdir
}