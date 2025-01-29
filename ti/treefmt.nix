{
  projectRootFile = "flake.nix";

  programs = {
    statix.enable = true;
    deadnix.enable = true;
    nixfmt.enable = true;
    typstyle.enable = true;
  };
}
