{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      treefmt-nix,
      ...
    }:
    {
      templates = {
        alpro = {
          path = ./alpro;
          description = "1st Semester Alpro";
        };

        dzi = {
          path = ./dzi;
          description = "3rd Semester dzi";
        };

        rdb = {
          path = ./rdb;
          description = "4th or 6th Semester rdb";
        };

        sys-inf = {
          path = ./sys-inf;
          description = "2nd Semester Sys-Inf";
        };

        ti = {
          path = ./ti;
          description = "1st Semester TI";
        };
      };
    }
    // flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        treefmt = (treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build;
      in
      {
        formatter = treefmt.wrapper;
        checks.formatting = treefmt.check self;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            deadnix
            statix
            just
            nixd
            nix-melt
            nixfmt-rfc-style
          ];
        };
      }
    );
}
