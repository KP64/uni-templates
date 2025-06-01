{
  projectRootFile = "flake.nix";

  programs = {
    deadnix.enable = true;
    statix.enable = true;
    nixfmt = {
      enable = true;
      strict = true;
    };

    google-java-format.enable = true;

    just.enable = true;
  };
}
