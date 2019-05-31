# This file contains the package set used by the release.nix jobset.
#
# It is separate from default.nix because that file is the public API
# of Haskell.nix, which shouldn't have tests, etc.

{ pkgs ? import nixpkgs nixpkgsArgs
, nixpkgs ? ./nixpkgs
# Provide args to the nixpkgs instantiation.
, system ? builtins.currentSystem
, crossSystem ? null
, config ? {}
, nixpkgsArgs ? { inherit system crossSystem config; }
}:

let
  haskell = import ./default.nix { inherit pkgs; };

in {
  inherit (haskell) nix-tools;
  tests = import ./test/default.nix { inherit haskell; };

  # Scripts for keeping Hackage and Stackage up to date.
  maintainer-scripts = {
    update-hackage = haskell.callPackage ./scripts/update-hackage.nix {};
    update-stackage = haskell.callPackage ./scripts/update-stackage.nix {};
    update-pins = haskell.callPackage ./scripts/update-pins.nix {};
  };
}
