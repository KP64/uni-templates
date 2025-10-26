{
  description = "TI - Winter Semester";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";

    # Example of downloading icons from a non-flake source
    font-awesome = {
      url = "github:FortAwesome/Font-Awesome";
      flake = false;
    };

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
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];

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
              "${pkgs.roboto}/share/fonts/truetype"
            ];

            virtualPaths = [
              # Add paths that must be locally accessible to typst here
              {
                dest = "icons";
                src = "${inputs.font-awesome}/svgs/regular";
              }
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
            statix.enable = true;
            deadnix.enable = true;
            nixfmt = {
              enable = true;
              strict = true;
            };

            typstyle.enable = true;
          };

          checks = { inherit build-drv build-script watch-script; };

          packages.default = build-drv;

          apps = rec {
            default = watch;
            build = build-script;
            watch = watch-script;
          };

          devShells.default = typixLib.devShell {
            name = "TI";

            inherit (commonArgs) fontPaths virtualPaths;
            packages = [
              # WARNING: Don't run `typst-build` directly, instead use `nix run .#build`
              # See https://github.com/loqusion/typix/issues/2
              build-script
              watch-script
            ];
          };
        };
    };
}
