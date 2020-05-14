{ pkgs }:
let
  inherit (pkgs.lib.hacknix.haskellLib)
    collectTests collectChecks filterByPrefix;

  inherit (pkgs.haskell-hacknix)
    cabalProject cache shellFor;

  hhpSrc = pkgs.gitignoreSource ../.;

  mkHhpPackages = { profiling ? false }: pkgs.recurseIntoAttrs {
    ghc865 = cabalProject {
      ghc = pkgs.haskell-nix.compiler.ghc865;
      src = hhpSrc;
      subdir = "hhp";
      enableLibraryProfiling = profiling;
      enableExecutableProfiling = profiling;
    };
    ghc883 = cabalProject {
      ghc = pkgs.haskell-nix.compiler.ghc865;
      src = hhpSrc;
      subdir = "hhp";
      enableLibraryProfiling = profiling;
      enableExecutableProfiling = profiling;
      pkg-def-extras =
        [ (hackage: { alex = hackage.alex."3.2.5".revisions.default; }) ];
    };
  };

  isHhpPackage = filterByPrefix "hhp";

  hhpPackages = mkHhpPackages { };
  hhpPackagesProfiled = mkHhpPackages { profiling = true; };

  haskellPackages = hhpPackages.ghc865;
  shell = shellFor haskellPackages { };
  cachedShell = cache shell;

  haskellPackagesProfiled = hhpPackagesProfiled.ghc865;
  shellProfiled = shellFor haskellPackagesProfiled { };
  cachedShellProfiled = cache shellProfiled;

  haskellPackages883 = hhpPackages.ghc883;
  shell883 = shellFor haskellPackages883 { };
  cachedShell883 = cache shell883;

  haskellPackages883Profiled = hhpPackagesProfiled.ghc883;
  shell883Profiled = shellFor haskellPackages883Profiled { };
  cachedShell883Profiled = cache shell883Profiled;

  self = {
    ## GHC 8.6.5.
    inherit haskellPackages shell;
    inherit haskellPackagesProfiled shellProfiled;

    # The test suites of our packages.
    tests = collectTests isHhpPackage haskellPackages;

    # The results of executing the tests.
    checks = collectChecks isHhpPackage haskellPackages;

    ## GHC 8.8.3.
    inherit haskellPackages883 shell883;
    inherit haskellPackages883Profiled shell883Profiled;

    tests883 = collectTests isHhpPackage haskellPackages883;
    checks883 = collectChecks isHhpPackage haskellPackages883;

    # Help with IFD caching.
    inherit cachedShell cachedShellProfiled;
    inherit cachedShell883 cachedShell883Profiled;
  };
in
self
