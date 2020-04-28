{ system ? builtins.currentSystem, crossSystem ? null, config ? { }
, sourcesOverride ? { } }:

let

  sources = import ./sources.nix // sourcesOverride;

  fixedHacknix = let try = builtins.tryEval <hacknix>;
  in if try.success then
    builtins.trace "Using <hacknix>" try.value
  else
    sources.hacknix;

  hacknix = import fixedHacknix { };
  inherit (hacknix) lib;

  inherit (lib.fetchers) fixedNixpkgs;
  inherit (lib.hacknix) nixpkgs;

  fixedHaskellNix = lib.fetchers.fixedNixSrc "haskell-nix" sources.haskell-nix;
  haskellNix = import fixedHaskellNix;

  overlays = lib.singleton hacknix.overlays.all ++ haskellNix.overlays
    ++ [ (pkgs: _: { localLib = self; }) ]
    ++ (map import [ ./overlays/haskell.nix ./overlays/lib.nix ]);

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

in self
