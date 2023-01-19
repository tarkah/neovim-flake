require("diffview").setup({
    view = {
        default = {
            layout = "diff1_inline",
        },
        file_history = {
            layout = "diff1_inline",
        },
    },
    default_args = {
        DiffviewOpen = {
            "--cached",
        },
        DiffviewFileHistory = {},
    },
})
