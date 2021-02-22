final: prev:
let
  cabal-fmt = args:
    (final.haskell-nix.cabalProject (args // rec {
      # Note: cabal-fmt doesn't provide its own index-state, so we
      # choose one for it here.
      index-state = "2021-02-22T00:00:00Z";

      name = "cabal-fmt";

      src = final.lib.haskell-hacknix.flake.inputs.cabal-fmt;
      pkg-def-extras = [
        (
          hackage: {
            binary = hackage.binary."0.8.8.0".revisions.default;
            Cabal = hackage.Cabal."3.4.0.0".revisions.default;
            parsec = hackage.parsec."3.1.14.0".revisions.default;
            text = hackage.text."1.2.4.0".revisions.default;
            time = hackage.time."1.9.3".revisions.default;
          }
        )
      ];
      modules = [
        { reinstallableLibGhc = true; }
        {
          packages.ghc.flags.ghci = final.lib.mkForce true;
          packages.ghci.flags.ghci = final.lib.mkForce true;
        }
      ];
    }));

  extra-custom-tools = {
    cabal-fmt.latest = args: (cabal-fmt args).cabal-fmt.components.exes.cabal-fmt;
  };


  # Some useful tools. These are GHC-independent, so we just choose a
  # mostly arbitrary version of GHC to build each tool. (GHC-dependent
  # tools are build in the `shellFor` derivation; see below.)

  haskell-tools = {
    cabal = final.haskell-nix.tool "ghc8104" "cabal" "latest";
    cabal-fmt = final.haskell-nix.tool "ghc884" "cabal-fmt" "latest";
    hlint = final.haskell-nix.tool "ghc884" "hlint" "latest";
    ormolu = final.haskell-nix.tool "ghc884" "ormolu" "latest";
    cabal-edit = final.haskell-nix.tool "ghc8104" "cabal-edit" "latest";
  };

  # Add some useful tools to a `shellFor`, and make it buildable on a
  # Hydra.
  shellFor = hp: { ... }@args:
    hp.shellFor (args // {

      # Tools that are GHC-specific.
      tools = {
        ghcid = "latest";
        haskell-language-server = "latest";
      } // (args.tools or { });

      buildInputs =
        (final.lib.mapAttrsToList (_: tool: tool) haskell-tools) ++ [
          # We could build this with haskell.nix, but it's not really
          # updated anymore, so why bother? Also, doesn't work with
          # `tools` because it needs haskell-src-exts 1.19 and it's not
          # possible to override dependency versions with tools, as far
          # as I know.
          (
            final.haskell.lib.justStaticExecutables
              final.haskellPackages.structured-haskell-mode
          )
        ] ++ (args.buildInputs or [ ]);

      # Help haskell-language-server find our Hoogle database. See:
      # https://github.com/input-output-hk/haskell.nix/issues/529
      shellHook = ''
        export HIE_HOOGLE_DATABASE="$(cat $(${final.which}/bin/which hoogle) | sed -n -e 's|.*--database \(.*\.hoo\).*|\1|p')"
      '' + (args.shellHook or "");

      # Make this buildable on Hydra.
      meta.platforms = final.lib.platforms.unix;
    });

  lib = final.recurseIntoAttrs {
    collectTests = final.haskell-nix.haskellLib.collectComponents "tests";
    collectTests' = final.haskell-nix.haskellLib.collectComponents' "tests";

    # A useful source cleaner for Haskell projects.
    #
    # The advantage of this over haskell-nix.cleanGit is that the latter
    # requires that files are in the git index, which isn't helpful
    # while developing a package.
    cleanSource = { src, excludeDirs ? [ ], excludeFiles ? [ ] }:
      let
        filter = name: type:
          let baseName = baseNameOf (toString name);
          in
            !((type != "directory" && builtins.elem name excludeFiles)
              || (type == "directory" && builtins.elem name excludeDirs));
        cleanSource' = src':
          final.lib.sources.cleanSourceWith {
            inherit filter;
            src = src';
          };
      in
      cleanSource' (final.lib.sources.cleanSourceAllExtraneous src);
  };

in
{
  haskell-nix = prev.haskell-nix // {
    custom-tools = prev.haskell-nix.custom-tools // extra-custom-tools;
  };

  haskell-hacknix = (prev.haskell-hacknix or { }) // prev.recurseIntoAttrs {
    inherit haskell-tools;
    inherit shellFor;
    inherit lib;
  };
}
