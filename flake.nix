{
  description = "Hackworth Ltd's haskell.nix overlay.";

  inputs = {
    haskell-nix.url = github:hackworthltd/haskell.nix/flake-fixes-v6;
    nixpkgs.follows = "haskell-nix/nixpkgs";
    hacknix.url = github:hackworthltd/hacknix;
    hacknix.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = github:numtide/flake-utils;

    flake-compat.url = github:edolstra/flake-compat;
    flake-compat.flake = false;

    cabal-fmt.url = github:phadej/cabal-fmt;
    cabal-fmt.flake = false;
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
            ghc8104 = pkgs.callPackage ./hhp {
              compiler-nix-name = "ghc8104";
            };
            ghc8104-profiled = pkgs.callPackage ./hhp {
              compiler-nix-name = "ghc8104";
              profiled = true;
            };
          }
        );

      devShell = forAllSupportedSystems
        (system:
          let
            hhp = hhpFor.${system};
          in
          hhp."ghc8104/shell"
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
                ghc8104 = pkgs.haskell-nix.roots "ghc8104";
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
