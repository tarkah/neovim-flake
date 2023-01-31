{
  lib,
  callPackage,
  settings ? {},
  ...
}:
callPackage ./builder.nix {settings = lib.recursiveUpdate (import ./settings.nix) settings;}
