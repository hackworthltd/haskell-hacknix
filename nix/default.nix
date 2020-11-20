{ system ? builtins.currentSystem
, crossSystem ? null
, config ? { }
, sourcesOverride ? { }
, checkMaterialization ? false
}:
let
  sources = import ./sources.nix // sourcesOverride;

  # hacknix has a few useful functions that we want, but we *don't*
  # use its nixpkgs pin with haskell.nix, because we want to take
  # advantage of IOHK's cachix instance, and they have their own
  # nixpkgs pin.
  fixedHacknix =
    let try = builtins.tryEval <hacknix>;
    in
    if try.success then
      builtins.trace "Using <hacknix>" try.value
    else
      sources.hacknix;
  hacknix = import fixedHacknix {
    inherit system crossSystem config sourcesOverride;
  };
  inherit (hacknix) lib;

  # Here we can override the nixpkgs used with haskell.nix, if we
  # really want to. Note that this will override the haskell.nix
  # nixpkgs pin and most likely invalidate most of the haskell.nix
  # cachix cache.

  # For Big Sur support, until upstream bumps their nixpkgs pin.
  fixedNixpkgs = lib.fetchers.fixedNixSrc "nixpkgs_override" lib.fetchers.fixedNixpkgs;
  #fixedNixpkgs = lib.fetchers.fixedNixSrc "nixpkgs_override" haskellNix.sources.nixpkgs;
  nixpkgs = import fixedNixpkgs;

  fixedHaskellNix = lib.fetchers.fixedNixSrc "haskell-nix" sources.haskell-nix;
  haskellNix = import fixedHaskellNix {
    # For Big Sur support, until upstream bumps their nixpkgs pin.
    sourcesOverride = { nixpkgs = fixedNixpkgs; };
  };

  # Take care that these don't interfere with haskell.nix's cachix cache!
  overlays = haskellNix.overlays
    ++ [ (pkgs: _: { localLib = self; }) ]
    ++ (map (overlay: import overlay { inherit checkMaterialization; }) [
    ./overlays/hacknix.nix
    ./overlays/haskell.nix
  ]
  );

  pkgs = nixpkgs (haskellNix.nixpkgsArgs // {
    inherit system crossSystem;
    inherit overlays;
  });

  # Make local niv available until the nixpkgs version is fixed to
  # work with GitHub Actions.
  niv = (import sources.niv { }).niv;

  self = lib // {
    inherit sources;
    inherit fixedHaskellNix haskellNix;
    inherit overlays;
    inherit hacknix;
    inherit fixedNixpkgs nixpkgs;
    inherit pkgs;
    inherit niv;
  };
in
self
