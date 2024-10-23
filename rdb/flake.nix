{
  description = "Nix flake for rdb dev";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            xorg.libXtst
            xorg.libXxf86vm
            libGL
            maven
            openjdk21
            scenebuilder
          ];

          LD_LIBRARY_PATH = "${pkgs.xorg.libXtst}/lib/:${pkgs.xorg.libXxf86vm}/lib/:${pkgs.libGL}/lib/";
        };
      }
    );
}
