{
  dart = false;
  go = false;
  haskell = false;
  lua = true;
  nix = true;
  rust = {
    enable = true;
    # TODO: Define as list and serialize to lua
    rustfmt.extraArgs = "{}";
    checkOnSave.overrideCommand = ''
      {
          "cargo",
          "clippy",
          "--all",
          "--message-format=json",
      }
    '';
  };
  svelte = false;
  typescript = false;
}
