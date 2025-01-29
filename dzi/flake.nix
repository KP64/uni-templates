{
  description = "Nix flake for dzi dev";

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
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        treefmt = (treefmt-nix.lib.evalModule pkgs ./treefmt.nix).config.build;
      in
      {
        formatter = treefmt.wrapper;

        checks.formatting = treefmt.check self;

        devShells.default = pkgs.mkShell {
          venvDir = ".venv";
          packages = with pkgs; [
            just
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
      }
    );
}
