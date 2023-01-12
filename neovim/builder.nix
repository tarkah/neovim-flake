{ lib
, callPackage
, inputs
, neovim-unwrapped
, neovimUtils
, vimPlugins
, vimUtils
, wrapNeovimUnstable
, settings
, ...
}:

let
  buildPlugin = name:
    vimUtils.buildVimPluginFrom2Nix {
      pname = name;
      version = "master";
      src = builtins.getAttr name inputs;
    };

  wrapLua = s: ''
    lua << EOF
    ${s}
    EOF
  '';

  readLuaConfig = path: if builtins.pathExists path then wrapLua (builtins.readFile path) else null;

  buildConfig = name:
    let
      path = ext: ./../plugins/${name}.${ext};
      nixPath = path "nix";
      luaPath = path "lua";
      nix =
        if builtins.pathExists nixPath
        then wrapLua (callPackage nixPath { inherit settings; })
        else null;
      lua = if builtins.pathExists luaPath then readLuaConfig luaPath else null;
    in
    if nix != null then nix else lua;

  plugin = { name, config ? null, optional ? false }:
    let
      config' = if config != null then config else buildConfig name;
      plugin = with builtins;
        if name == "nvim-treesitter" then vimPlugins.nvim-treesitter.withAllGrammars
        else if hasAttr name inputs then buildPlugin name else getAttr name vimPlugins;
    in
    {
      inherit plugin optional;
      config = config';
    };

  plugins = map plugin [
    # LSP
    { name = "nvim-lspconfig"; config = buildConfig "lsp"; }
    { name = "rust-tools-nvim"; }
    { name = "null-ls-nvim"; }

    # Treesitter
    { name = "nvim-treesitter"; }

    # Theme
    # { name = "gruvbox-material"; config = readConfig ./plugins/colorscheme.lua; }
    # { name = "dracula-nvim"; config = readConfig ./plugins/colorscheme.lua; }
    { name = "nord-nvim"; config = readLuaConfig ./../plugins/colorscheme.lua; }

    # Completions
    { name = "nvim-cmp"; }
    { name = "cmp-nvim-lsp"; }
    { name = "cmp-buffer"; }
    { name = "cmp-path"; }
    { name = "cmp-cmdline"; }
    { name = "cmp-vsnip"; }

    # Snippets 
    { name = "vim-vsnip"; }

    # Telescope
    { name = "telescope-nvim"; }
    { name = "telescope-ui-select-nvim"; }
    { name = "dressing-nvim"; }
    { name = "plenary-nvim"; }

    # Whichkey 
    { name = "which-key-nvim"; }

    # Status line
    { name = "lualine-nvim"; }

    # Explorer
    { name = "nvim-tree-lua"; }
    { name = "nvim-web-devicons"; }

    # Sneak
    { name = "vim-sneak"; }

    # Comment text
    { name = "kommentary"; }

    # Git
    { name = "vim-fugitive"; }
    { name = "diffview-nvim"; }

    # Dashboard
    { name = "alpha-nvim"; }

    # Sessions
    { name = "neovim-session-manager"; }
  ];

  # lifted from neovim/utils.nix
  packPath =
    let
      pluginsNormalized =
        let
          defaultPlugin = {
            plugin = null;
            config = null;
            optional = false;
          };
        in
        map (x: defaultPlugin // (if (x ? plugin) then x else { plugin = x; })) plugins;

      pluginsPartitioned = lib.partition (x: x.optional == true) pluginsNormalized;

      myVimPackage = {
        start = map (x: x.plugin) pluginsPartitioned.wrong;
        opt = map (x: x.plugin) pluginsPartitioned.right;
      };

      packDirArgs.myNeovimPackages = myVimPackage;

    in
    vimUtils.packDir packDirArgs;

  neovimConfig = with neovimUtils;
    makeNeovimConfig {
      inherit plugins;

      customRC = ''
        ${readLuaConfig ./../init.lua}

        " Only load plugins provided by this flake
        set noloadplugins
        set packpath=${packPath}
        set runtimepath=${packPath},${neovim-unwrapped}/lib/nvim
        runtime! plugin/**/*.vim
        runtime! plugin/**/*.lua
        set runtimepath&
        set runtimepath^=${packPath},${neovim-unwrapped}/lib/nvim
      '';
    };
in
wrapNeovimUnstable neovim-unwrapped neovimConfig
