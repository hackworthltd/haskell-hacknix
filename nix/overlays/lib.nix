self: super:

let

  collectTests = filter: hp:
    super.haskell-nix.haskellLib.collectComponents' "tests" (super.lib.filterAttrs filter hp);
  collectChecks = filter: hp:
    super.recurseIntoAttrs (super.lib.mapAttrs (_: pkg: pkg.checks) (super.lib.filterAttrs filter hp));


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
        inherit cleanSource;
      };
    };
  };
}
