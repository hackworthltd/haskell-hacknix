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
      shell = shellFor haskellPackages args;
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
  };
  ghc883 = mkSet ghc883Args;
  ghc883-profiled = mkProfiledSet ghc883Args;

  ghc884Args = {
    compiler-nix-name = "ghc884";
    inherit src;
    subdir = "hhp";
  };
  ghc884 = mkSet ghc884Args;
  ghc884-profiled = mkProfiledSet ghc884Args;

  ghc8101Args = {
    compiler-nix-name = "ghc8101";
    inherit src;
    subdir = "hhp";
  };
  ghc8101 = mkSet ghc8101Args;
  ghc8101-profiled = mkProfiledSet ghc8101Args;

in
{
  inherit ghc865 ghc865-profiled;
  inherit ghc883 ghc883-profiled;
  inherit ghc884 ghc884-profiled;
  inherit ghc8101 ghc8101-profiled;
}
