{
  description = "SWT - Winter Semester";

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
            typstSource = "main.typ"; # TODO: Your typst file

            # Add paths to fonts here
            fontPaths = [
              # "${pkgs.roboto}/share/fonts/truetype"
            ];

            # Add paths that must be locally accessible to typst here
            virtualPaths = [ ];
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

            shellcheck.enable = true;
            shfmt.enable = true;

            google-java-format.enable = true;
          };

          checks = { inherit build-drv build-script watch-script; };

          packages.default = build-drv;

          apps = rec {
            default = watch;
            build.program = build-script;
            watch.program = watch-script;
          };

          devShells.default = typixLib.devShell {
            name = "SWT";
            inherit (commonArgs) fontPaths virtualPaths;

            packages = with pkgs; [
              nil
              jdk
              mermaid-cli
            ];
          };
        };
    };
}
