{ pkgs
}:

let

  inherit (pkgs.lib.hacknix.haskellLib) cleanSource collectTests collectChecks filterByPrefix;
  inherit (pkgs.haskell-hacknix) ghc865 ghc883 cache cabalProject865 cabalProject883;

  hhpSrc = cleanSource {
    src = ./.;
  };

  hhpPackages = pkgs.recurseIntoAttrs {
    ghc865 = pkgs.haskell-nix.cabalProject {
      src = pkgs.haskell-nix.haskellLib.cleanGit { src = ./.; };
      ghc = pkgs.haskell-nix.compiler.ghc865;
      modules = [
        {
          nonReinstallablePkgs =
             [ "rts" "ghc-heap" "ghc-prim" "integer-gmp" "integer-simple" "base"
               "deepseq" "array" "ghc-boot-th" "pretty" "template-haskell"
               "ghc-boot"
               "ghc" "Cabal" "Win32" "array" "binary" "bytestring" "containers"
               "directory" "filepath" "ghc-boot" "ghc-compact" "ghc-prim"
               "ghci" "haskeline"
               "hpc"
               "mtl" "parsec" "process" "text" "time" "transformers"
               "unix" "xhtml"
               "stm" "terminfo"
             ];

          packages.hhp.components.tests.doctests.isDoctest = true;
        }
      ];
    };

    ghc883 = cabalProject883 { src = hhpSrc; };
  };

  hhpShell = {
    haskellPackages = hhpPackages;
    baseName = "hhp";
    packages = ps: with ps; [
      hhp
    ];
  };

  hhpPackage = filterByPrefix "hhp";

  haskellPackages = hhpPackages.ghc865;
  shell = ghc865.shellFor hhpShell;
  cachedShell = cache shell;

  haskellPackages883 = hhpPackages.ghc883;
  shell883 = ghc883.shellFor hhpShell;
  cachedShell883 = cache shell883;

  self = {
    ## GHC 8.6.5.
    inherit haskellPackages shell;

    # The test suites of our packages.
    tests = collectTests hhpPackage haskellPackages;

    # The results of executing the tests.
    checks = collectChecks hhpPackage haskellPackages;


    ## GHC 8.8.3.
    #
    # Disabled until
    #
    # https://github.com/input-output-hk/haskell.nix/issues/440
    #
    # is fixed, or we switch to a Stack-based project.

    #inherit haskellPackages883 shell883;

    #tests883 = collectTests testPackage haskellPackages883;

    # The results of executing the tests.
    #checks883 = collectChecks testPackage haskellPackages883;



    # Help with IFD caching.
    inherit cachedShell;
    #inherit cachedShell883;
  };

in
self
