{ system ? builtins.currentSystem
, crossSystem ? null
, config ? { }
, sourcesOverride ? { }
, checkMaterialization ? false
, localLib ? (import ./nix/default.nix {
    inherit system crossSystem config sourcesOverride checkMaterialization;
  }
  )
, pkgs ? localLib.pkgs
}:
let
  hhp = pkgs.recurseIntoAttrs (import ./hhp/default.nix {
    inherit pkgs checkMaterialization;
  });

  roots = pkgs.recurseIntoAttrs {
    ghc865 = pkgs.haskell-nix.roots "ghc865";
    ghc884 = pkgs.haskell-nix.roots "ghc884";
    ghc8102 = pkgs.haskell-nix.roots "ghc8102";
  };

in
{
  # These attributes are useful for downstream projects that use this
  # package as an overlay.
  inherit (localLib) sources fixedNixpkgs fixedHaskellNix;
  inherit (localLib) nixpkgs haskellNix overlays;
  inherit pkgs;

  # Local packages we want to build in Hydra.
  inherit (pkgs) haskell-hacknix;

  # Help with IFD caching.
  inherit roots;

  # Build some packages that we commonly use.
  inherit hhp;
}
