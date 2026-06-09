{
  description = "TdwA - Sommer Semester";

  inputs = {
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem =
        {
          config,
          lib,
          pkgs,
          ...
        }:
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

            texfmt.enable = true;
          };

          packages = lib.packagesFromDirectoryRecursive {
            inherit (pkgs) callPackage;
            directory = ./packages;
          };

          devShells.default = pkgs.mkShell {
            name = "TdwA";

            packages =
              let
                # NOTE: Add tex packages here if you have to
                tex = pkgs.texliveFull.withPackages (
                  texpkgs: with texpkgs; [
                    t1utils
                    csquotes
                  ]
                );
              in
              [
                tex
                config.packages.mermaid-cli
              ]
              ++ (with pkgs; [
                presenterm
                python314Packages.weasyprint
                yaml-language-server
                nil
                typst
              ]);
          };
        };
    };
}
