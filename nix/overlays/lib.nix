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
    buildInputs = oldAttrs.buildInputs ++ [
      super.haskell-nix.cabal-install
      super.haskell-hacknix.hlint
      super.haskell-hacknix.brittany
      super.haskell-hacknix.ghcid
    ] ++ (with compilerTools; [
      ghcide
      hie
      hie-wrapper
    ]);
    meta = (oldAttrs.meta or {}) // {
      platforms = super.lib.platforms.unix;
    };
  });

  hacknixShell865 = hacknixShell super.haskell-hacknix.ghc865;
  hacknixShell883 = hacknixShell super.haskell-hacknix.ghc883;


  # A useful source cleaner for Haskell projects.
  #
  # The advantage of this over haskell-nix.cleanGit is that the latter
  # requires that files are in the git index, which isn't helpful
  # while developing a package.

  cleanSource = { src, excludeDirs ? [], excludeFiles ? [] }:
    let
      filter = name: type:
        let baseName = baseNameOf (toString name);
        in ! (
          (type != "directory" && builtins.elem name excludeFiles) ||
          (type == "directory" && builtins.elem name excludeDirs)
        );
      cleanSource' = src': super.lib.sources.cleanSourceWith {
        inherit filter;
        src = src';
      };
    in
      cleanSource' (super.lib.sources.cleanSourceAllExtraneous src);

in
{
  lib = (super.lib or {}) // {
    hacknix = (super.lib.hacknix or {}) // {
      haskellLib = (super.lib.hacknix.haskellLib or {}) // {
        inherit collectTests collectChecks;
        inherit hacknixShell hacknixShell865 hacknixShell883;
        inherit cleanSource;
      };
    };
  };
}
