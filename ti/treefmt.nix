{
  projectRootFile = "flake.nix";

  programs = {
    statix.enable = true;
    deadnix.enable = true;
    nixfmt = {
      enable = true;
      strict = true;
    };
    typstyle.enable = true;
  };
}
