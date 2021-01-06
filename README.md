# haskell-hacknix

A collection of useful
[haskell.nix](https://github.com/input-output-hk/haskell.nix)
utilities, in the form of a Nixpkgs overlay.

## Updating materialized Nix files

At the moment, when we want to bump the Hackage index and update the
[materialized Nix
files](https://input-output-hk.github.io/haskell.nix/tutorials/materialization/),
we just `rm -r nix/materialized/*/*` and then rebuild each package
target, which will produce errors like this:

```
build of '/nix/store/66jc2bi1k3a6xhllq5hfaj2bsm6m3sfm-hhp-plan-to-nix-pkgs.drv' on 'ssh://remote-builder@builder-b.prod.dev.hackworth-corp.com' failed: error: --- Error --- nix-daemon
builder for '/nix/store/66jc2bi1k3a6xhllq5hfaj2bsm6m3sfm-hhp-plan-to-nix-pkgs.drv' failed with exit code 1; last 1 log lines:
  Materialized nix used for hhp-plan-to-nix-pkgs is missing. To fix run: /nix/store/gad6wh7a5981nghv6dlva2dx0smf1z3s-updateMaterialized
```

However, the script that's recommended in the error message will try
to write to the Nix store, so you'll need to inspect it and run the
inner script with a target of `./nix/materialized/...`, instead. For
example:

```
building '/nix/store/1f2pfmm9sb4k45mr6351x8rwiqnr4lfl-hhp-plan-to-nix-pkgs.drv'...
Materialized nix used for hhp-plan-to-nix-pkgs is missing. To fix run: /nix/store/kfv30x56hjczs3mgciqqykqj32yzkirw-updateMaterialized
error: --- Error ---------------------------------------------------------------------------------------------------------------------------------------------------------------- nix-build
builder for '/nix/store/1f2pfmm9sb4k45mr6351x8rwiqnr4lfl-hhp-plan-to-nix-pkgs.drv' failed with exit code 1; last 1 log lines:
  Materialized nix used for hhp-plan-to-nix-pkgs is missing. To fix run: /nix/store/kfv30x56hjczs3mgciqqykqj32yzkirw-updateMaterialized
(use '--show-trace' to show detailed location information)

 cat /nix/store/kfv30x56hjczs3mgciqqykqj32yzkirw-updateMaterialized
#!/nix/store/x3qxqv9sc175rjh94nj5rikls8mhlnyf-bash-4.4-p23/bin/bash
/nix/store/wskk9h47glacydhbyv1iwp71f260rnk7-generateMaterialized /nix/store/3bxdgyi2i5vs1iymx8a7mn1qira984r3-source/nix/materialized/ghc-8.6.5-x86_64-darwin/hhp

 /nix/store/wskk9h47glacydhbyv1iwp71f260rnk7-generateMaterialized
nix/materialized/ghc-8.6.5-x86_64-darwin/hhp

 git add nix/materialized/ghc-8.6.5-x86_64-darwin/hhp
```

We really need to automate this, or at least make the generated
scripts write to the proper location in the repo and not the Nix
store. See https://github.com/hackworthltd/haskell-hacknix/issues/72

