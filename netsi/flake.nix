{
  description = "NetSi - Sommer Semester";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

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

            texfmt.enable = true;
          };

          devShells.default = pkgs.mkShell {
            name = "NetSi";

            packages =
              let
                # NOTE: Add tex packages here if you have to
                tex = pkgs.texliveFull.withPackages (_texpkgs: [ ]);
              in
              [
                pkgs.nil
                tex
              ];
          };
        };
    };
}
