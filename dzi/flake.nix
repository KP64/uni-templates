{
  description = "DZI - Winter Semester";

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
            nixfmt = {
              enable = true;
              strict = true;
            };

            just.enable = true;
          };

          devShells.default = pkgs.mkShell {
            packages = with pkgs; [
              nil

              just
              just-lsp

              pandoc
              texliveFull

              (python313.withPackages (
                pypkgs: with pypkgs; [
                  jupyter
                  pandas
                  tensorflow
                ]
              ))
            ];
          };
        };
    };
}
