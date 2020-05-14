{ pkgs }:
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
    ghc = pkgs.haskell-nix.compiler.ghc865;
    inherit src;
    subdir = "hhp";
    pkg-def-extras =
      [ (hackage: { alex = hackage.alex."3.2.5".revisions.default; }) ];
  };
  ghc883 = mkSet ghc883Args;
  ghc883-profiled = mkProfiledSet ghc883Args;

in
{
  inherit ghc865 ghc865-profiled;
  inherit ghc883 ghc883-profiled;
}
