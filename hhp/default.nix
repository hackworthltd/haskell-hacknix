{ pkgs }:

let

  inherit (pkgs.lib.hacknix.haskellLib)
    cleanSource collectTests collectChecks filterByPrefix;
  inherit (pkgs.haskell-hacknix)
    ghc865 ghc883 cache cabalProject865 cabalProject883;

  hhpSrc = pkgs.gitignoreSource ../.;

  mkHhpPackages = { profiling ? false }: pkgs.recurseIntoAttrs {
    ghc865 = cabalProject865 {
      src = hhpSrc;
      subdir = "hhp";
      name = "hhp";
      enableLibraryProfiling = profiling;
      enableExecutableProfiling = profiling;
    };
    ghc883 = cabalProject883 {
      src = hhpSrc;
      subdir = "hhp";
      name = "hhp";
      enableLibraryProfiling = profiling;
      enableExecutableProfiling = profiling;
      pkg-def-extras =
        [ (hackage: { alex = hackage.alex."3.2.5".revisions.default; }) ];
    };
  };

  hhpShell = pkgs: {
    haskellPackages = pkgs;
    baseName = "hhp";
    packages = ps: with ps; [ hhp ];
  };

  hhpPackage = filterByPrefix "hhp";

  hhpPackages = mkHhpPackages {};
  hhpPackagesProfiled = mkHhpPackages { profiling = true; };

  haskellPackages = hhpPackages.ghc865;
  shell = ghc865.shellFor (hhpShell hhpPackages);
  cachedShell = cache shell;

  haskellPackagesProfiled = hhpPackagesProfiled.ghc865;
  shellProfiled = ghc865.shellFor (hhpShell hhpPackagesProfiled);
  cachedShellProfiled = cache shellProfiled;

  haskellPackages883 = hhpPackages.ghc883;
  shell883 = ghc883.shellFor (hhpShell hhpPackages);
  cachedShell883 = cache shell883;

  haskellPackages883Profiled = hhpPackagesProfiled.ghc883;
  shell883Profiled = ghc883.shellFor (hhpShell hhpPackagesProfiled);
  cachedShell883Profiled = cache shell883Profiled;

  self = {
    ## GHC 8.6.5.
    inherit haskellPackages shell;
    inherit haskellPackagesProfiled shellProfiled;

    # The test suites of our packages.
    tests = collectTests hhpPackage haskellPackages;

    # The results of executing the tests.
    checks = collectChecks hhpPackage haskellPackages;

    ## GHC 8.8.3.
    inherit haskellPackages883 shell883;
    inherit haskellPackages883Profiled shell883Profiled;

    tests883 = collectTests hhpPackage haskellPackages883;
    checks883 = collectChecks hhpPackage haskellPackages883;

    # Help with IFD caching.
    inherit cachedShell cachedShellProfiled;
    inherit cachedShell883 cachedShell883Profiled;
  };

in self
