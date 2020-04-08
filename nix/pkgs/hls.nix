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
    rev = "86fe4eb1d523446a279c0e1b29f6e39d66e4b39d";
    sha256 = "0sk471lzhk179vckaby12ls5vvq3srhwy8bkbywsxlk00y8nm33n";
    fetchSubmodules = true;
  };

  pkgSet = compiler:
    let
      ghc = haskell-nix.compiler.${compiler};

      stackYaml =
        if compiler == "ghc865" then "stack-8.6.5.yaml"
        else if compiler == "ghc883" then "stack-8.8.2.yaml"
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

          packages.ghc.flags.ghci = pkgs.lib.mkForce true;
          packages.ghci.flags.ghci = pkgs.lib.mkForce true;
          reinstallableLibGhc = true;
          packages.ghcide.configureFlags = [ "--enable-executable-dynamic" ];

          # Haddock on haddock-api is broken :\
          packages.haddock-api.components.library.doHaddock = lib.mkForce false;
    }];
  };

in
{
  ghc865 = pkgSet "ghc865";
  ghc883 = pkgSet "ghc883";
}
