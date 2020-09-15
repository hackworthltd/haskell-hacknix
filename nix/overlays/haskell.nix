self: super:
let
  hls = args:
    (super.haskell-nix.project (args // {
      name = "haskell-language-server";

      # We need this until niv supports fetching git submodules, as
      # hls has its own ghcide submodule.
      src = super.fetchFromGitHub {
        owner = "haskell";
        repo = "haskell-language-server";
        rev = "0.4.0";
        sha256 = "0b94l6bywa6jk20y2cswyq5ks4g515895k2apvr1mdfkfhngdb7b";
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
    (super.haskell-nix.cabalProject (args // {
      name = "cabal-fmt";
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

  extra-custom-tools = {
    hls.latest = args: (hls args).haskell-language-server.components.exes.haskell-language-server;
    hls-wrapper.latest = args: (hls args).haskell-language-server.components.exes.haskell-language-server-wrapper;
    cabal-fmt.latest = args: (cabal-fmt args).cabal-fmt.components.exes.cabal-fmt;
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

      buildInputs = [
        # These tools are GHC-independent, so we use whichever version
        # of GHC works best.
        (super.haskell-nix.tool "ghc884" "brittany" "0.12.1.1")
        (super.haskell-nix.tool "ghc884" "cabal" "3.2.0.0")
        (super.haskell-nix.tool "ghc8101" "cabal-fmt" "latest")
        (super.haskell-nix.tool "ghc884" "hlint" "3.1.6")
        (super.haskell-nix.tool "ghc884" "ormolu" "0.1.2.0")
        (super.haskell-nix.tool "ghc8101" "cabal-edit" "0.1.0.0")

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
