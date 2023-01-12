{
  dart = false;
  go = false;
  haskell = false;
  lua = true;
  nix = true;
  rust = {
    enable = true;
    # TODO: Define as list and serialize to lua
    rustfmt.extraArgs = ''
      {
          "--config",
          "imports_granularity=Module",
          "--config",
          "group_imports=StdExternalCrate",
      }
    '';
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
