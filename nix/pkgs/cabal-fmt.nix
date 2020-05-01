{ lib
, localLib
, stdenv
, pkgs
, haskell-nix
, config ? {}
, enableLibraryProfiling ? false
, enableExecutableProfiling ? false
}:
let
  pkgSet = compiler:
    let
      ghc = haskell-nix.compiler.${compiler};
    in haskell-nix.cabalProject {
      src = localLib.sources.cabal-fmt;

      pkg-def-extras = [];

      modules = [
        {
          ghc.package = ghc;
          compiler.version = pkgs.lib.mkForce ghc.version;
          inherit enableLibraryProfiling enableExecutableProfiling;

          packages.ghc.flags.ghci = pkgs.lib.mkForce true;
          packages.ghci.flags.ghci = pkgs.lib.mkForce true;
          reinstallableLibGhc = true;
        }
      ];
    };
in
{
  ghc865 = pkgSet "ghc865";
  ghc883 = pkgSet "ghc883";
}
