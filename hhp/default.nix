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
    compiler-nix-name = "ghc865";
    inherit src;
    subdir = "hhp";
  };
  ghc865 = mkSet ghc865Args;
  ghc865-profiled = mkProfiledSet ghc865Args;

in
{
  inherit ghc865 ghc865-profiled;
}
