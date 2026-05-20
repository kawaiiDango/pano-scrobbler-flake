# pano-scrobbler-flake

Prebuilt binaries of [Pano Scrobbler](https://github.com/kawaiiDango/pano-scrobbler), built from source on Github Actions.

Report issues with this to the main repo: https://github.com/kawaiiDango/pano-scrobbler/issues

Supported systems: `x86_64-linux`, `aarch64-linux`

---

## Installation

#### Home Manager
```nix
# flake.nix inputs:
pano-scrobbler-flake.url = "github:kawaiiDango/pano-scrobbler-flake";

# home.nix:
home.packages = [ inputs.pano-scrobbler-flake.packages.${pkgs.system}.default ];
```

#### Standalone (nix profile)
```sh
nix profile add github:kawaiiDango/pano-scrobbler-flake
```

#### NixOS configuration
```nix
# flake.nix inputs:
pano-scrobbler-flake.url = "github:kawaiiDango/pano-scrobbler-flake";

# configuration.nix / nixosConfigurations:
environment.systemPackages = [ inputs.pano-scrobbler-flake.packages.${system}.default ];
```