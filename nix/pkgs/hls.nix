{ lib
, localLib
, stdenv
, fetchFromGitHub
, pkgs
, haskell-nix
, config ? {}
, profiling ? config.haskellNix.profiling or false
}:

let

  src = fetchFromGitHub {
    owner = "haskell";
    repo = "haskell-language-server";
    rev = "ee4d3b26a8d0fe6c2e40fcecbf80bf744996dd1c";
    sha256 = "125qgzhagxcxib4frfcw6hdz0bg7lz97zdzb1zdm0dfdxa26p9f7";
    fetchSubmodules = true;
  };

  pkgSet = compiler:
    let
      ghc = haskell-nix.compiler.${compiler};

      stackYaml =
        if compiler == "ghc865" then "stack-8.6.5.yaml"
        else if compiler == "ghc883" then "stack-8.8.3.yaml"
        else abort "ghcide: unsupported compiler ${compiler}";
    in
      haskell-nix.stackProject {
        inherit src;
        inherit stackYaml;

        pkg-def-extras = [
          (hackage: {
            packages = {
              "haskell-lsp" = hackage.haskell-lsp."0.20.0.1".revisions.default;
            };
          })
        ];

        modules = [{
          ghc.package = ghc;
          compiler.version = pkgs.lib.mkForce ghc.version;
          enableLibraryProfiling = profiling;

          # Workaround for doctest. See:
          # https://github.com/input-output-hk/haskell.nix/issues/221
          reinstallableLibGhc = true;

          # Haddock on haddock-api is broken :\
          packages.haddock-api.components.library.doHaddock = lib.mkForce false;
    }];
  };

in
{
  ghc865 = pkgSet "ghc865";
  ghc883 = pkgSet "ghc883";
}
