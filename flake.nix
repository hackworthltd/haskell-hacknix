{
  description = "Hackworth Ltd's haskell.nix overlay.";

  inputs = {
    nixpkgs.url = github:hackworthltd/nixpkgs/big-sur-fixes-v4;
    hacknix-lib.url = github:hackworthltd/hacknix-lib;
    haskell-nix.url = github:hackworthltd/haskell.nix/flakes-fixes-v2;
    haskell-nix.inputs.nixpkgs.follows = "nixpkgs";

    flake-utils.url = github:numtide/flake-utils;

    flake-compat.url = github:edolstra/flake-compat;
    flake-compat.flake = false;

    cabal-fmt.url = github:phadej/cabal-fmt;
    cabal-fmt.flake = false;

    purescript.url = github:purescript/purescript/v0.13.8;
    purescript.flake = false;

    spago.url = github:hackworthltd/spago;
    spago.flake = false;
  };

  outputs =
    { self
    , hacknix-lib
    , haskell-nix
    , flake-utils
    , ...
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "x86_64-darwin"
      ];
      forAllSupportedSystems = hacknix-lib.lib.flakes.forAllSystems supportedSystems;

      testSystems = [
        "x86_64-linux"
      ];
      forAllTestSystems = hacknix-lib.lib.flakes.forAllSystems testSystems;

      config = {
        allowUnfree = true;
        allowBroken = true;
      };

      # Memoize nixpkgs for a given system.
      #
      # Note: we use the haskell.nix nixpkgs here, as we want to take
      # advantage of their cachix cache.
      pkgsFor = forAllSupportedSystems (system:
        import haskell-nix.inputs.nixpkgs {
          inherit system config;
          overlays = [ self.overlay ];
        }
      );

      hhpFor = forAllSupportedSystems (system:
        let
          pkgs = pkgsFor.${system};
        in
        import ./hhp/default.nix { inherit pkgs; }
      );

    in
    {
      lib = pkgsFor.x86_64-linux.lib;

      overlay =
        let
          overlaysFromDir = hacknix-lib.lib.overlays.combineFromDir ./nix/overlays;
        in
        hacknix-lib.lib.overlays.combine [
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
                ghc8102 = pkgs.haskell-nix.roots "ghc8102";
              };
            hhp = hhpFor.${system};
          in
          flake-utils.lib.flattenTree roots
          // flake-utils.lib.flattenTree pkgs.haskell-hacknix
          // flake-utils.lib.flattenTree hhp
        );

      devShell = forAllSupportedSystems
        (system:
          let
            hhp = hhpFor.${system};
          in
          hhp.ghc8102.shell
        );

      hydraJobs = {
        build = self.packages;
      };
    };
}
