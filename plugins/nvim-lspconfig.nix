{ pkgs, ... }:

''
  local runtime_path = vim.split(package.path, ';')


  -- global diagnostics config
  vim.diagnostic.config({
      virtual_text = false,
  })


  table.insert(runtime_path, "lua/?.lua")
  table.insert(runtime_path, "lua/?/init.lua")

  require 'lspconfig'.sumneko_lua.setup {
      settings = {
          Lua = {
              runtime = {
                  -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                  version = 'LuaJIT',
                  -- Setup your lua path
                  path = runtime_path,
              },
              diagnostics = {
                  -- Get the language server to recognize the `vim` global
                  globals = { 'vim' },
              },
              workspace = {
                  -- Make the server aware of Neovim runtime files
                  library = vim.api.nvim_get_runtime_file("", true),
              },
              -- Do not send telemetry data containing a randomized but unique identifier
              telemetry = {
                  enable = false,
              },
          },
      },
  }

  require 'lspconfig'.tsserver.setup {
      cmd = { "${pkgs.nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" }
  }
  require'lspconfig'.svelte.setup{
      cmd = { "${pkgs.nodePackages.svelte-language-server}/bin/svelteserver", "--stdio" }
  }
  require 'lspconfig'.gopls.setup {
      cmd = {"${pkgs.gopls}/bin/gopls", "serve"}
  }
  require'lspconfig'.dartls.setup{
      cmd = { "${pkgs.dart}/bin/dart" , "language-server", "--protocol=lsp" }
  }
  require'lspconfig'.hls.setup{
      cmd = { "${pkgs.haskell-language-server}/bin/haskell-language-server-wrapper", "--lsp" }
  }
  require'lspconfig'.nil_ls.setup{
      cmd = {"${pkgs.nil}/bin/nil"}
  }
''
