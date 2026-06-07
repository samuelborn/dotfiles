return {
    "nvim-lualine/lualine.nvim",
    opts = {
        options = { component_separators = "" },
        sections = {
            lualine_a = { "mode" },
            lualine_b = { { "buffers", symbols = { alternate_file = "" } } },
            lualine_c = {},
            lualine_x = { "filetype" },
            lualine_y = { "diff" },
            lualine_z = { function() return string.format("%d ln", vim.api.nvim_buf_line_count(0)) end },
        },
    },
}
