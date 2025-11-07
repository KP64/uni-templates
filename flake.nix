{
  description = "A very basic flake";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      inherit (inputs.nixpkgs) lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = lib.systems.flakeExposed;

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

      flake.templates = lib.pipe ./. [
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
