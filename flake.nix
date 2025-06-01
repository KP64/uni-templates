{
  description = "A very basic flake";

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

      flake.templates = {
        alpro = {
          path = ./alpro;
          description = "1st Semester Alpro";
        };

        dzi = {
          path = ./dzi;
          description = "3rd Semester dzi";
        };

        rdb = {
          path = ./rdb;
          description = "4th or 6th Semester rdb";
        };

        sys-inf = {
          path = ./sys-inf;
          description = "2nd Semester Sys-Inf";
        };

        ti = {
          path = ./ti;
          description = "1st Semester TI";
        };
      };

      perSystem =
        { pkgs, ... }:
        {
          treefmt = ./treefmt.nix;

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              just
              nil
            ];
          };
        };
    };
}
