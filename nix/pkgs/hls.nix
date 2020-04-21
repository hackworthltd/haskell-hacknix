{ lib, localLib, stdenv, fetchFromGitHub, pkgs, haskell-nix, config ? { }
, enableLibraryProfiling ? false, enableExecutableProfiling ? false }:

let

  src = fetchFromGitHub {
    owner = "haskell";
    repo = "haskell-language-server";
    rev = "ff578b80ce8cf7e4ec5f794be5915ec5bcde7e0e";
    sha256 = "0pz8gv027ah2j52p0ydcwwz5b34bmr09d8h7yxvq0v3hpyl51pbr";
    fetchSubmodules = true;
  };

  pkgSet = compiler:
    let
      ghc = haskell-nix.compiler.${compiler};

      stackYaml = if compiler == "ghc865" then
        "stack-8.6.5.yaml"
      else if compiler == "ghc883" then
        "stack-8.8.3.yaml"
      else
        abort "ghcide: unsupported compiler ${compiler}";
    in haskell-nix.stackProject {
      inherit src;
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
        inherit enableLibraryProfiling enableExecutableProfiling;

        packages.ghc.flags.ghci = pkgs.lib.mkForce true;
        packages.ghci.flags.ghci = pkgs.lib.mkForce true;
        reinstallableLibGhc = true;
        packages.ghcide.configureFlags = [ "--enable-executable-dynamic" ];

        # Haddock on haddock-api is broken :\
        packages.haddock-api.components.library.doHaddock = lib.mkForce false;
      }];
    };

in {
  ghc865 = pkgSet "ghc865";
  ghc883 = pkgSet "ghc883";
}
