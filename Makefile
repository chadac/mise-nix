SH_SRCFILES = $(shell git ls-files "bin/*")
SHFMT_BASE_FLAGS = -i 2 -ci
CURRENT_DIR = $(shell pwd)

fmt:
	shfmt -w $(SHFMT_BASE_FLAGS) $(SH_SRCFILES)
.PHONY: fmt

format-check:
	shfmt -d $(SHFMT_BASE_FLAGS) $(SH_SRCFILES)
.PHONY: format-check

lint:
	shellcheck $(SH_SRCFILES)
.PHONY: lint

test:
	docker run -v ${PWD}:/mise/nix --rm nixos/nix /usr/bin/env bash -c 'nix-channel --update && /mise/nix/test.sh'
