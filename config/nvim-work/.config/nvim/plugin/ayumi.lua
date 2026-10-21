-- Ayumi: the toolchain ships the proc-macro server in bin/, but rust-analyzer
-- only looks in <sysroot>/libexec. Point it there explicitly, per worktree.
-- The settings table is mutated in place: the client keeps a reference to the
-- original table and re-sends it via didChangeConfiguration after initialize,
-- so a replaced table would silently drop the server path again.
local ra_before_init = vim.lsp.config.rust_analyzer.before_init
vim.lsp.config('rust_analyzer', {
    before_init = function(params, config)
        local root = config.root_dir and vim.fs.root(config.root_dir, 'toolchain')
        local srv = root and root .. '/toolchain/bin/rust-analyzer-proc-macro-srv'
        if srv and vim.uv.fs_stat(srv) and config.settings then
            local ra = config.settings['rust-analyzer'] or {}
            config.settings['rust-analyzer'] = ra
            ra.procMacro = vim.tbl_extend('force', ra.procMacro or {}, { server = srv })
        end
        if ra_before_init then ra_before_init(params, config) end
    end,
})
