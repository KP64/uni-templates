{
  description = "A Nix-flake-based AlPro development environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        filesToCompile = [
          "main"
        ];
      in
      {
        packages.default = pkgs.stdenv.mkDerivation {
          name = "main";
          src = self;
          buildPhase =
            let
              cmd = filename: "clang++ -std=c++20 ${./src/${filename}.cpp} -o ${filename}";
            in
            pkgs.lib.concatLines (map cmd filesToCompile);
          installPhase =
            ''
              mkdir -p $out/bin
            ''
            + (pkgs.lib.concatLines (map (f: "cp ${f} $out/bin/") filesToCompile));
          nativeBuildInputs = with pkgs; [ clang ];
        };

        formatter = pkgs.nixfmt-rfc-style;

        devShells.default = pkgs.mkShell.override { stdenv = pkgs.clangStdenv; } {
          packages =
            with pkgs;
            [
              clang-tools
              cmake
              codespell
              conan
              cppcheck
              doxygen
              gtest
              lcov
              vcpkg
              vcpkg-tool

              just
            ]
            ++ (if system == "aarch64-darwin" then [ ] else [ gdb ]);
        };
      }
    );
}
