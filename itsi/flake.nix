{
  description = "ITSi - Winter Semester";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";

    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    typix = {
      url = "github:loqusion/typix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Example of downloading icons from a non-flake source
    # font-awesome = {
    #   url = "github:FortAwesome/Font-Awesome";
    #   flake = false;
    # };
  };

  outputs =
    inputs:
    inputs.flake-parts.lib.mkFlake { inherit inputs; } {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;

      imports = [ inputs.treefmt-nix.flakeModule ];

      perSystem =
        { pkgs, system, ... }:
        let
          typixLib = inputs.typix.lib.${system};

          src = typixLib.cleanTypstSource ./.;
          commonArgs = {
            typstSource = "main.typ";

            fontPaths = [
              # Add paths to fonts here
              # "${pkgs.roboto}/share/fonts/truetype"
            ];

            virtualPaths = [
              # Add paths that must be locally accessible to typst here
              # {
              #   dest = "icons";
              #   src = "${inputs.font-awesome}/svgs/regular";
              # }
            ];
          };

          # Compile a Typst project, *without* copying the result
          # to the current directory
          build-drv = typixLib.buildTypstProject (commonArgs // { inherit src; });

          # Compile a Typst project, and then copy the result
          # to the current directory
          build-script = typixLib.buildTypstProjectLocal (commonArgs // { inherit src; });

          # Watch a project and recompile on changes
          watch-script = typixLib.watchTypstProject commonArgs;
        in
        {
          treefmt.programs = {
            deadnix.enable = true;
            statix.enable = true;
            nixf-diagnose.enable = true;
            nixfmt = {
              enable = true;
              strict = true;
            };

            just.enable = true;

            shellcheck.enable = true;
            shfmt.enable = true;

            clang-format.enable = true;
            clang-tidy = {
              enable = true;
              # TODO: You most likely want to include the compilation database here (compile_commands.json)
              # NOTE: A full path is needed. Therefore the below doesn't work.
              #       You could add it to Git as a workaround but this is HEAVILY DISCOURAGED.
              # compileCommandsPath = ./compile_commands.json;
            };
          };
          checks = { inherit build-drv build-script watch-script; };

          packages.default = build-drv;

          apps = rec {
            default = watch;
            build.program = build-script;
            watch.program = watch-script;
          };

          devShells.default = typixLib.devShell {
            name = "ITSi";
            inherit (commonArgs) fontPaths virtualPaths;

            packages = with pkgs; [
              nil
              just-lsp
              just
              bear
              clang-tools
              clang
              lldb
            ];
          };
        };
    };
}
