{
  extras = hackage:
    {
      packages = {
        "aeson" = (((hackage.aeson)."1.5.2.0").revisions).default;
        "apply-refact" = (((hackage.apply-refact)."0.7.0.0").revisions).default;
        "bytestring-trie" = (((hackage.bytestring-trie)."0.2.5.0").revisions).default;
        "cabal-helper" = (((hackage.cabal-helper)."1.1.0.0").revisions).default;
        "cabal-plan" = (((hackage.cabal-plan)."0.6.2.0").revisions).default;
        "clock" = (((hackage.clock)."0.7.2").revisions).default;
        "constrained-dynamic" = (((hackage.constrained-dynamic)."0.1.0.0").revisions).default;
        "extra" = (((hackage.extra)."1.7.3").revisions).default;
        "floskell" = (((hackage.floskell)."0.10.4").revisions).default;
        "fourmolu" = (((hackage.fourmolu)."0.2.0.0").revisions).default;
        "haskell-src-exts" = (((hackage.haskell-src-exts)."1.21.1").revisions).default;
        "hie-bios" = (((hackage.hie-bios)."0.7.1").revisions).default;
        "hlint" = (((hackage.hlint)."2.2.8").revisions).default;
        "hoogle" = (((hackage.hoogle)."5.0.17.11").revisions).default;
        "hsimport" = (((hackage.hsimport)."0.11.0").revisions).default;
        "ilist" = (((hackage.ilist)."0.3.1.0").revisions).default;
        "lsp-test" = (((hackage.lsp-test)."0.11.0.5").revisions).default;
        "monad-dijkstra" = (((hackage.monad-dijkstra)."0.1.1.2").revisions).default;
        "refinery" = (((hackage.refinery)."0.2.0.0").revisions).default;
        "retrie" = (((hackage.retrie)."0.1.1.1").revisions).default;
        "semigroups" = (((hackage.semigroups)."0.18.5").revisions).default;
        "stylish-haskell" = (((hackage.stylish-haskell)."0.12.2.0").revisions).default;
        "temporary" = (((hackage.temporary)."1.2.1.1").revisions).default;
        "ghc-exactprint" = (((hackage.ghc-exactprint)."0.6.3.2").revisions).default;
        "implicit-hie-cradle" = (((hackage.implicit-hie-cradle)."0.2.0.1").revisions).default;
        "implicit-hie" = (((hackage.implicit-hie)."0.1.1.0").revisions).default;
        haskell-language-server = ./haskell-language-server.nix;
        ghcide = ./ghcide.nix;
        hls-plugin-api = ./hls-plugin-api.nix;
        brittany = ./.stack-to-nix.cache.0;
        };
      };
  resolver = "lts-16.16";
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