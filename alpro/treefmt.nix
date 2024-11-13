{
  projectRootFile = ".git/config";

  programs = {
    deadnix.enable = true;
    statix.enable = true;
    nixfmt.enable = true;

    cmake-format.enable = true;
    clang-format.enable = true;

    just.enable = true;
  };
}
