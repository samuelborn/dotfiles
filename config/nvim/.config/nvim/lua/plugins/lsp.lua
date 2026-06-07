return {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
        { "neovim/nvim-lspconfig" },
        { "j-hui/fidget.nvim",    opts = {} },
        { "folke/lazydev.nvim",   opts = {}, ft = "lua" },
        { "mason-org/mason.nvim", opts = {} },
    },
    opts = {
        ensure_installed = {
            "clangd",
            "lua_ls",
            "pyright",
            "ruff",
            "texlab",
            "jdtls",
            "tinymist",
            "rust_analyzer",
        },
    },
}
