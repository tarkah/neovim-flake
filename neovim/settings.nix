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
    # TODO: Define as list and serialize to lua
    checkOnSave.overrideCommand = ''

      {
          "cargo",
          "clippy",
          "--all",
          "--message-format=json",
          "--",
          "-A", "clippy::too_many_arguments",
          "-A", "clippy::large_enum_variant",
          "-A", "clippy::inherent_to_string",
          "-A", "clippy::result_unit_err",
          "-A", "clippy::module_inception",
          "-A", "clippy::should_implement_trait",
          "-A", "clippy::mutable_key_type",
          "-A", "clippy::from_over_into",
          "-A", "clippy::enum_variant_names",
          "-A", "clippy::type_complexity",
          "-A", "clippy::upper_case_acronyms",
          "-A", "clippy::redundant_closure",
          "-A", "clippy::many-single-char-names",
          "-A", "clippy::obfuscated_if_else",
          "-A", "clippy::result_large_err",
      }
    '';
  };
  svelte = false;
  typescript = false;
}
