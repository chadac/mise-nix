# mise-nix

[Nix](https://nixos.org) plugin for the [mise](https://mise.jdx.dev/) version manager.

Enables installing packages via `nix` rather than using the regular
`mise` builders.

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
separate branch or alternative version, use

```bash
mise install nix@github:NixOS/nixpkgs/nixpkgs-stable#python310
```

NOTE: Gotta figure out how to make the above work
