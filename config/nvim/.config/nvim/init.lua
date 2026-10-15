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
vim.opt.shada = "!,'2000,<50,s10,h"
vim.opt.updatetime = 250
vim.opt.spelllang = "en,de"

vim.pack.add({
    { src = "https://github.com/catppuccin/nvim",                name = "catppuccin" },
    { src = "https://github.com/folke/snacks.nvim" },
    { src = "https://github.com/nvim-lualine/lualine.nvim" },
    { src = "https://github.com/nvim-mini/mini.diff" },
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

-- The Fenix toolchain ships rust-analyzer-proc-macro-srv in bin/, but rust-analyzer only
-- searches the sysroot's libexec/ and lib/ for it
local ra_before_init = vim.lsp.config.rust_analyzer.before_init
vim.lsp.config('rust_analyzer', {
    before_init = function(params, config)
        local root = config.root_dir and vim.fs.root(config.root_dir, 'toolchain')
        local srv = root and vim.fs.joinpath(root, 'toolchain/bin/rust-analyzer-proc-macro-srv')
        if srv and vim.uv.fs_stat(srv) then
            -- Extend in place: the client already holds this table as client.settings and answers
            -- rust-analyzer's workspace/configuration pulls from it. A replacement table would
            -- only reach the initializationOptions, which those pulls then override.
            config.settings = config.settings or {}
            local ra = config.settings['rust-analyzer'] or {}
            config.settings['rust-analyzer'] = ra
            ra.procMacro = vim.tbl_extend('force', ra.procMacro or {}, { server = srv })
        end
        if ra_before_init then ra_before_init(params, config) end
    end,
})

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
require("mini.diff").setup()
vim.keymap.set("n", "<leader>go", MiniDiff.toggle_overlay)

-- WSL has no Linux browser, so the rendered page is handed to Windows by its UNC path
vim.keymap.set("n", "<leader>m", function()
    local html = vim.fn.tempname() .. ".html"
    local res = vim.system(
        {
            "pandoc", "-f", "gfm", "-s", "--metadata", "pagetitle=" .. vim.fn.expand("%:t"),
            "-H", vim.fn.stdpath("config") .. "/markdown-preview.html",
            "-o", html,
        },
        { stdin = vim.api.nvim_buf_get_lines(0, 0, -1, false) }
    ):wait()
    if res.code ~= 0 then return vim.notify(res.stderr, vim.log.levels.ERROR) end
    vim.system({ "explorer.exe", vim.trim(vim.fn.system({ "wslpath", "-w", html })) })
end)

require("mini.files").setup { mappings = { go_in_plus = "<Enter>", go_out_plus = "<Left>" } }
vim.keymap.set("n", "<leader>e", function()
    local path = vim.api.nvim_buf_get_name(0)
    MiniFiles.open(vim.uv.fs_stat(path) and path or nil)
    MiniFiles.reveal_cwd()
end)

-- global shortcut to enable/disable folding, off by default
vim.opt.diffopt:append('context:99999')
vim.keymap.set('n', '<leader>gf', function()
    if vim.o.diffopt:find('context:99999') then
        vim.opt.diffopt:remove('context:99999')
    else
        vim.opt.diffopt:append('context:99999')
    end
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
    pattern = { "markdown", "text", "latex", "tex", "plaintex", "typst", "rst" },
    callback = function()
        vim.opt_local.spell = true
        vim.opt_local.wrap = true
    end,
})

vim.api.nvim_create_autocmd("FileType", { pattern = { "help", "man" }, command = "wincmd L" })

vim.api.nvim_create_autocmd("VimResized", { command = "wincmd =" })

vim.api.nvim_create_autocmd("TextYankPost", { callback = function() vim.highlight.on_yank() end })

-- Mouse wheel scrolls the hovered window without focusing it, which skips scrollbind syncing
vim.api.nvim_create_autocmd("WinScrolled", {
    callback = function()
        local win = vim.fn.getmousepos().winid
        if vim.v.event[tostring(win)] and win ~= vim.api.nvim_get_current_win() and vim.wo[win].scrollbind then
            vim.api.nvim_win_call(win, function() vim.cmd("normal! \27") end)
        end
    end,
})

