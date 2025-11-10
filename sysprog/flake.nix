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
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

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
            clang-tidy = {
              enable = true;
              # TODO: You most likely want to include the compilation database here (compile_commands.json)
              # NOTE: A full path is needed. Therefore the below doesn't work.
              #       You could add it to Git as a workaround but this is HEAVILY DISCOURAGED.
              # compileCommandsPath = ./compile_commands.json;
            };
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
