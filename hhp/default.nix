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
  inherit (pkgs.haskell-hacknix.lib)
    collectTests collectChecks filterByPrefix;

  inherit (pkgs.haskell-hacknix)
    cabalProject cache shellFor ghcjsCabalProject ghcjsShellFor;

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
    compiler-nix-name = "ghc865";
    inherit src;
    subdir = "hhp";
  };
  ghc865 = mkSet ghc865Args;
  ghc865-profiled = mkProfiledSet ghc865Args;

  ghc883Args = {
    compiler-nix-name = "ghc883";
    inherit src;
    subdir = "hhp";
    pkg-def-extras =
      [ (hackage: { alex = hackage.alex."3.2.5".revisions.default; }) ];
  };
  ghc883 = mkSet ghc883Args;
  ghc883-profiled = mkProfiledSet ghc883Args;

  ghcjs865 =
    let
      haskellPackages = ghcjsCabalProject ghc865Args;
      shell = ghcjsShellFor haskellPackages { };
      cachedShell = cache shell;
    in
    pkgs.recurseIntoAttrs {
      inherit haskellPackages shell cachedShell;
    };

  ghcjs883 =
    let
      haskellPackages = ghcjsCabalProject ghc883Args;
      shell = ghcjsShellFor haskellPackages { };
      cachedShell = cache shell;
    in
    pkgs.recurseIntoAttrs {
      inherit haskellPackages shell cachedShell;
    };
in
{
  inherit ghc865 ghc865-profiled;
  inherit ghc883 ghc883-profiled;
  inherit ghcjs865 ghcjs883;
}
