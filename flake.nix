{
  description = "Pano Scrobbler Flake";

  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      tag = "440";
      version = "4.40";
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
        "x86_64-linux" = "sha256-ZVytPuicLwUDYH6XigLGRK6/CJanzufobnAB5/sz45s=";
        "aarch64-linux" = "sha256-qNZNWjqM23+FWtiodAVK78QlapeXIjiQMZSiMzbL1cA=";
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
