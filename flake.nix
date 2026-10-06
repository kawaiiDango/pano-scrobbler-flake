{
  description = "Pano Scrobbler Flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      tag = "447";
      version = "4.47";
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);

      archMap = {
        "x86_64-linux" = "x64";
        "aarch64-linux" = "arm64";
      };

      # Update these hashes using 'nix store prefetch-file <url>'
      hashes = {
        "x86_64-linux" = "sha256-PtI4fmw0kLUpynaSk+jD4LC0tsaMm8HlPkKpqjqSXHM=";
        "aarch64-linux" = "sha256-Dxegbvxt5wgQ4pUOvRoGdXS1dq+USHlkd1CfaneEAoA=";
      };
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        {
          default = pkgs.callPackage ./pano-scrobbler-bin/package.nix {
            inherit tag;
            inherit version;
            arch = archMap.${system};
            hash = hashes.${system};
          };
        }
      );
    };
}
