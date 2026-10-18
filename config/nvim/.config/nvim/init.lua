vim.g.mapleader = ' '

vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

vim.opt.ignorecase = true
vim.opt.smartcase = true

vim.opt.number = true
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
vim.opt.shada = "!,'2000,<50,s10,h,r/tmp/,r/private/"
vim.opt.updatetime = 250
vim.opt.spelllang = "en,de"

vim.pack.add({
    { src = "https://github.com/catppuccin/nvim",                name = "catppuccin" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-mini/mini.files" },
    { src = "https://github.com/nvim-mini/mini.surround" },
    { src = "https://github.com/rafamadriz/friendly-snippets" },
    { src = "https://github.com/saghen/blink.cmp" },
    { src = "https://github.com/saghen/blink.lib" },
    { src = "https://github.com/stevearc/conform.nvim" },
    { src = 'https://github.com/dlyongemallo/diffview-plus.nvim' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
})

require("catppuccin").setup({
    color_overrides = {
        mocha = {
            base = "#1b1b1e",
            mantle = "#151517",
            crust = "#0f0f11",
            surface0 = "#2c2c30",
            surface1 = "#414146",
            surface2 = "#55555b",
        },
    },
})
vim.cmd.colorscheme("catppuccin-mocha")

vim.lsp.enable({ 'clangd', 'lua_ls', 'ruff', 'rust_analyzer', 'ty' })

vim.keymap.set("n", "<C-s>", "<cmd>wa<cr>")
vim.keymap.set("n", "<C-d>", "<cmd>q<cr>")
vim.keymap.set("n", "<C-l>", "<cmd>qa<cr>")
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

vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)
vim.keymap.set("n", "<leader>i", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end)

vim.keymap.set("n", "<leader>cl", function() vim.fn.setreg("+", vim.fn.expand("%:.") .. ":" .. vim.fn.line(".")) end)
vim.keymap.set("n", "<leader>cL", function() vim.fn.setreg("+", vim.fn.expand("%:p") .. ":" .. vim.fn.line(".")) end)
vim.keymap.set("n", "<leader>cp", function() vim.fn.setreg("+", vim.fn.expand("%:.")) end)
vim.keymap.set("n", "<leader>cP", function() vim.fn.setreg("+", vim.fn.expand("%:p")) end)
vim.keymap.set("n", "<leader>cr", function() vim.fn.setreg("+", "`" .. vim.trim(vim.fn.getline(".")) .. "` (" .. vim.fn.expand("%:.") .. ":" .. vim.fn.line(".") .. ")") end)
vim.keymap.set("n", "<leader>cR", function() vim.fn.setreg("+", "`" .. vim.trim(vim.fn.getline(".")) .. "` (" .. vim.fn.expand("%:p") .. ":" .. vim.fn.line(".") .. ")") end)

-- Alt-arrows move between splits
vim.keymap.set({ "n", "t" }, "<M-Left>", "<cmd>wincmd h<cr>")
vim.keymap.set({ "n", "t" }, "<M-Down>", "<cmd>wincmd j<cr>")
vim.keymap.set({ "n", "t" }, "<M-Up>", "<cmd>wincmd k<cr>")
vim.keymap.set({ "n", "t" }, "<M-Right>", "<cmd>wincmd l<cr>")
vim.keymap.set({ "n", "t" }, "<C-Left>", "<cmd>vertical resize -5<cr>")
vim.keymap.set({ "n", "t" }, "<C-Right>", "<cmd>vertical resize +5<cr>")
vim.keymap.set({ "n", "t" }, "<C-Up>", "<cmd>resize +5<cr>")
vim.keymap.set({ "n", "t" }, "<C-Down>", "<cmd>resize -5<cr>")

require("snacks").setup({
    picker = { enabled = true },
    notifier = { enabled = true }
})
vim.keymap.set("n", "<leader><leader>", Snacks.picker.smart)
vim.keymap.set("n", "<leader>sb", Snacks.picker.buffers)
vim.keymap.set("n", "<leader>sf", Snacks.picker.files)
vim.keymap.set("n", "<leader>sg", Snacks.picker.grep)
vim.keymap.set("n", "<leader>sh", Snacks.picker.help)
vim.keymap.set("n", "<leader>sr", Snacks.picker.resume)
vim.keymap.set("n", "gd", Snacks.picker.lsp_definitions)
vim.keymap.set("n", "gr", Snacks.picker.lsp_references, { nowait = true })
vim.keymap.set({ "n", "t", "i" }, "<C-g>", Snacks.lazygit.open)

require('blink.cmp').build():pwait()
require('blink.cmp').setup()

require("conform").setup({ formatters_by_ft = { markdown = { "prettierd" } } })
vim.keymap.set({ "n", "v" }, "<leader>l", function() require("conform").format({ lsp_format = "fallback" }) end)

require("mini.surround").setup()
require("mini.files").setup { mappings = { go_in_plus = "<Enter>", go_out_plus = "<Left>" } }
vim.keymap.set("n", "<leader>e", function()
    local path = vim.api.nvim_buf_get_name(0)
    MiniFiles.open(vim.uv.fs_stat(path) and path or nil)
    MiniFiles.reveal_cwd()
end)

-- Diffs show whole files; <leader>gf toggles folding of the unchanged lines
vim.opt.diffopt:append('context:99999')
vim.keymap.set('n', '<leader>gf', function()
    vim.cmd.set(vim.o.diffopt:find('context:99999') and 'diffopt-=context:99999' or 'diffopt+=context:99999')
end)
vim.keymap.set('n', '<leader>gd', "<cmd>DiffviewToggle --imply-local<cr>")

require("lualine").setup {
    options = { component_separators = "" },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { { "filename", path = 1 } },
        lualine_c = {},
        lualine_x = { "filetype", "lsp_status" },
        lualine_y = { "%l / %L" },
        lualine_z = {},
    },
}

-- Reopen files at the last cursor position; pcall skips marks that are unset or past the end
vim.api.nvim_create_autocmd("BufReadPost", {
    callback = function(event) pcall(vim.api.nvim_win_set_cursor, 0, vim.api.nvim_buf_get_mark(event.buf, '"')) end,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function() vim.opt.formatoptions:remove({ "o", "r" }) end,
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = { "markdown", "text", "latex", "tex", "plaintex", "typst", "rst" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.wrap = true
    end,
})

vim.api.nvim_create_autocmd("FileType", { pattern = { "help", "man" }, command = "wincmd L" })

vim.api.nvim_create_autocmd("VimResized", { command = "wincmd =" })

vim.api.nvim_create_autocmd("TextYankPost", { callback = function() vim.hl.on_yank() end })

-- Mouse wheel scrolls the hovered window without focusing it, which skips scrollbind syncing
vim.api.nvim_create_autocmd("WinScrolled", {
    callback = function()
        local win = vim.fn.getmousepos().winid
        if vim.v.event[tostring(win)] and win ~= vim.api.nvim_get_current_win() and vim.wo[win].scrollbind then
            vim.api.nvim_win_call(win, function() vim.cmd("normal! \27") end)
        end
    end,
})

