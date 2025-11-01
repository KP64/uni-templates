{
  description = "SysProg - Winter Semester";

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
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem =
        { lib, pkgs, ... }:
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

            asmfmt.enable = true;

            clang-format.enable = true;
            clang-tidy.enable = true;
          };

          devShells.default = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
            name = "SysProg";

            packages =
              (with pkgs; [
                nil

                clang-tools

                lldb
                valgrind
                nasm
              ])
              ++ lib.singleton (
                pkgs.writeShellApplication {
                  name = "gen-cc";
                  runtimeInputs = [ pkgs.bear ];
                  text = ''
                    bear -- make
                  '';
                }
              );
          };
        };
    };
}
