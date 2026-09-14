vim.g.mapleader = ' '

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.number = true
vim.opt.cursorline = true
vim.opt.signcolumn = 'no'
vim.opt.showmode = false
vim.opt.fillchars:append({ diff = " ", eob = " " })

vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 4

vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true

vim.opt.splitright = true
vim.opt.splitbelow = true

vim.opt.undofile = true
vim.opt.shada = "!,'2000,<50,s10,h"
vim.opt.updatetime = 250
vim.opt.spelllang = "en,de"

vim.pack.add({
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/folke/tokyonight.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-mini/mini.diff" },
    { src = "https://github.com/nvim-mini/mini.surround" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/saghen/blink.cmp" },
    { src = "https://github.com/saghen/blink.lib" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = 'https://github.com/dlyongemallo/diffview-plus.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
})

vim.cmd.colorscheme("tokyonight-night")

vim.lsp.enable({ 'clangd', 'lua_ls', 'ruff', 'rust_analyzer', 'ty' })

vim.keymap.set("n", "<C-s>", "<cmd>wa<cr>")
vim.keymap.set("n", "<leader>a", "<cmd>q<cr>")
vim.keymap.set("n", "<leader>A", "<cmd>qa<cr>")
vim.keymap.set("n", "<leader>W", "<cmd>w !sudo tee % > /dev/null<cr>")

vim.keymap.set({ "n", "x" }, "<leader>y", '"+y')
vim.keymap.set("n", "<leader>Y", '"+y$')
vim.keymap.set("n", "<A-y>", '<cmd>%y+<cr>')

vim.keymap.set("n", "ce", "cw")
vim.keymap.set("n", "gC", "yygccP", { remap = true })
vim.keymap.set("x", "gC", "ygvgcP", { remap = true })
vim.keymap.set("x", "<leader>rp", '"zy:%s/<C-r>z//g<left><left>')
vim.keymap.set("n", "<leader>L", "gg=G<C-o>")

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>")
vim.keymap.set("n", "*", "*zz")
vim.keymap.set("n", "#", "#zz")
vim.keymap.set("n", "<C-a>", "<C-u>zz")
vim.keymap.set("n", "<C-'>", "<C-d>zz")

vim.keymap.set("n", "H", "<cmd>bprevious<cr>")
vim.keymap.set("n", "E", "<cmd>bnext<cr>")

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>i", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)

vim.keymap.set("n", "<leader>cl", function() vim.fn.setreg("+", vim.fn.expand("%:p") .. ":" .. vim.fn.line(".")) end)
vim.keymap.set("n", "<leader>cp", function() vim.fn.setreg("+", vim.fn.expand("%:p")) end)

-- Alt-arrows move between nvim splits, falling through to tmux panes at the edge
local function navigate(wincmd, tmux_flag)
    local from = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(wincmd)
    if vim.api.nvim_get_current_win() == from and vim.env.TMUX ~= nil then
        vim.system({ "tmux", "select-pane", "-" .. tmux_flag }):wait()
    end
end

vim.keymap.set({ "n", "t" }, "<M-Left>", function() navigate("h", "L") end)
vim.keymap.set({ "n", "t" }, "<M-Down>", function() navigate("j", "D") end)
vim.keymap.set({ "n", "t" }, "<M-Up>", function() navigate("k", "U") end)
vim.keymap.set({ "n", "t" }, "<M-Right>", function() navigate("l", "R") end)
vim.keymap.set({ "n", "t" }, "<C-Left>", "<cmd>vertical resize -5<cr>")
vim.keymap.set({ "n", "t" }, "<C-Right>", "<cmd>vertical resize +5<cr>")
vim.keymap.set({ "n", "t" }, "<C-Up>", "<cmd>resize +5<cr>")
vim.keymap.set({ "n", "t" }, "<C-Down>", "<cmd>resize -5<cr>")

require("snacks").setup {
    picker = { enabled = true },
    notifier = { enabled = true },
    terminal = { win = { wo = { winbar = '' } } },
}
vim.keymap.set("n", "<leader><leader>", Snacks.picker.smart)
vim.keymap.set("n", "<leader>sf", Snacks.picker.files)
vim.keymap.set("n", "<leader>sg", Snacks.picker.grep)
vim.keymap.set("n", "<leader>sh", Snacks.picker.help)
vim.keymap.set("n", "<leader>sr", Snacks.picker.resume)
vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions)
vim.keymap.set("n", "gr", Snacks.picker.lsp_references, { nowait = true })
vim.keymap.set({ "n", "t", "i" }, "<C-\\>", Snacks.terminal.toggle)
vim.keymap.set({ "n", "t", "i" }, "<C-g>", Snacks.lazygit.open)

require('blink.cmp').build():pwait()
require('blink.cmp').setup()

require("conform").setup {
    formatters_by_ft = {
        markdown = { "prettierd" },
    },
}
vim.keymap.set({ "n", "v" }, "<leader>l", function() require("conform").format({ lsp_format = "fallback" }) end)

require("oil").setup { view_options = { show_hidden = true } }
vim.keymap.set("n", "-", "<cmd>Oil<cr>")

require("mini.surround").setup()
require("mini.diff").setup()
vim.keymap.set("n", "<leader>go", MiniDiff.toggle_overlay)

require("diffview").setup({ wrap_entries = false })
vim.keymap.set('n', '<leader>gd', "<cmd>DiffviewToggle --imply-local<cr>")
vim.keymap.set('n', '<leader>gm', function()
    local branch = vim.fn.system('git rev-parse --verify -q origin/main') ~= '' and 'origin/main' or 'origin/master'
    vim.cmd('DiffviewOpen --imply-local' .. branch .. '... HEAD')
end)

require("lualine").setup {
    options = { component_separators = "" },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "buffers" },
        lualine_c = {},
        lualine_x = { "filetype", "lsp_status" },
        lualine_y = { "%l / %L" },
        lualine_z = {},
    },
}

vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(event)
        local mark = vim.api.nvim_buf_get_mark(event.buf, '"')
        local lcount = vim.api.nvim_buf_line_count(event.buf)
        if mark[1] > 0 and mark[1] <= lcount then
            pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
    end,
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

vim.api.nvim_create_autocmd("FileType", { pattern = { "help", "man" }, command = "wincmd L" })

vim.api.nvim_create_autocmd({ "TermOpen", "TermEnter" }, { command = "wa" })

vim.api.nvim_create_autocmd("TextYankPost", { callback = function() vim.highlight.on_yank() end })
