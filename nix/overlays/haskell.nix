self: super:
let
  # Helper executables that need to be compiled with the same version
  # of GHC as the project where they're used.
  #
  # These are all bleeding-edge, so we compile them from their GitHub
  # repos for now.
  hie = import ../pkgs/hie.nix {
    inherit (super) pkgs haskell-nix localLib;
  };
  hls = import ../pkgs/hls.nix {
    inherit (super) pkgs haskell-nix localLib fetchFromGitHub;
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
    { enableLibraryProfiling ? false
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
    });

  # Add some useful tools to a `shellFor`, and make it buildable on a
  # Hydra.
  shellFor = compiler: hp:
    { ... }@args:
    hp.shellFor (args // {
      tools = {
        cabal = "3.2.0.0";
        hlint = "3.1";
        ghcid = "0.8.6";
        ormolu = "0.0.5.0";
      } // (args.tools or { });
      buildInputs = [
        cabal-fmt
        brittany
        hie.${compiler}.haskell-ide-engine.components.exes.hie
        hie.${compiler}.haskell-ide-engine.components.exes.hie-wrapper
        hls.${compiler}.haskell-language-server.components.exes.haskell-language-server
        hls.${compiler}.haskell-language-server.components.exes.haskell-language-server-wrapper

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

  ## GHC version-specific tools.
  ghc865 = super.recurseIntoAttrs {
    cabalProject = { ... }@args:
      cabalProject (args // {
        ghc = super.haskell-nix.compiler.ghc865;
      });

    shellFor = shellFor "ghc865";
  };
  ghc883 = super.recurseIntoAttrs {
    cabalProject = { ... }@args:
      cabalProject (args // {
        ghc = super.haskell-nix.compiler.ghc883;
      });

    shellFor = shellFor "ghc883";
  };

  # An alias for `withInputs` that describes what we use it for.
  cache = super.haskell-nix.withInputs;
in
{
  haskell-hacknix = (super.haskell-hacknix or { }) // super.recurseIntoAttrs {
    inherit ghc865 ghc883;

    inherit brittany;

    inherit cabalProject;

    inherit shellFor;

    inherit cache;
  };
}
