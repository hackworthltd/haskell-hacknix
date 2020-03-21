{ system ? builtins.currentSystem
, crossSystem ? null
, config ? { allowBroken = true; allowUnfree = true; }
, sourcesOverride ? {}
, pkgs ? (import ./nix { inherit system crossSystem config sourcesOverride; }).pkgs
, gitrev ? pkgs.lib.commitIdFromGitRepo ./.

}:

let

in
{
  # Special Haskell packages. These have attributes for each GHC
  # version we support.
  inherit (pkgs.haskell-hacknix) ghcide hie;

  # Help with IFD caching.
  inherit (pkgs.haskell-nix) haskellNixRoots;

  # All overlays provided by this package, including everything in
  # hacknix.
  inherit (pkgs) overlays;
}
