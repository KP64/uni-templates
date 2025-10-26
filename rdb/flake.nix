{
  description = "RDB - Sommer Semester";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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
          treefmt.programs = {
            deadnix.enable = true;
            statix.enable = true;
            nixf-diagnose.enable = true;
            nixfmt = {
              enable = true;
              strict = true;
            };

            shellcheck.enable = true;
            shfmt.enable = true;
          };

          devShells.default = pkgs.mkShell {
            name = "RDB";

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
