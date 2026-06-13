vim.g.mapleader = ' '

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.number = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'no'
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 4
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.updatetime = 250
vim.opt.undofile = true
vim.opt.spelllang = "en,de"
vim.opt.showmode = false
vim.opt.shada = "!,'2000,<50,s10,h"

vim.keymap.set("n", "<leader>w", "<cmd>wa<cr>")
vim.keymap.set("n", "<leader>q", vim.cmd.quit)
vim.keymap.set("n", "H", "<cmd>bprevious<cr>")
vim.keymap.set("n", "L", "<cmd>bnext<cr>")
vim.keymap.set("n", "<C-a>", "ggVG")
vim.keymap.set({ "n", "x" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>l", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>Y", '"+y$')
vim.keymap.set("n", "<A-y>", '<cmd>%y+<cr>')
vim.keymap.set("n", "x", '"_x')
vim.keymap.set("n", "gC", "yygccP", { remap = true })
vim.keymap.set("x", "gC", "ygvgcP", { remap = true })
vim.keymap.set("ca", "w!!", "w !sudo tee % > /dev/null")
vim.keymap.set("n", "<leader>m", "<cmd>wa | make<cr>")
vim.keymap.set("x", "<leader>rp", '"zy:%s/<C-r>z//g<left><left>')
vim.keymap.set("n", "<leader>rp", ':%s/<C-r><C-w>//g<left><left>')
vim.keymap.set("n", "<leader>L", "gg=G<C-o>")
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")
vim.keymap.set("x", "J", "j")
vim.keymap.set("n", "ce", "cw")
vim.keymap.set("n", "<leader>i", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
vim.keymap.set({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
vim.keymap.set({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")
vim.keymap.set("n", "<leader>v", vim.cmd.vsplit)
vim.keymap.set("n", "<leader>h", vim.cmd.split)
vim.keymap.set({ "n", "t" }, "<C-h>", function() vim.cmd.wincmd("h") end)
vim.keymap.set({ "n", "t" }, "<C-j>", function() vim.cmd.wincmd("j") end)
vim.keymap.set({ "n", "t" }, "<C-k>", function() vim.cmd.wincmd("k") end)
vim.keymap.set({ "n", "t" }, "<C-l>", function() vim.cmd.wincmd("l") end)
vim.keymap.set("n", "<C-Up>", function() vim.cmd.resize("+2") end)
vim.keymap.set("n", "<C-Down>", function() vim.cmd.resize("-2") end)
vim.keymap.set("n", "<C-Left>", function() vim.cmd("vertical resize +2") end)
vim.keymap.set("n", "<C-Right>", function() vim.cmd("vertical resize -2") end)

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(event)
        local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
        local lcount = vim.api.nvim_buf_line_count(event.buf)
        if mark[1] > 0 and mark[1] <= lcount then
            vim.api.nvim_win_set_cursor(0, mark)
        end
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function() vim.highlight.on_yank() end,
})

vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, { command = "wa" })

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "help", "man" },
    command = "wincmd L",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function() vim.opt.formatoptions:remove({ "o", "r" }) end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "text", "latex", "tex", "plaintex", "typst" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.wrap = true
    end,
})

vim.pack.add({
    { src = "https://github.com/catppuccin/nvim",             name = "catppuccin" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/echasnovski/mini.surround" },
    { src = "https://github.com/saghen/blink.lib" },
    { src = "https://github.com/saghen/blink.cmp" },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/folke/lazydev.nvim" },
})

require("catppuccin").setup {
    color_overrides = {
        mocha = {
            base = "#1D1D20",
            crust = "#1D1D20",
            mantle = "#131317",
        },
    },
}
vim.cmd.colorscheme("catppuccin-mocha")

require("snacks").setup {
    picker = { enabled = true },
    notifier = { enabled = true },
    terminal = { win = { wo = { winbar = '' } } },
}

vim.keymap.set("n", "<leader><leader>", function() Snacks.picker.smart() end)
vim.keymap.set("n", "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end)
vim.keymap.set("n", "<leader>fh", function() Snacks.picker.help() end)
vim.keymap.set("n", "<leader>fg", function() Snacks.picker.grep() end)
vim.keymap.set("n", "<leader>ff", function() Snacks.picker.files() end)
vim.keymap.set("n", "<leader>rr", function() Snacks.picker.resume() end)
vim.keymap.set("n", "gd", function() Snacks.picker.lsp_definitions() end)
vim.keymap.set("n", "gr", function() Snacks.picker.lsp_references() end)
vim.keymap.set("n", "<leader>bo", function() Snacks.bufdelete.other() end)
vim.keymap.set("n", "<leader>bd", function() Snacks.bufdelete() end)
vim.keymap.set({ "n", "t", "i" }, "<C-\\>", function() Snacks.terminal() end)
vim.keymap.set({ "n", "t", "i" }, "<C-g>", function() Snacks.lazygit() end)

require("oil").setup { view_options = { show_hidden = true } }
vim.keymap.set("n", "-", "<cmd>Oil<cr>")

require("mini.surround").setup()


local cmp = require('blink.cmp')
cmp.build():pwait()
cmp.setup()

require("lualine").setup {
    options = { component_separators = "" },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { { "buffers", symbols = { alternate_file = "" } } },
        lualine_c = {},
        lualine_x = { "filetype", "lsp_status" },
        lualine_y = { "diff" },
        lualine_z = { "%L" },
    },
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "lua",
    callback = function() require("lazydev").setup() end,
    once = true,
})

vim.lsp.enable({ 'clangd', 'lua_ls', 'ruff', 'rust_analyzer' })
