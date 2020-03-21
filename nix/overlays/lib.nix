self: super:

let

  collectTests = filter: hp:
    super.haskell-nix.haskellLib.collectComponents' "tests" (super.lib.filterAttrs filter hp);
  collectChecks = filter: hp:
    super.recurseIntoAttrs (super.lib.mapAttrs (_: pkg: pkg.checks) (super.lib.filterAttrs filter hp));

in
{
  lib = (super.lib or {}) // {
    hacknix = (super.lib.hacknix or {}) // {
      haskellLib = (super.lib.hacknix.haskellLib or {}) // {
        inherit collectTests collectChecks;
      };
    };
  };
}
