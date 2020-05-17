{ system ? builtins.currentSystem
, crossSystem ? null
, config ? { }
, sourcesOverride ? { }
, localLib ? (import ./nix/default.nix {
    inherit system crossSystem config sourcesOverride;
  }
  )
, pkgs ? localLib.pkgs
}:
let

  hhp = pkgs.recurseIntoAttrs (import ./hhp/default.nix { inherit pkgs; });

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
  inherit (pkgs.haskell-nix) haskellNixRoots;

  # Build some packages that we commonly use.
  inherit hhp;
}
