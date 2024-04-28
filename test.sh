#!/usr/bin/env nix-shell
#!nix-shell -i bash -p bash mise
# shellcheck shell=bash

set -e

# use shims since `mise activate` doesn't appear to work in a script
export PATH="$HOME/.local/share/mise/shims:$PATH"
mise plugin install --force file:///mise/nix

mise global nix@shfmt nix@shellcheck nix@python3 nix@python3Packages.pip
mise install

# assert everything is on the PATH
shfmt --version
shellcheck --version
python --version
pip --version
