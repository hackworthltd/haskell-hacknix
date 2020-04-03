{ lib
, localLib
, stdenv
, fetchFromGitHub
, pkgs
, haskell-nix
, config ? {}
, profiling ? config.haskellNix.profiling or false
}:

let

  src = fetchFromGitHub {
    owner = "hackworthltd";
    repo = "haskell-language-server";
    rev = "25f3047bf8d08fbdfaeb3911d807b3d59b70a669";
    sha256 = "05gby75n63njd097a67nkhviw3d962hfch6j4v9820anan84zgkk";
    fetchSubmodules = true;
  };

  pkgSet = compiler:
    let
      ghc = haskell-nix.compiler.${compiler};

      stackYaml =
        if compiler == "ghc865" then "stack-8.6.5.yaml"
        else if compiler == "ghc883" then "stack-8.8.3.yaml"
        else abort "ghcide: unsupported compiler ${compiler}";
    in
      haskell-nix.stackProject {
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
          enableLibraryProfiling = profiling;

          packages.ghc.flags.ghci = pkgs.lib.mkForce true;
          packages.ghci.flags.ghci = pkgs.lib.mkForce true;
          reinstallableLibGhc = true;
          packages.ghcide.configureFlags = [ "--enable-executable-dynamic" ];
    }];
  };

in
{
  ghc865 = pkgSet "ghc865";
  ghc883 = pkgSet "ghc883";
}
