self: super:

let

  # Build cabal-fmt from nixpkgs.haskellPackages for now.
  cabalFmtPackages = super.haskell.lib.properExtend super.haskellPackages
    (self: super: { Cabal = super.Cabal_3_0_0_0; });
  cabal-fmt =
    super.haskell.lib.justStaticExecutables cabalFmtPackages.cabal-fmt;

  ghcide = import ../pkgs/ghcide.nix {
    inherit (super) config lib stdenv pkgs haskell-nix localLib;
  };

  hie = import ../pkgs/hie.nix {
    inherit (super) config lib stdenv pkgs haskell-nix localLib;
  };

  hls = import ../pkgs/hls.nix {
    inherit (super) config lib stdenv pkgs haskell-nix localLib fetchFromGitHub;
  };

  # Needs a filename case fix on macOS.
  # ref:
  # https://github.com/tweag/ormolu/issues/470
  # https://github.com/srid/nix-config/commit/c53ee6cf632936bfb8db7f41f50fc9c79a747eb8
  macOSCaseNameFix = drv:
    super.haskell.lib.appendConfigureFlag drv
    "--ghc-option=-optP-Wno-nonportable-include-path";
  ormolu = macOSCaseNameFix (import super.localLib.sources.ormolu { }).ormolu;

  exeOnly = name:
    super.haskell-nix.haskellPackages.${name}.components.exes.${name};

  hlint = exeOnly "hlint";
  brittany = exeOnly "brittany";
  ghcid = exeOnly "ghcid";

  ## Convenience wrappers for `haskell-nix.cabalProject`s.
  #
  # These include any fixes needed for various haskell.nix issues.

  cabalProject = { ghc, name, src, subdir ? null, extraModules ? [ ]
    , pkg-def-extras ? [ ], profiling ? false }:
    super.haskell-nix.cabalProject {
      inherit ghc src name subdir pkg-def-extras;
      modules = [
        # Workaround for doctest. See:
        # https://github.com/input-output-hk/haskell.nix/issues/221
        { reinstallableLibGhc = true; }
        { enableLibraryProfiling = profiling; }
      ] ++ extraModules;
    };

  cabalProject865 = { src, name, subdir ? null, extraModules ? [ ]
    , pkg-def-extras ? [ ], profiling ? false, }:
    cabalProject {
      inherit src name subdir extraModules pkg-def-extras profiling;
      ghc = super.haskell-nix.compiler.ghc865;
    };

  cabalProject883 = { src, name, subdir ? null, extraModules ? [ ]
    , pkg-def-extras ? [ ], profiling ? false, }:
    cabalProject {
      inherit src name subdir extraModules pkg-def-extras profiling;
      ghc = super.haskell-nix.compiler.ghc883;
    };

  # Add some useful tools to a `shellFor`, and make it buildable on a
  # Hydra.
  shellFor = compiler:
    { haskellPackages, baseName, packages, buildInputs ? [ ] }:
    haskellPackages.${compiler}.shellFor {
      inherit packages;
      name = "${baseName}-shell-${compiler}";
      buildInputs = [
        super.haskell-nix.cabal-install
        cabal-fmt
        hlint
        brittany
        ghcid
        ormolu
        hie.${compiler}.haskell-ide-engine.components.exes.hie
        hie.${compiler}.haskell-ide-engine.components.exes.hie-wrapper
        hls.${compiler}.haskell-language-server.components.exes.haskell-language-server
        hls.${compiler}.haskell-language-server.components.exes.haskell-language-server-wrapper

        # We could build this with haskell.nix, but it's not really
        # updated anymore, so why bother?
        (super.haskell.lib.justStaticExecutables
          super.haskellPackages.structured-haskell-mode)
      ] ++ buildInputs;

      # Help haskell-ide-engine find our Hoogle database. See:
      # https://github.com/input-output-hk/haskell.nix/issues/529
      shellHook = ''
        export HIE_HOOGLE_DATABASE="$(cat $(${super.which}/bin/which hoogle) | sed -n -e 's|.*--database \(.*\.hoo\).*|\1|p')"
      '';
      meta.platforms = super.lib.platforms.unix;
    };

  ## GHC version-specific tools.
  ghc865 = super.recurseIntoAttrs {
    inherit (hie.ghc865.haskell-ide-engine.components.exes) hie hie-wrapper;
    inherit (hls.ghc865.haskell-language-server.components.exes)
      haskell-language-server haskell-language-server-wrapper;
    shellFor = shellFor "ghc865";
  };

  ghc883 = super.recurseIntoAttrs {
    inherit (hie.ghc883.haskell-ide-engine.components.exes) hie hie-wrapper;
    inherit (hls.ghc883.haskell-language-server.components.exes)
      haskell-language-server haskell-language-server-wrapper;
    shellFor = shellFor "ghc883";
  };

  # An alias for `withInputs` that describes what we use it for.
  cache = super.haskell-nix.withInputs;

in {
  haskell-hacknix = (super.haskell-hacknix or { }) // super.recurseIntoAttrs {
    inherit ghc865 ghc883;

    inherit (super.haskell-nix) cabal-install;
    inherit hlint brittany ghcid ormolu;

    inherit cabalProject cabalProject865 cabalProject883;

    inherit shellFor;

    inherit cache;
  };
}
