# mise-nix

[Nix](https://nixos.org) plugin for the [mise](https://mise.jdx.dev/) version manager.

Enables installing packages via `nix` rather than using the regular
`mise` plugins.

Useful for those on Nix systems that still want to use `mise` and its
associated features. It's also a bit less verbose than the generic
`shell.nix` or `flake.nix` specification and allows mixing multiple
versions of `nixpkgs` when needed.

## Install

```bash
mise plugin install git@github.com/chadac/mise-nix
```

## Usage

Specify a package that you'd like to install from `nixpkgs` using:

```bash
mise install nix@python310
```

By default it sources package versions from
`github:NixOS/nixpkgs/nixpkgs-unstable`; if you'd prefer to specify a
separate git ref (as a branch, commit, tag, etc) or alternative
version, use

```bash
mise install nix@release-23.11/python310
```

## TODOs

* support generic flake references
