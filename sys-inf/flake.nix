{
  description = "Sys-Inf - Sommer Semester";

  inputs = {
    alpha-tui = {
      url = "github:LMH01/alpha_tui";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
        { inputs', pkgs, ... }:
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

            just.enable = true;
          };

          devShells.default = pkgs.mkShell {
            name = "Sys-Inf";

            packages = [
              inputs'.alpha-tui.packages.default
            ]
            ++ (with pkgs; [
              jdk

              just
              just-lsp
            ]);
          };
        };
    };
}
