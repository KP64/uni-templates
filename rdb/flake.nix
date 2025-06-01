{
  description = "Nix flake for rdb dev";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem =
        { pkgs, ... }:
        {
          treefmt = ./treefmt.nix;

          devShells.default = pkgs.mkShell {
            buildInputs = with pkgs; [
              xorg.libXtst
              xorg.libXxf86vm
              libGL
              maven
              openjdk21
              scenebuilder
            ];

            LD_LIBRARY_PATH = "${pkgs.xorg.libXtst}/lib/:${pkgs.xorg.libXxf86vm}/lib/:${pkgs.libGL}/lib/";
          };
        };

    };
}
