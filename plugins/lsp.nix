{
  nodePackages,
  gopls,
  dart,
  nil,
  haskell-language-server,
  rust-analyzer,
  sumneko-lua-language-server,
  writeIf,
  settings,
  ...
}: ''
  local runtime_path = vim.split(package.path, ';')

  -- global diagnostics config
  vim.diagnostic.config({
      virtual_text = false,
  })

  ${writeIf settings.typescript ''
    require 'lspconfig'.tsserver.setup {
        cmd = { "${nodePackages.typescript-language-server}/bin/typescript-language-server", "--stdio" }
    }
  ''}
  ${writeIf settings.svelte ''
    require'lspconfig'.svelte.setup{
        cmd = { "${nodePackages.svelte-language-server}/bin/svelteserver", "--stdio" }
    }
  ''}
  ${writeIf settings.go ''
    require 'lspconfig'.gopls.setup {
        cmd = {"${gopls}/bin/gopls", "serve"}
    }
  ''}
  ${writeIf settings.dart ''
    require'lspconfig'.dartls.setup{
        cmd = { "${dart}/bin/dart" , "language-server", "--protocol=lsp" }
    }
  ''}
  ${writeIf settings.haskell ''
    require'lspconfig'.hls.setup{
        cmd = { "${haskell-language-server}/bin/haskell-language-server-wrapper", "--lsp" }
    }
  ''}
  ${writeIf settings.nix ''
    require'lspconfig'.nil_ls.setup{
        cmd = {"${nil}/bin/nil"}
    }
  ''}
  ${writeIf settings.rust.enable ''
    local rt = require("rust-tools")

    local opts = {
        tools = {
            inlay_hints = {
                only_current_line = true,
            },
            runnables = {
                use_telescope = true
            },
        },
        server = {
            on_attach = function(_, bufnr)
               -- Hover actions
               vim.keymap.set("n", "K", rt.hover_actions.hover_actions, { buffer = bufnr })
            end,
            cmd = {"${rust-analyzer}/bin/rust-analyzer"},
            settings = {
                ["rust-analyzer"] = {
                    imports = {
                        prefix = "self",
                        granularity = {
                            enforce = true,
                            group = "module",
                        },
                    },
                    rustfmt = {
                        extraArgs = ${settings.rust.rustfmt.extraArgs},
                    },
                    checkOnSave = {
                        overrideCommand = ${settings.rust.checkOnSave.overrideCommand},
                    },
                    diagnostics = {
                        disabled = {
                           "inactive-code",
                        },
                    },
                }
            }
        },
    }
    rt.setup(opts)
  ''}
  ${writeIf settings.lua ''
    table.insert(runtime_path, "lua/?.lua")
    table.insert(runtime_path, "lua/?/init.lua")

    require 'lspconfig'.sumneko_lua.setup {
        cmd = {"${sumneko-lua-language-server}/bin/lua-language-server"},
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
  ''}
''
