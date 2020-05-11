{ lib
, localLib
, stdenv
, pkgs
, haskell-nix
, config ? { }
, enableLibraryProfiling ? false
, enableExecutableProfiling ? false
}:
let
  pkgSet = compiler:
    let
      ghc = haskell-nix.compiler.${compiler};
    in
    haskell-nix.cabalProject {
      src = localLib.sources.cabal-fmt;

      pkg-def-extras = [
        (
          hackage: {
            binary = hackage.binary."0.8.8.0".revisions.default;
            parsec = hackage.parsec."3.1.14.0".revisions.default;
            text = hackage.text."1.2.4.0".revisions.default;
            time = hackage.time."1.9.3".revisions.default;
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
        }
      ];
    };
in
{
  ghc865 = pkgSet "ghc865";
  ghc883 = pkgSet "ghc883";
}
