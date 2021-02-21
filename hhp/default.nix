{ haskell-hacknix
, haskell-nix
, recurseIntoAttrs
, compiler-nix-name
}:
let
  haskellPackages = haskell-nix.cabalProject {
    name = "hhp";
    src = ../.;
    subdir = "hhp";
    inherit compiler-nix-name;
  };

  shell = haskell-hacknix.shellFor haskellPackages { };

  localPackages = haskell-nix.haskellLib.selectLocalPackages haskellPackages;
  tests = haskell-hacknix.lib.collectTests' localPackages;
  checks = haskell-nix.haskellLib.collectChecks' localPackages;

in
recurseIntoAttrs
{
  inherit shell tests checks;
}
