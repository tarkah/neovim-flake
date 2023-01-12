{ callPackage
, settings ? { }
, ...
}:

callPackage ./builder.nix { settings = (import ./settings.nix // settings); }
