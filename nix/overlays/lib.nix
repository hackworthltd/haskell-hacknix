self: super:

let

  collectTests = filter: hp:
    super.haskell-nix.haskellLib.collectComponents' "tests" (super.lib.filterAttrs filter hp);
  collectChecks = filter: hp:
    super.recurseIntoAttrs (super.lib.mapAttrs (_: pkg: pkg.checks) (super.lib.filterAttrs filter hp));


  # Add some useful tools to a `shellFor` and make it buildable on a
  # Hydra.
  #
  # For the format of `compilerTools`, see our `haskell-hacknix.ghc*`
  # attributes.

  hacknixShell = compilerTools: shell: shell.overrideAttrs (oldAttrs: {
    buildInputs = [
      super.haskell-nix.cabal-install
      super.haskell-hacknix.hlint
      super.haskell-hacknix.brittany
      super.haskell-hacknix.ghcid
    ] ++ (with compilerTools; [
      ghcide
      hie
      hie-wrapper
    ]);
    meta.platforms = super.lib.platforms.unix;
  });

  hacknixShell865 = hacknixShell super.haskell-hacknix.ghc865;
  hacknixShell883 = hacknixShell super.haskell-hacknix.ghc883;

in
{
  lib = (super.lib or {}) // {
    hacknix = (super.lib.hacknix or {}) // {
      haskellLib = (super.lib.hacknix.haskellLib or {}) // {
        inherit collectTests collectChecks;
        inherit hacknixShell hacknixShell865 hacknixShell883;
      };
    };
  };
}
