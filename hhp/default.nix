{ system ? builtins.currentSystem
, crossSystem ? null
, config ? {
    allowBroken = true;
    allowUnfree = true;
  }
, sourcesOverride ? { }
, checkMaterialization ? false
, pkgs ? (import ../default.nix {
    inherit system crossSystem config sourcesOverride checkMaterialization;
  }
  ).pkgs
}:
let
  inherit (pkgs.haskell-hacknix.lib)
    collectTests collectChecks filterByPrefix;

  inherit (pkgs.haskell-hacknix)
    cabalProject cache shellFor;

  src = ../.;

  isHhpPackage = filterByPrefix "hhp";

  mkSet = args:
    let
      haskellPackages = cabalProject (args // {
        name = "hhp";
        materialize = true;
      });
      shell = shellFor haskellPackages args;
      cachedShell = cache shell;
      tests = collectTests isHhpPackage haskellPackages;
      checks = collectChecks isHhpPackage haskellPackages;
    in
    pkgs.recurseIntoAttrs {
      inherit haskellPackages shell cachedShell tests checks;
      inherit checkMaterialization;

      updateMaterialized = pkgs.haskell-hacknix.lib.updateMaterialized haskellPackages;
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

  ghc884Args = {
    compiler-nix-name = "ghc884";
    inherit src;
    subdir = "hhp";
  };
  ghc884 = mkSet ghc884Args;
  ghc884-profiled = mkProfiledSet ghc884Args;

  ghc8102Args = {
    compiler-nix-name = "ghc8102";
    inherit src;
    subdir = "hhp";
  };
  ghc8102 = mkSet ghc8102Args;
  ghc8102-profiled = mkProfiledSet ghc8102Args;

in
{
  inherit ghc865 ghc865-profiled;
  inherit ghc884 ghc884-profiled;
  inherit ghc8102 ghc8102-profiled;
}
