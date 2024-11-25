{
  projectRootFile = "flake.nix";

  programs = {
    deadnix.enable = true;
    statix.enable = true;
    nixfmt.enable = true;

    clang-format.enable = true;

    just.enable = true;

    shfmt.enable = true;
  };
}
