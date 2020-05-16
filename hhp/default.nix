{ system ? builtins.currentSystem
, crossSystem ? null
, config ? {
    allowBroken = true;
    allowUnfree = true;
  }
, sourcesOverride ? { }
, pkgs ? (import ../default.nix {
    inherit system crossSystem config sourcesOverride;
  }
  ).pkgs
}:
let
  inherit (pkgs.lib.hacknix.haskellLib)
    collectTests collectChecks filterByPrefix;

  inherit (pkgs.haskell-hacknix)
    cabalProject cache shellFor;

  src = pkgs.gitignoreSource ../.;

  isHhpPackage = filterByPrefix "hhp";

  mkSet = args:
    let
      haskellPackages = cabalProject args;
      shell = shellFor haskellPackages { };
      cachedShell = cache shell;
      tests = collectTests isHhpPackage haskellPackages;
      checks = collectChecks isHhpPackage haskellPackages;
    in
    pkgs.recurseIntoAttrs {
      inherit haskellPackages shell cachedShell tests checks;
    };

  mkProfiledSet = args: mkSet (args // {
    enableLibraryProfiling = true;
    enableExecutableProfiling = true;
  });

  ghc865Args = {
    ghc = pkgs.haskell-nix.compiler.ghc865;
    inherit src;
    subdir = "hhp";
  };
  ghc865 = mkSet ghc865Args;
  ghc865-profiled = mkProfiledSet ghc865Args;

  ghc883Args = {
    ghc = pkgs.haskell-nix.compiler.ghc883;
    inherit src;
    subdir = "hhp";
    pkg-def-extras =
      [ (hackage: { alex = hackage.alex."3.2.5".revisions.default; }) ];
  };
  ghc883 = mkSet ghc883Args;
  ghc883-profiled = mkProfiledSet ghc883Args;

  # For now, we use the bare upstream cabalProject function.
  ghcjs865 = pkgs.pkgsCross.ghcjs.haskell-nix.cabalProject {
    ghc = pkgs.pkgsCross.ghcjs.buildPackages.haskell-nix.compiler.ghc865;
    inherit src;
    subdir = "hhp";
    configureArgs = "--ghcjs --with-ghcjs=js-unknown-ghcjs-ghc";
    modules = [
      {
        bootPkgs = [ "ghcjs-prim" ];
        nonReinstallablePkgs = [
          "Cabal"
          "array"
          "base"
          "binary"
          "bytestring"
          "containers"
          "deepseq"
          "directory"
          "filepath"
          "ghc"
          "ghc-boot"
          "ghc-boot-th"
          "ghc-compact"
          "ghc-heap"
          "ghc-prim"
          "ghci"
          "ghcjs-prim"
          "ghcjs-th"
          "integer-gmp"
          "mtl"
          "parsec"
          "pretty"
          "process"
          "rts"
          "template-haskell"
          "text"
          "time"
          "transformers"
          "unix"

          "hpc"

          # we can't build this one, so let's pretend it pre-exists.
          "terminfo"

          # This one is just absolutely broken.
          "cabal-doctest"
        ];
      }
    ];
  };
in
{
  inherit ghc865 ghc865-profiled;
  inherit ghc883 ghc883-profiled;
  inherit ghcjs865;
}
