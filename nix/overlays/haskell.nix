self: super:
let
  hie = args:
    let
      compiler = args.compiler-nix-name or (
        if args.ghc.version == "8.6.5" then "ghc865" else if args.ghc.version == "8.8.3" then "ghc883" else abort "haskell-ide-engine: unsupported GHC version ${args.ghc.version}"
      );
      stackYaml =
        if compiler == "ghc865" then
          "stack-8.6.5.yaml"
        else if compiler == "ghc883" then
          "stack.yaml"
        else
          abort "haskell-ide-engine: unsupported GHC version ${compiler}";
    in
    (super.haskell-nix.stackProject (args // {
      name = "haskell-ide-engine";
      src = super.localLib.sources.haskell-ide-engine;
      inherit stackYaml;
      pkg-def-extras = [
        (hackage: {
          packages = {
            "haskell-lsp" = hackage.haskell-lsp."0.20.0.1".revisions.default;
          };
        })
      ];

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
    let
      compiler = args.compiler-nix-name or (
        if args.ghc.version == "8.6.5" then "ghc865" else if args.ghc.version == "8.8.3" then "ghc883" else abort "haskell-ide-engine: unsupported GHC version ${args.ghc.version}"
      );
      stackYaml =
        if compiler == "ghc865" then
          "stack-8.6.5.yaml"
        else if compiler == "ghc883" then
          "stack-8.8.3.yaml"
        else
          abort "haskell-language-server: unsupported GHC version ${compiler}";
    in
    (super.haskell-nix.stackProject (args // {
      name = "haskell-language-server";

      # We need this until niv supports fetching git submodules.
      src = super.fetchFromGitHub {
        owner = "haskell";
        repo = "haskell-language-server";
        rev = "019b02831595b6a3be6776bfc56060ab918876e7";
        sha256 = "1b0zlnmd43gzpz6dibpgczwq82vqj4yk3wb4q64dwkpyp3v7hi1x";
        fetchSubmodules = true;
      };
      inherit stackYaml;

      pkg-def-extras = [
        (
          hackage: {
            packages = {
              "haskell-lsp" = hackage.haskell-lsp."0.21.0.0".revisions.default;
            };
          }
        )
      ];

      modules = [
        ({ config, ... }: {
          packages.ghc.flags.ghci = super.lib.mkForce true;
          packages.ghci.flags.ghci = super.lib.mkForce true;
          reinstallableLibGhc = true;
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

  # Helper executables that are GHC-independent.
  exeOnly = name:
    super.haskell-nix.haskellPackages.${name}.components.exes.${name};
  brittany = exeOnly "brittany";

  # Helper executables that are GHC-independent, but not included in
  # the haskell.nix package set.
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
          ] else [ ]
        );
    });

  # Add some useful tools to a `shellFor`, and make it buildable on a
  # Hydra.
  shellFor = hp: { ... }@args:
    hp.shellFor (args // {
      tools = {
        cabal = "3.2.0.0";
        hlint = "3.1";
        ghcid = "0.8.6";
        ormolu = "0.0.5.0";
        hie = "latest";
        hie-wrapper = "latest";
        hls = "latest";
        hls-wrapper = "latest";
      } // (args.tools or { });

      buildInputs = [
        cabal-fmt
        brittany

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
in
{
  haskell-nix = super.haskell-nix // {
    custom-tools = super.haskell-nix.custom-tools // extra-custom-tools;
  };

  haskell-hacknix = (super.haskell-hacknix or { }) // super.recurseIntoAttrs {
    inherit cabalProject;
    inherit shellFor;
    inherit cache;
  };
}
