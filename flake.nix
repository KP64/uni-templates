{
  description = "A very basic flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      imports = [ flake-parts.flakeModules.partitions ];

      partitions.dev = {
        extraInputsFlake = ./nix;
        module.imports = [ ./nix ];
      };
      partitionedAttrs = {
        checks = "dev";
        devShells = "dev";
        formatter = "dev";
      };

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
    };
}
