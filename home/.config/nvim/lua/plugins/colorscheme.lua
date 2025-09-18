return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
        require("catppuccin").setup {
            color_overrides = {
                mocha = {
                    base = "#1D1D20",
                    crust = "#1D1D20",
                    mantle = "#131317",
                },
            }
        }
        vim.cmd.colorscheme("catppuccin-mocha")
    end,
}
