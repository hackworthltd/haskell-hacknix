{ nixpkgs ? <nixpkgs>, declInput ? { } }:

let

  haskellHacknixUri = "https://github.com/hackworthltd/haskell-hacknix.git";

  mkFetchGithub = value: {
    inherit value;
    type = "git";
    emailresponsible = false;
  };

  pkgs = import nixpkgs { };

  defaultSettings = {
    enabled = 1;
    hidden = false;
    keepnr = 5;
    schedulingshares = 400;
    checkinterval = 60;
    enableemail = false;
    emailoverride = "";
    nixexprpath = "nix/jobsets/release.nix";
    nixexprinput = "haskell-hacknix";
    description = "Hackworth Ltd's haskell.nix helpers";
    inputs = { haskell-hacknix = mkFetchGithub "${haskellHacknixUri} master"; };
  };

  # These run less frequently, so that they don't interfere with
  # checkins on the master branch.
  mkHaskellNix = haskellNixBranch: {
    checkinterval = 60 * 60 * 24;
    inputs = {
      haskell-hacknix = mkFetchGithub "${haskellHacknixUri} master";
      haskell-nix = mkFetchGithub
        "https://github.com/input-output-hk/haskell.nix.git ${haskellNixBranch}";
    };
  };

  mainJobsets = with pkgs.lib;
    mapAttrs (name: settings: defaultSettings // settings) (rec {
      master = { };
      haskell-nix = mkHaskellNix "master";
    });

  jobsetsAttrs = mainJobsets;

  jobsetJson = pkgs.writeText "spec.json" (builtins.toJSON jobsetsAttrs);

in {
  jobsets = with pkgs.lib;
    pkgs.runCommand "spec.json" { } ''
      cat <<EOF
      ${builtins.toJSON declInput}
      EOF
      cp ${jobsetJson} $out
    '';
}
