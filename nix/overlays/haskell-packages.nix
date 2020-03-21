self: super:

let

  ghcide = import ../pkgs/ghcide.nix {
    inherit (self) config lib stdenv pkgs haskell-nix localLib;
  };

  hie = import ../pkgs/hie.nix {
    inherit (self) config lib stdenv pkgs haskell-nix localLib;
  };

in
{
  haskell-hacknix = (super.haskell-hacknix or {}) // {
    inherit ghcide;
    inherit hie;
  };
}
