return {
    "saghen/blink.cmp",
    dependencies = "rafamadriz/friendly-snippets",
    version = "*",
    opts = { sources = { providers = { path = { opts = { get_cwd = function(_) return vim.fn.getcwd() end } } } } },
}
