{
  description = ''
    Private inputs for development purposes.
    These are used by the top level flake in the `dev` partition,
    but do not appear in consumers' lock files.
  '';

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # This flake is only used for its inputs.
  outputs = _: { };
}
