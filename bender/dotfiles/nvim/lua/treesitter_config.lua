require'nvim-treesitter.configs'.setup {
    ensure_installed = {"rust", "lua"},
    ignore_install = {},
    highlight = {
        enable = true,
    },
}
