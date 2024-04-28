#!/usr/bin/env bash

check() {
  (command -v "$1" >/dev/null)
  echo "$?"
}

HAS_NIX=$(check nix)
NIX_FLAGS=(--extra-experimental-features nix-command --extra-experimental-features flakes)
NIX_BUILD_FLAGS=(--no-link --print-out-paths)

# builder that links more consistently
nix_build() {
  local ref=$1
  local destdir=$2

  local output
  if ! output=$(nix "${NIX_FLAGS[@]}" build "${NIX_BUILD_FLAGS[@]}" "$ref"); then
    exit 1
  fi

  local finaldir=""
  while read -r outdir; do
    case $outdir in
      *-bin)
        finaldir="$outdir"
        ;;
    esac
    if [ "$finaldir" = "" ]; then
      finaldir="$outdir"
    fi
  done <<<"$output"

  ln -s "$finaldir" "$destdir"
}

# installs straight from nixpkgs
install_nix() {
  local package=$1
  local destdir=$2

  # delete existing destination
  if [ -e "$destdir" ]; then
    rm -r "$destdir"
  fi

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

  if [ "$HAS_NIX" -gt 0 ]; then
    >&2 echo "nix must be installed to proceed; see https://nixos.org/download/"
    exit 1
  fi

  # have nix build the package to the given directory
  nix_build "$ref" "$destdir"
  exit $?
}
