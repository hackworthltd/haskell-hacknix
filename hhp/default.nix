{ pkgs
}:
let
  inherit (pkgs.haskell-hacknix.lib)
    collectTests';

  inherit (pkgs.haskell-hacknix)
    cabalProject shellFor;

  inherit (pkgs.haskell-nix.haskellLib)
    collectChecks' selectLocalPackages;

  src = ../.;

  mkSet = args:
    let
      haskellPackages = cabalProject (args // {
        name = "hhp";
        materialize = true;
      });
      localPackages = selectLocalPackages haskellPackages;
      tests = collectTests' localPackages;
      checks = collectChecks' localPackages;
      shell = shellFor haskellPackages args;
    in
    pkgs.recurseIntoAttrs {
      inherit haskellPackages shell tests checks;
      inherit (pkgs.haskell-nix) checkMaterialization;

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
