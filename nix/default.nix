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

        shellcheck.enable = true;
        shfmt.enable = true;
      };

      devShells.default = pkgs.mkShell {
        name = "uni-templates";

        packages = [ pkgs.nil ];
      };
    };
}
