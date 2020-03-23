{ system ? builtins.currentSystem
, crossSystem ? null
, config ? {}
, sourcesOverride ? {}
}:

let

  sources = import ./sources.nix // sourcesOverride;

  fixedHacknix =
  let
    try = builtins.tryEval <hacknix>;
  in
    if try.success
      then builtins.trace "Using <hacknix>" try.value
      else (import sources.hacknix);

  hacknix = fixedHacknix {};
  inherit (hacknix) lib;
  inherit (lib.fetchers) fixedNixpkgs fixedNixOps;
  inherit (lib.hacknix) nixpkgs;

  fixedHaskellNix = lib.fetchers.fixedNixSrc "haskell-nix" sources.haskell-nix;
  haskellNix = import fixedHaskellNix;

  overlays = lib.singleton hacknix.overlays.all
  ++ haskellNix.overlays
  ++ [
    (pkgs: _: {
      localLib = self;
    })
  ]
  ++ (map import [
    ./overlays/lib.nix
    ./overlays/haskell.nix
  ]);

  pkgs = nixpkgs {
    inherit overlays;
    inherit system crossSystem;
    config = haskellNix.config // config;
  };

  self = {
    inherit sources;
    inherit fixedNixpkgs;
    inherit fixedHaskellNix;
    inherit nixpkgs;
    inherit haskellNix;
    inherit overlays;
    inherit pkgs;
  };


in
self
