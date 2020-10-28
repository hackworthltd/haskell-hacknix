{ checkMaterialization ? false
}:

self: super:
let
  # Based on:
  # https://github.com/input-output-hk/haskell.nix/blob/5f80ca910b0c34562f76aa4dcfc2464840b2d0ef/lib/call-cabal-project-to-nix.nix#L220
  materializedPath = name: args:
    let
      ghc = super.haskell-nix.compiler."${args.compiler-nix-name}";
    in
    ../materialized + "/${ghc.targetPrefix}${ghc.name}-${super.stdenv.buildPlatform.system}/${name}";

  hls = args:
    (super.haskell-nix.project (args // rec {
      inherit checkMaterialization;

      name = "haskell-language-server";
      materialized = materializedPath name args;

      # We need this until niv supports fetching git submodules, as
      # hls has its own ghcide submodule.
      src = super.fetchFromGitHub {
        owner = "haskell";
        repo = "haskell-language-server";
        rev = "0.5.1";
        sha256 = "17nzgpiacmrvwsy2fjx6a6pcpkncqcwfhaijvajm16jpdgni8mik";
        fetchSubmodules = true;
      };
      sha256map = {
        "https://github.com/bubba/brittany.git"."c59655f10d5ad295c2481537fc8abf0a297d9d1c" = "1rkk09f8750qykrmkqfqbh44dbx1p8aq1caznxxlw8zqfvx39cxl";
      };
      projectFileName =
        if (args.compiler-nix-name == "ghc865") then "stack-8.6.5.yaml"
        else if (args.compiler-nix-name == "ghc883") then "stack-8.8.3.yaml"
        else if (args.compiler-nix-name == "ghc884") then "stack-8.8.4.yaml"
        else if (args.compiler-nix-name == "ghc8101") then "stack-8.10.1.yaml"
        else if (args.compiler-nix-name == "ghc8102") then "stack-8.10.2.yaml"
        else abort "hls doesn't support this version of GHC yet";
      modules = [
        ({ config, ... }: {
          packages.ghc.flags.ghci = super.lib.mkForce true;
          packages.ghci.flags.ghci = super.lib.mkForce true;
          packages.ghcide.configureFlags = [ "--enable-executable-dynamic" ];

          # Haddock on haddock-api is broken :\
          packages.haddock-api.components.library.doHaddock = super.lib.mkForce false;
        })
      ];
    }));

  cabal-fmt = args:
    (super.haskell-nix.cabalProject (args // rec {
      inherit checkMaterialization;

      # Note: cabal-fmt doesn't provide its own index-state, so we
      # choose one for it here.
      index-state = "2020-10-28T00:00:00Z";

      name = "cabal-fmt";
      materialized = materializedPath name args;

      src = super.localLib.sources.cabal-fmt;
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
          packages.ghc.flags.ghci = super.lib.mkForce true;
          packages.ghci.flags.ghci = super.lib.mkForce true;
        }
      ];
    }));

  # Note: only works with GHC 8.6.5 at the moment.
  purescript = args:
    (super.haskell-nix.project (args // rec {
      inherit checkMaterialization;
      name = "purescript";
      materialized = materializedPath name args;
      src = super.localLib.sources.purescript;
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
          packages.purescript.flags.release = super.lib.mkForce true;
          packages.ghc.flags.ghci = super.lib.mkForce true;
          packages.ghci.flags.ghci = super.lib.mkForce true;
        }
      ];
    }));


  extra-custom-tools = {
    hls.latest = args: (hls args).haskell-language-server.components.exes.haskell-language-server;
    hls-wrapper.latest = args: (hls args).haskell-language-server.components.exes.haskell-language-server-wrapper;
    cabal-fmt.latest = args: (cabal-fmt args).cabal-fmt.components.exes.cabal-fmt;
    purescript.latest = args: (purescript args).purescript.components.exes.purs;
  };


  # Some useful tools. These are GHC-independent, so we just choose a
  # mostly arbitrary version of GHC to build each tool. (GHC-dependent
  # tools are build in the `shellFor` derivation; see below.)

  haskell-tools = {
    cabal = super.haskell-nix.tool "ghc884" "cabal" "3.2.0.0";
    cabal-fmt = super.haskell-nix.tool "ghc8102" "cabal-fmt" "latest";
    hlint = super.haskell-nix.tool "ghc884" "hlint" "3.2.1";
    ormolu = super.haskell-nix.tool "ghc884" "ormolu" "0.1.3.0";
    cabal-edit = super.haskell-nix.tool "ghc8102" "cabal-edit" "0.1.0.0";
    purescript = super.haskell-nix.tool "ghc865" "purescript" "latest";
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
    super.haskell-nix.cabalProject (args // {
      inherit checkMaterialization;
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
        hls = "latest";
        hls-wrapper = "latest";
      } // (args.tools or { });

      buildInputs =
        (super.lib.mapAttrsToList (_: tool: tool) haskell-tools) ++ [
          # We could build this with haskell.nix, but it's not really
          # updated anymore, so why bother? Also, doesn't work with
          # `tools` because it needs haskell-src-exts 1.19 and it's not
          # possible to override dependency versions with tools, as far
          # as I know.
          (
            super.haskell.lib.justStaticExecutables
              super.haskellPackages.structured-haskell-mode
          )
        ] ++ (args.buildInputs or [ ]);

      # Help haskell-language-server find our Hoogle database. See:
      # https://github.com/input-output-hk/haskell.nix/issues/529
      shellHook = ''
        export HIE_HOOGLE_DATABASE="$(cat $(${super.which}/bin/which hoogle) | sed -n -e 's|.*--database \(.*\.hoo\).*|\1|p')"
      '' + (args.shellHook or "");

      # Make this buildable on Hydra.
      meta.platforms = super.lib.platforms.unix;
    });

  # An alias for `withInputs` that describes what we use it for.
  cache = super.haskell-nix.withInputs;

  lib = super.recurseIntoAttrs {
    collectTests = filter: hp:
      super.haskell-nix.haskellLib.collectComponents' "tests"
        (super.lib.filterAttrs filter hp);
    collectChecks = filter: hp:
      super.recurseIntoAttrs (super.lib.mapAttrs (_: pkg: pkg.checks) (super.lib.filterAttrs filter hp));

    # Filters for collectTests and collectChecks.
    filterByPrefix = prefix: name: pkg:
      (pkg.isHaskell or false) && super.lib.hasPrefix prefix name;
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
          super.lib.sources.cleanSourceWith {
            inherit filter;
            src = src';
          };
      in
      cleanSource' (super.lib.sources.cleanSourceAllExtraneous src);

    # A convenience function to extract a haskell.nix project's
    # materialization update script.
    updateMaterialized = project: project.plan-nix.passthru.updateMaterialized;
  };

in
{
  haskell-nix = super.haskell-nix // {
    custom-tools = super.haskell-nix.custom-tools // extra-custom-tools;
  };

  haskell-hacknix = (super.haskell-hacknix or { }) // super.recurseIntoAttrs {
    inherit haskell-tools;
    inherit cabalProject;
    inherit shellFor;
    inherit cache;
    inherit lib;
  };
}
