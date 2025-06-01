{
  description = "Nix flake for dzi dev";

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
            venvDir = ".venv";
            packages = with pkgs; [
              nil

              just
              just-lsp

              (python3.withPackages (
                ps: with ps; [
                  jupyter
                  conda
                  pip
                  venvShellHook
                  numpy
                  pandas
                  # Doesn't compile for now
                  # tensorflow
                  toolz
                ]
              ))
            ];
          };
        };
    };
}
