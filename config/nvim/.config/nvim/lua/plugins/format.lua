return {
    "stevearc/conform.nvim",
    dependencies = { "zapling/mason-conform.nvim", opts = {} },
    opts = {
        formatters_by_ft = {
            javascript = { "prettierd" },
            json       = { "prettierd" },
            jsonc      = { "prettierd" },
            markdown   = { "prettierd" },
            html       = { "prettierd" },
            css        = { "prettierd" },
            sh         = { "shfmt" },
            zsh        = { "beautysh" },
            tex        = { "latexindent" },
            cmake      = { "cmake_format" },
            yaml       = { "prettierd" },
            typst      = { "typstyle" },
        },
    },
    keys = { { "<leader>l", function() require("conform").format({ lsp_format = "fallback" }) end } },
}
