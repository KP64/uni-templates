{
  buildNpmPackage,
  lib,
  stdenv,
  fetchFromGitHub,
  chromium,
}:
let
  version = "11.14.0";
in
buildNpmPackage {
  pname = "mermaid-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "mermaid-js";
    repo = "mermaid-cli";
    rev = version;
    hash = "sha256-5AJZFZL5c0LCeo0hk+ONpGlY/LeB8XCKDZ6cug/TP2M=";
  };

  patches = [
    # https://github.com/mermaid-js/mermaid-cli/issues/830
    ./remove-puppeteer-from-dev-deps.patch
  ];

  npmDepsHash = "sha256-bb4t9jIyThEB9vrFx/tiQClNDdoAeDwGtaU4X3VXbrc=";

  env.PUPPETEER_SKIP_DOWNLOAD = true;

  npmBuildScript = "prepare";

  makeWrapperArgs = lib.lists.optional (lib.meta.availableOn stdenv.hostPlatform chromium) "--set PUPPETEER_EXECUTABLE_PATH '${lib.getExe chromium}'";

  meta = {
    description = "Generation of diagrams from text in a similar manner as markdown";
    homepage = "https://github.com/mermaid-js/mermaid-cli";
    license = lib.licenses.mit;
    mainProgram = "mmdc";
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
}
