{ localLib
, pkgs
, haskell-nix
}:
let
  ghc = haskell-nix.compiler.ghc883;
  pkgSet =
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

          packages.ghc.flags.ghci = pkgs.lib.mkForce true;
          packages.ghci.flags.ghci = pkgs.lib.mkForce true;
          reinstallableLibGhc = true;
        }
      ];
    };
in
pkgSet.cabal-fmt.components.exes.cabal-fmt
