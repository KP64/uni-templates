{ inputs, ... }:
{
  imports = [ inputs.treefmt-nix.flakeModule ];

  perSystem =
    { pkgs, ... }:
    {
      treefmt.programs = {
        deadnix.enable = true;
        statix.enable = true;
        nixfmt = {
          enable = true;
          strict = true;
        };

        clang-format.enable = true;

        just.enable = true;

        shfmt.enable = true;

        typstyle.enable = true;

        google-java-format.enable = true;
      };

      devShells.default = pkgs.mkShell {
        name = "uni-templates";

        packages = with pkgs; [
          just
          nil
        ];
      };
    };
}
