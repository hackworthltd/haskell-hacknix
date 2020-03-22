self: super:

let

  ghcide = import ../pkgs/ghcide.nix {
    inherit (self) config lib stdenv pkgs haskell-nix localLib;
  };

  hie = import ../pkgs/hie.nix {
    inherit (self) config lib stdenv pkgs haskell-nix localLib;
  };

  exeOnly = name: super.haskell-nix.haskellPackages.${name}.components.exes.${name};

  hlint = exeOnly "hlint";
  brittany = exeOnly "brittany";
  ghcid = exeOnly "ghcid";

in
{
  haskell-hacknix = (super.haskell-hacknix or {}) // super.recurseIntoAttrs {
    ghc865 = super.recurseIntoAttrs {
      inherit (ghcide.ghc865.ghcide.components.exes) ghcide;
      inherit (hie.ghc865.haskell-ide-engine.components.exes) hie hie-wrapper;
    };
    ghc883 = super.recurseIntoAttrs {
      inherit (ghcide.ghc883.ghcide.components.exes) ghcide;
      inherit (hie.ghc883.haskell-ide-engine.components.exes) hie hie-wrapper;
    };

    inherit (super.haskell-nix) cabal-install;
    inherit hlint brittany ghcid;
  };
}
