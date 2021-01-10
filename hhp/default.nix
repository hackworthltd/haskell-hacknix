{ haskell-hacknix
, haskell-nix
, recurseIntoAttrs
, compiler-nix-name
, profiled ? false
}:
let
  haskellPackages = haskell-hacknix.cabalProject ({
    name = "hhp";
    src = ../.;
    subdir = "hhp";
    inherit compiler-nix-name;
    materialize = true;
  } // (if profiled then {
    enableLibraryProfiling = true;
    enableExecutableProfiling = true;
  } else { }));

  shell = haskell-hacknix.shellFor haskellPackages { };

  localPackages = haskell-nix.haskellLib.selectLocalPackages haskellPackages;
  tests = haskell-hacknix.lib.collectTests' localPackages;
  checks = haskell-nix.haskellLib.collectChecks' localPackages;

in
recurseIntoAttrs
{
  inherit shell tests checks;
}
