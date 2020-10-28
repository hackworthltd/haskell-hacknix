{
  extras = hackage:
    {
      packages = {
        "aeson" = (((hackage.aeson)."1.5.2.0").revisions).default;
        "ansi-terminal" = (((hackage.ansi-terminal)."0.10.3").revisions).default;
        "base-compat" = (((hackage.base-compat)."0.10.5").revisions).default;
        "butcher" = (((hackage.butcher)."1.3.3.1").revisions).default;
        "Cabal" = (((hackage.Cabal)."3.0.2.0").revisions).default;
        "cabal-plan" = (((hackage.cabal-plan)."0.6.2.0").revisions).default;
        "clock" = (((hackage.clock)."0.7.2").revisions).default;
        "extra" = (((hackage.extra)."1.7.3").revisions).default;
        "floskell" = (((hackage.floskell)."0.10.4").revisions).default;
        "fourmolu" = (((hackage.fourmolu)."0.2.0.0").revisions).default;
        "fuzzy" = (((hackage.fuzzy)."0.1.0.0").revisions).default;
        "ghc-check" = (((hackage.ghc-check)."0.5.0.1").revisions).default;
        "ghc-exactprint" = (((hackage.ghc-exactprint)."0.6.2").revisions).default;
        "ghc-lib-parser" = (((hackage.ghc-lib-parser)."8.10.2.20200808").revisions).default;
        "ghc-lib-parser-ex" = (((hackage.ghc-lib-parser-ex)."8.10.0.16").revisions).default;
        "ghc-source-gen" = (((hackage.ghc-source-gen)."0.4.0.0").revisions).default;
        "haddock-library" = (((hackage.haddock-library)."1.8.0").revisions).default;
        "haskell-lsp" = (((hackage.haskell-lsp)."0.22.0.0").revisions).default;
        "haskell-lsp-types" = (((hackage.haskell-lsp-types)."0.22.0.0").revisions).default;
        "hie-bios" = (((hackage.hie-bios)."0.7.1").revisions).default;
        "indexed-profunctors" = (((hackage.indexed-profunctors)."0.1").revisions).default;
        "lens" = (((hackage.lens)."4.18").revisions).default;
        "lsp-test" = (((hackage.lsp-test)."0.11.0.5").revisions).default;
        "monad-dijkstra" = (((hackage.monad-dijkstra)."0.1.1.2").revisions).default;
        "opentelemetry" = (((hackage.opentelemetry)."0.4.2").revisions).default;
        "optics-core" = (((hackage.optics-core)."0.2").revisions).default;
        "optparse-applicative" = (((hackage.optparse-applicative)."0.15.1.0").revisions).default;
        "ormolu" = (((hackage.ormolu)."0.1.3.0").revisions).default;
        "parser-combinators" = (((hackage.parser-combinators)."1.2.1").revisions).default;
        "primitive" = (((hackage.primitive)."0.7.1.0").revisions).default;
        "refinery" = (((hackage.refinery)."0.2.0.0").revisions).default;
        "regex-base" = (((hackage.regex-base)."0.94.0.0").revisions).default;
        "regex-pcre-builtin" = (((hackage.regex-pcre-builtin)."0.95.1.1.8.43").revisions).default;
        "regex-tdfa" = (((hackage.regex-tdfa)."1.3.1.0").revisions).default;
        "retrie" = (((hackage.retrie)."0.1.1.1").revisions).default;
        "semialign" = (((hackage.semialign)."1.1").revisions).default;
        "stylish-haskell" = (((hackage.stylish-haskell)."0.12.2.0").revisions).default;
        "tasty-rerun" = (((hackage.tasty-rerun)."1.1.17").revisions).default;
        "temporary" = (((hackage.temporary)."1.2.1.1").revisions).default;
        "these" = (((hackage.these)."1.1.1.1").revisions).default;
        "type-equality" = (((hackage.type-equality)."1").revisions).default;
        "topograph" = (((hackage.topograph)."1").revisions).default;
        "implicit-hie-cradle" = (((hackage.implicit-hie-cradle)."0.2.0.1").revisions).default;
        "implicit-hie" = (((hackage.implicit-hie)."0.1.1.0").revisions).default;
        "haddock-api" = (((hackage.haddock-api)."2.22.0").revisions).r1;
        "HsYAML" = (((hackage.HsYAML)."0.2.1.0").revisions).r1;
        "HsYAML-aeson" = (((hackage.HsYAML-aeson)."0.2.0.0").revisions).r2;
        haskell-language-server = ./haskell-language-server.nix;
        ghcide = ./ghcide.nix;
        hls-plugin-api = ./hls-plugin-api.nix;
        brittany = ./.stack-to-nix.cache.0;
        };
      };
  resolver = "lts-14.27";
  modules = [
    ({ lib, ... }:
      {
        packages = {
          "haskell-language-server" = {
            flags = { "pedantic" = lib.mkOverride 900 true; };
            };
          "retrie" = {
            flags = { "BuildExecutable" = lib.mkOverride 900 false; };
            };
          };
        })
    {
      packages = {
        "$everything" = { package = { ghcOptions = "-haddock"; }; };
        };
      }
    ];
  }