{ localLib
, pkgs
, haskell-nix
}:
let
  pkgSet =
    haskell-nix.cabalProject {
      compiler-nix-name = "ghc883";
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
          packages.ghc.flags.ghci = pkgs.lib.mkForce true;
          packages.ghci.flags.ghci = pkgs.lib.mkForce true;
          reinstallableLibGhc = true;
        }
      ];
    };
in
pkgSet.cabal-fmt.components.exes.cabal-fmt
