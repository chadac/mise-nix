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
    # otherwise just grab whatever we see first
    if [ "$finaldir" = "" ]; then
      if [ -d "$outdir/bin" ]; then
        finaldir="$outdir"
      fi
    fi
  done <<<"$output"

  if [ "$finaldir" = "" ]; then
    >&2 echo "invalid package: could not find output path with '/bin' directory; is this a tool?"
    exit 1
  fi

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

  local branch
  local pkg
  case $package in
    */*)
      # this is an absolute reference
      branch=${package%%"/"*}
      pkg=${package#*"/"}
      ;;
    *)
      branch="nixpkgs-unstable"
      pkg=$package
      ;;
  esac

  # TODO: support generalized references
  local ref
  case $branch in
    *)
      ref="github:NixOS/nixpkgs/${branch}#${pkg}"
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
