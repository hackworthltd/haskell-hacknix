{
  extras = hackage:
    {
      packages = {
        "aeson" = (((hackage.aeson)."1.5.2.0").revisions).default;
        "Cabal" = (((hackage.Cabal)."3.0.2.0").revisions).default;
        "clock" = (((hackage.clock)."0.7.2").revisions).default;
        "data-tree-print" = (((hackage.data-tree-print)."0.1.0.2").revisions).default;
        "floskell" = (((hackage.floskell)."0.10.4").revisions).default;
        "fourmolu" = (((hackage.fourmolu)."0.2.0.0").revisions).default;
        "monad-dijkstra" = (((hackage.monad-dijkstra)."0.1.1.2").revisions).default;
        "opentelemetry" = (((hackage.opentelemetry)."0.4.2").revisions).default;
        "refinery" = (((hackage.refinery)."0.2.0.0").revisions).default;
        "retrie" = (((hackage.retrie)."0.1.1.1").revisions).default;
        "stylish-haskell" = (((hackage.stylish-haskell)."0.12.2.0").revisions).default;
        "semigroups" = (((hackage.semigroups)."0.18.5").revisions).default;
        "temporary" = (((hackage.temporary)."1.2.1.1").revisions).default;
        "implicit-hie-cradle" = (((hackage.implicit-hie-cradle)."0.2.0.1").revisions).default;
        "implicit-hie" = (((hackage.implicit-hie)."0.1.1.0").revisions).default;
        "hie-bios" = (((hackage.hie-bios)."0.7.1").revisions).default;
        haskell-language-server = ./haskell-language-server.nix;
        ghcide = ./ghcide.nix;
        hls-plugin-api = ./hls-plugin-api.nix;
        brittany = ./.stack-to-nix.cache.0;
        };
      };
  resolver = "nightly-2020-10-03";
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