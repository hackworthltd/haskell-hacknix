{ lib
, localLib
, stdenv
, pkgs
, haskell-nix
, config ? {}
, profiling ? config.haskellNix.profiling or false
}:

let

  pkgSet = compiler:
    let
      ghc = haskell-nix.compiler.${compiler};

      stackYaml =
        if compiler == "ghc865" then "stack-8.6.5.yaml"
        else if compiler == "ghc883" then "stack.yaml"
        else abort "ghcide: unsupported compiler ${compiler}";
    in
      haskell-nix.stackProject {
        src = localLib.sources.haskell-ide-engine;
        inherit stackYaml;

        pkg-def-extras = [
          (hackage: {
            packages = {
              "haskell-lsp" = hackage.haskell-lsp."0.20.0.1".revisions.default;
            };
          })
        ];

        modules = [{
          ghc.package = ghc;
          compiler.version = pkgs.lib.mkForce ghc.version;
          enableLibraryProfiling = profiling;

          packages.ghc.flags.ghci = pkgs.lib.mkForce true;
          packages.ghci.flags.ghci = pkgs.lib.mkForce true;
          reinstallableLibGhc = true;
    }];
  };

in
{
  ghc865 = pkgSet "ghc865";
  ghc883 = pkgSet "ghc883";
}
