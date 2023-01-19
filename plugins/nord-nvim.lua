local util = require("nord.util")
local colors = require("nord.colors")

vim.g.nord_contrast = true
vim.g.nord_borders = true
vim.g.nord_uniform_diff_background = true

require('nord').set()

util.loadColorSet({
    GitSignsAddInline = { fg = colors.nord14_gui, bg = colors.none, style = "reverse" },
    GitSignsDeleteInline = { fg = colors.nord11_gui, bg = colors.none, style = "reverse" },
    GitSignsChangeInline = { fg = colors.nord13_gui, bg = colors.none, style = "reverse" },
})
