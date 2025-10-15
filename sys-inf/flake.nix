{
  description = "2nd Semester Sys-Inf";

  inputs = {
    alpha-tui = {
      url = "github:LMH01/alpha_tui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
        { pkgs, system, ... }:
        {
          treefmt = ./treefmt.nix;

          devShells.default = pkgs.mkShell {
            packages = [
              inputs.alpha-tui.packages.${system}.default
            ]
            ++ (with pkgs; [
              jdk
              just
            ]);
          };
        };
    };
}
