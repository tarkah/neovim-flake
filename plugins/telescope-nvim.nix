{ripgrep, ...}: ''
  require("telescope").setup {
    defaults = {
        vimgrep_arguments = {
          "${ripgrep}/bin/rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case"
        },
        mappings = {
            n = {
                ["<C-c>"] = "close",
            },
        },
    },
    pickers = {
        diagnostics = {
            root_dir = os.getenv( "HOME" ) .. "/projects",
        },
    },
    extensions = {
      ["ui-select"] = {
        require("telescope.themes").get_dropdown {
          -- even more opts
        }
      }
    }
  }

  -- To get fzf loaded and working with telescope, you need to call
  -- load_extension, somewhere after setup function:
  require("telescope").load_extension("ui-select")
''
