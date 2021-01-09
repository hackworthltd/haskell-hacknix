final: prev:
let
  # Based on:
  # https://github.com/input-output-hk/haskell.nix/blob/5f80ca910b0c34562f76aa4dcfc2464840b2d0ef/lib/call-cabal-project-to-nix.nix#L220
  materializedPath = name: args:
    let
      ghc = final.haskell-nix.compiler."${args.compiler-nix-name}";
    in
    ../materialized + "/${ghc.targetPrefix}${ghc.name}-${final.stdenv.buildPlatform.system}/${name}";

  cabal-fmt = args:
    (final.haskell-nix.cabalProject (args // rec {
      inherit (final.haskell-nix) checkMaterialization;

      # Note: cabal-fmt doesn't provide its own index-state, so we
      # choose one for it here.
      #index-state = "2021-01-06T00:00:00Z";

      name = "cabal-fmt";
      materialized = materializedPath name args;

      src = final.lib.haskell-hacknix.flake.inputs.cabal-fmt;
      pkg-def-extras = [
        (
          hackage: {
            binary = hackage.binary."0.8.8.0".revisions.default;
            Cabal = hackage.Cabal."3.2.0.0".revisions.default;
            parsec = hackage.parsec."3.1.14.0".revisions.default;
            text = hackage.text."1.2.4.0".revisions.default;
            time = hackage.time."1.9.3".revisions.default;
          }
        )
      ];
      modules = [
        {
          packages.ghc.flags.ghci = final.lib.mkForce true;
          packages.ghci.flags.ghci = final.lib.mkForce true;
        }
      ];
    }));

  # Note: only works with GHC 8.6.5 at the moment.
  purescript = args:
    (final.haskell-nix.project (args // rec {
      inherit (final.haskell-nix) checkMaterialization;
      name = "purescript";
      materialized = materializedPath name args;
      src = final.lib.haskell-hacknix.flake.inputs.purescript;
      projectFileName = "stack.yaml";
      pkg-def-extras = [
        (
          hackage: {
            hsc2hs = hackage.hsc2hs."0.68.7".revisions.default;
          }
        )
      ];
      modules = [
        {
          packages.purescript.flags.release = final.lib.mkForce true;
          packages.ghc.flags.ghci = final.lib.mkForce true;
          packages.ghci.flags.ghci = final.lib.mkForce true;
        }
      ];
    }));

  # We need the latest version.
  spago = args: (final.haskell-nix.project (args // rec {
    name = "spago";
    src = final.lib.haskell-hacknix.flake.inputs.spago;
    projectFileName = "stack.yaml";
    ignorePackageYaml = true;
    sha256map = {
      "https://github.com/f-f/haskell-with-utf8.git"."8ae743ac6503a4c494ea3bd52f1fe7d72f9f125d" = "sha256-vxI9AmaFxLn9kgQjaDhFbti/4KUyHoRslBwMa6WXtYE=";
    };
  }));

  extra-custom-tools = {
    cabal-fmt.latest = args: (cabal-fmt args).cabal-fmt.components.exes.cabal-fmt;
    purescript.latest = args: (purescript args).purescript.components.exes.purs;
    spago.latest = args: (spago args).spago.components.exes.spago;
  };


  # Some useful tools. These are GHC-independent, so we just choose a
  # mostly arbitrary version of GHC to build each tool. (GHC-dependent
  # tools are build in the `shellFor` derivation; see below.)

  haskell-tools = {
    cabal = final.haskell-nix.tool "ghc884" "cabal" "3.2.0.0";
    cabal-fmt = final.haskell-nix.tool "ghc8102" "cabal-fmt" "latest";
    hlint = final.haskell-nix.tool "ghc884" "hlint" "3.2.1";
    ormolu = final.haskell-nix.tool "ghc884" "ormolu" "0.1.3.0";
    cabal-edit = final.haskell-nix.tool "ghc8102" "cabal-edit" "0.1.0.0";
    purescript = final.haskell-nix.tool "ghc865" "purescript" "latest";
    spago = final.haskell-nix.tool "ghc865" "spago" "latest";
  };

  ## Convenience wrappers for `haskell-nix.cabalProject`s.
  #
  # These include any fixes needed for various haskell.nix issues.
  cabalProject =
    { compiler-nix-name
    , enableLibraryProfiling ? false
    , enableExecutableProfiling ? false
    , materialize ? false
    , ...
    }@args:
    final.haskell-nix.cabalProject (args // {
      inherit (final.haskell-nix) checkMaterialization;
      materialized = if materialize then (materializedPath args.name args) else null;
      modules = (args.modules or [ ]) ++ [
        # Workaround for doctest. See:
        # https://github.com/input-output-hk/haskell.nix/issues/221
        { reinstallableLibGhc = true; }
        { inherit enableLibraryProfiling enableExecutableProfiling; }
      ];
      pkg-def-extras = (args.pkg-def-extras or [ ]) ++
        (
          if compiler-nix-name == "ghc883" then [
            (hackage: {
              alex = hackage.alex."3.2.5".revisions.default;
            })
          ] else if compiler-nix-name == "ghc884" then [
            (hackage: {
              alex = hackage.alex."3.2.5".revisions.default;
            })
          ] else if compiler-nix-name == "ghc8101" then [
            (hackage: {
              alex = hackage.alex."3.2.5".revisions.default;
            })
          ] else if compiler-nix-name == "ghc8102" then [
            (hackage: {
              alex = hackage.alex."3.2.5".revisions.default;
            })
          ] else [ ]
        );
    });

  # Add some useful tools to a `shellFor`, and make it buildable on a
  # Hydra.
  shellFor = hp: { ... }@args:
    hp.shellFor (args // {

      # Tools that are GHC-specific.
      tools = {
        ghcid = "0.8.7";
        haskell-language-server = "0.8.0";
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
    collectTests = filter: hp:
      final.haskell-nix.haskellLib.collectComponents' "tests"
        (final.lib.filterAttrs filter hp);

    # Filters for collectTests and haskell.nix's collectChecks.
    filterByPrefix = prefix: name: pkg:
      (pkg.isHaskell or false) && final.lib.hasPrefix prefix name;
    filterByName = pkgName: name: pkg:
      (pkg.isHaskell or false) && name == pkgName;

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

    # A convenience function to extract a haskell.nix project's
    # materialization update script.
    updateMaterialized = project: project.plan-nix.passthru.updateMaterialized;
  };

in
{
  haskell-nix = prev.haskell-nix // {
    custom-tools = prev.haskell-nix.custom-tools // extra-custom-tools;
  };

  haskell-hacknix = (prev.haskell-hacknix or { }) // prev.recurseIntoAttrs {
    inherit haskell-tools;
    inherit cabalProject;
    inherit shellFor;
    inherit lib;
  };
}
