require'nvim-treesitter.configs'.setup {
    ensure_installed = {"rust", "lua", "norg"},
    ignore_install = {},
    highlight = {
        enable = true,
    },
}
