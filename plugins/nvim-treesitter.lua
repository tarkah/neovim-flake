require 'nvim-treesitter.configs'.setup {
    auto_install = false,
    ensure_installed = {}, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = {}, -- list of language that will be disabled
    },
}
