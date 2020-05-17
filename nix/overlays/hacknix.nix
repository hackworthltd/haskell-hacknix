# Insert into the haskell-hacknix overlay the bits we want from hacknix.

self: super:
{
  inherit (super.localLib.hacknix) gitignoreSource;
}
