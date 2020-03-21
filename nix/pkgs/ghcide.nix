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
        if compiler == "ghc865" then "stack.yaml"
        else if compiler == "ghc883" then "stack88.yaml"
        else abort "ghcide: unsupported compiler ${compiler}";
    in
      haskell-nix.stackProject {
        src = localLib.sources.ghcide;
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

          # Workaround for doctest. See:
          # https://github.com/input-output-hk/haskell.nix/issues/221
          reinstallableLibGhc = true;

          # This fixes a performance issue, probably https://gitlab.haskell.org/ghc/ghc/issues/15524
          packages.ghcide.configureFlags = [ "--enable-executable-dynamic" ];
    }];
  };

in
{
  ghc865 = pkgSet "ghc865";
  ghc883 = pkgSet "ghc883";
}
