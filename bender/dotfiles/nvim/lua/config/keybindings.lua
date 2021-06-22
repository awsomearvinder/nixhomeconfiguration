local wk = require'which-key'
wk.setup {}
wk.register({
    f = {
        name = "telescope",
	f = {"<cmd>Telescope find_files<CR>", "Find File"},
	g = {"<cmd>Telescope live_grep<CR>", "Live Grep"},
    },
    p = {":NERDTreeToggle<CR>", "Toggle NERDTree"},
}, {prefix = "<leader>"})
