{ lib
, localLib
, stdenv
, fetchFromGitHub
, pkgs
, haskell-nix
, config ? { }
, enableLibraryProfiling ? false
, enableExecutableProfiling ? false
}:
let
  src = fetchFromGitHub {
    owner = "haskell";
    repo = "haskell-language-server";
    rev = "019b02831595b6a3be6776bfc56060ab918876e7";
    sha256 = "1b0zlnmd43gzpz6dibpgczwq82vqj4yk3wb4q64dwkpyp3v7hi1x";
    fetchSubmodules = true;
  };
  pkgSet = compiler:
    let
      ghc = haskell-nix.compiler.${compiler};
      stackYaml =
        if compiler == "ghc865" then
          "stack-8.6.5.yaml"
        else if compiler == "ghc883" then
          "stack-8.8.3.yaml"
        else
          abort "ghcide: unsupported compiler ${compiler}";
    in
    haskell-nix.stackProject {
      inherit src;
      inherit stackYaml;

      pkg-def-extras = [
        (
          hackage: {
            packages = {
              "haskell-lsp" = hackage.haskell-lsp."0.21.0.0".revisions.default;
            };
          }
        )
      ];

      modules = [
        {
          ghc.package = ghc;
          compiler.version = pkgs.lib.mkForce ghc.version;
          inherit enableLibraryProfiling enableExecutableProfiling;

          packages.ghc.flags.ghci = pkgs.lib.mkForce true;
          packages.ghci.flags.ghci = pkgs.lib.mkForce true;
          reinstallableLibGhc = true;
          packages.ghcide.configureFlags = [ "--enable-executable-dynamic" ];

          # Haddock on haddock-api is broken :\
          packages.haddock-api.components.library.doHaddock = lib.mkForce false;
        }
      ];
    };
in
{
  ghc865 = pkgSet "ghc865";
  ghc883 = pkgSet "ghc883";
}
