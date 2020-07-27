self: super:
let
  hie = args:
    (super.haskell-nix.project (args // {
      name = "haskell-ide-engine";
      src = super.localLib.sources.haskell-ide-engine;
      pkg-def-extras = [
        (hackage: {
          packages = {
            "haskell-lsp" = hackage.haskell-lsp."0.20.0.1".revisions.default;
          };
        })
      ];
      projectFileName = "cabal.project";
      modules = [
        ({ config, ... }: {
          packages.ghc.flags.ghci = super.lib.mkForce true;
          packages.ghci.flags.ghci = super.lib.mkForce true;
          reinstallableLibGhc = true;

          # Haddock on haddock-api is broken :\
          packages.haddock-api.components.library.doHaddock = super.lib.mkForce false;
        })
      ];
    }));

  hls = args:
    (super.haskell-nix.project (args // {
      name = "haskell-language-server";

      # We need this until niv supports fetching git submodules, as
      # hls has its own ghcide submodule.
      src = super.fetchFromGitHub {
        owner = "haskell";
        repo = "haskell-language-server";
        rev = "f2384e14abb206b133811d2c1d8525536d01a320";
        sha256 = "1fvy77i6gzzfqpsnyqkvz296aakjdjykh89xx5g7yy59d0kk4w2s";
        fetchSubmodules = true;
      };
      projectFileName =
        if (args.compiler-nix-name == "ghc865") then "stack-8.6.5.yaml"
        else if (args.compiler-nix-name == "ghc883") then "stack-8.8.3.yaml"
        else if (args.compiler-nix-name == "ghc884") then "stack-8.8.4.yaml"
        else if (args.compiler-nix-name == "ghc8101") then "stack-8.10.1.yaml"
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

  extra-custom-tools = {
    hie.latest = args: (hie args).haskell-ide-engine.components.exes.hie;
    hie-wrapper.latest = args: (hie args).haskell-ide-engine.components.exes.hie-wrapper;
    hls.latest = args: (hls args).haskell-language-server.components.exes.haskell-language-server;
    hls-wrapper.latest = args: (hls args).haskell-language-server.components.exes.haskell-language-server-wrapper;
  };

  # cabal-fmt doesn't build properly with haskell.nix, so we override
  # it with our own derivation.
  cabal-fmt = import ../pkgs/cabal-fmt.nix {
    inherit (super) pkgs haskell-nix localLib;
  };

  ## Convenience wrappers for `haskell-nix.cabalProject`s.
  #
  # These include any fixes needed for various haskell.nix issues.
  cabalProject =
    { compiler-nix-name
    , enableLibraryProfiling ? false
    , enableExecutableProfiling ? false
    , ...
    }@args:
    super.haskell-nix.cabalProject (args // {
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
      } // (if args.compiler-nix-name == "ghc8101" then { } else {
        hie = "latest";
        hie-wrapper = "latest";
      }
      ) // (args.tools or { });

      buildInputs = [
        cabal-fmt

        # These tools are GHC-independent, so we use GHC 8.8.4 to
        # build them. (Using 8.8.4 is arbitrary.)
        (super.haskell-nix.tool "ghc884" "brittany" "0.12.1.1")
        (super.haskell-nix.tool "ghc884" "cabal" "3.2.0.0")
        (super.haskell-nix.tool "ghc884" "hlint" "3.1.6")
        (super.haskell-nix.tool "ghc884" "ormolu" "0.1.2.0")

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

      # Help haskell-ide-engine find our Hoogle database. See:
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
  };

in
{
  haskell-nix = super.haskell-nix // {
    custom-tools = super.haskell-nix.custom-tools // extra-custom-tools;
  };

  haskell-hacknix = (super.haskell-hacknix or { }) // super.recurseIntoAttrs {
    inherit cabalProject;
    inherit shellFor;
    inherit cache;
    inherit lib;
  };
}
