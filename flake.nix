{
  description = "Hackworth Ltd's haskell.nix overlay.";

  inputs = {
    hacknix.url = github:hackworthltd/hacknix;
    nixpkgs.follows = "hacknix/nixpkgs";
    haskell-nix.url = github:hackworthltd/haskell.nix/flakes-fixes-v3;
    haskell-nix.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = github:numtide/flake-utils;

    flake-compat.url = github:edolstra/flake-compat;
    flake-compat.flake = false;

    cabal-fmt.url = github:phadej/cabal-fmt;
    cabal-fmt.flake = false;

    purescript.url = github:purescript/purescript/v0.13.8;
    purescript.flake = false;

    hydra.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { self
    , nixpkgs
    , hacknix
    , haskell-nix
    , flake-utils
    , ...
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];
      forAllSupportedSystems = hacknix.lib.flakes.forAllSystems supportedSystems;

      testSystems = [
        "x86_64-linux"
      ];
      forAllTestSystems = hacknix.lib.flakes.forAllSystems testSystems;

      config = {
        allowUnfree = true;
        allowBroken = true;
      };

      # Memoize nixpkgs for a given system.
      #
      # Note: we use the haskell.nix nixpkgs here, as we want to take
      # advantage of their cachix cache.
      pkgsFor = forAllSupportedSystems (system:
        import nixpkgs {
          inherit system config;
          overlays = [ self.overlay ];
        }
      );

      hhpFor = forAllSupportedSystems
        (system:
          let
            pkgs = pkgsFor.${system};
          in
          flake-utils.lib.flattenTree {
            ghc865 = pkgs.callPackage ./hhp {
              compiler-nix-name = "ghc865";
            };
            ghc865-profiled = pkgs.callPackage ./hhp {
              compiler-nix-name = "ghc865";
              profiled = true;
            };
            ghc884 = pkgs.callPackage ./hhp {
              compiler-nix-name = "ghc884";
            };
            ghc884-profiled = pkgs.callPackage ./hhp {
              compiler-nix-name = "ghc884";
              profiled = true;
            };
            ghc8103 = pkgs.callPackage ./hhp {
              compiler-nix-name = "ghc8103";
            };
            ghc8103-profiled = pkgs.callPackage ./hhp {
              compiler-nix-name = "ghc8103";
              profiled = true;
            };
          }
        );

      devShell = forAllSupportedSystems
        (system:
          let
            hhp = hhpFor.${system};
          in
          hhp."ghc8103/shell"
        );

    in
    {
      lib = pkgsFor.x86_64-linux.lib;

      overlay =
        let
          overlaysFromDir = hacknix.lib.overlays.combineFromDir ./nix/overlays;
        in
        hacknix.lib.overlays.combine [
          haskell-nix.overlay
          overlaysFromDir
          (final: prev: {
            lib = (prev.lib or { }) // {
              haskell-hacknix = (prev.lib.haskell-hacknix or { }) // {
                flake = (prev.lib.haskell-hacknix.flake or { }) // {
                  inherit inputs;
                };
              };
            };
          })
        ];

      packages = forAllSupportedSystems
        (system:
          let
            pkgs = pkgsFor.${system};
            roots = pkgs.recurseIntoAttrs
              {
                ghc865 = pkgs.haskell-nix.roots "ghc865";
                ghc884 = pkgs.haskell-nix.roots "ghc884";
                ghc8103 = pkgs.haskell-nix.roots "ghc8103";
              };
          in
          flake-utils.lib.flattenTree roots
          // flake-utils.lib.flattenTree pkgs.haskell-hacknix
        );

      inherit devShell;

      hydraJobs = {
        build = self.packages;
        hhp = hhpFor;
      };
    };
}
