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

  # Override hacknix's nixpkgs for now, until this is resolved:
  # https://github.com/input-output-hk/haskell.nix/issues/467
  #inherit (lib.fetchers) fixedNixpkgs fixedNixOps;
  #inherit (lib.hacknix) nixpkgs;
  fixedNixpkgs = lib.fetchers.fixedNixSrc "nixpkgs_override" sources.nixpkgs-unstable;
  nixpkgs = import fixedNixpkgs;

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
    ./overlays/haskell.nix
    ./overlays/lib.nix
  ]);

  nixpkgsConfig = haskellNix.config // config;

  pkgs = nixpkgs {
    inherit overlays;
    inherit system crossSystem;
    config = nixpkgsConfig;
  };

  self = {
    inherit sources;
    inherit fixedNixpkgs;
    inherit fixedHaskellNix;
    inherit nixpkgs;
    inherit haskellNix;
    inherit overlays;
    inherit pkgs;
    inherit nixpkgsConfig;
  };


in
self
