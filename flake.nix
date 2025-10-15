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

      flake.templates =
        let
          inherit (inputs.nixpkgs) lib;
        in
        lib.pipe ./. [
          builtins.readDir
          (lib.filterAttrs (name: value: name != "nix" && value == "directory"))
          (builtins.mapAttrs (
            name: _: rec {
              path = ./${name};
              inherit (import (path + /flake.nix)) description;
            }
          ))
        ];
    };
}
