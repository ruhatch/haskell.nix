{ supportedSystems ? [ "x86_64-linux" ] # spare our "x86_64-darwin" builders for now
, scrubJobs ? true
, src ? { outPath = ./.; rev = "abcdef"; }
, nixpkgsArgs ? {}
}:

let
  fixedNixpkgs = import ./nixpkgs {};
  inherit (fixedNixpkgs.pkgs.lib.systems.examples) musl64;
in

with (import (fixedNixpkgs.path + "/pkgs/top-level/release-lib.nix") {
  inherit supportedSystems scrubJobs nixpkgsArgs;
  packageSet = import (src + /build.nix);
});

{
  native = mapTestOn (packagePlatforms pkgs);
  "${musl64.config}" = mapTestOnCross musl64 (packagePlatforms pkgs);
}
