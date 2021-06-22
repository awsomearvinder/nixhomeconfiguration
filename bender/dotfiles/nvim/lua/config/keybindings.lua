local wk = require'which-key'
wk.setup {}
wk.register({
    f = {
        name = "telescope",
	f = {"<cmd>Telescope find_files<CR>", "Find File"},
	g = {"<cmd>Telescope live_grep<CR>", "Live Grep"},
    },
    p = {":NERDTreeToggle<CR>", "Toggle NERDTree"},
    s = { 
      name = "Split", 
      v = {":vsp new<CR>", "Vertical"},
      h = {":sp new<CR>", "Horizontal"},
    },
}, {prefix = "<leader>"})

-- Navigating windows
vim.api.nvim_set_keymap('n', '<A-h>', ':wincmd h<CR>', {noremap = true;});
vim.api.nvim_set_keymap('n', '<A-j>', ':wincmd j<CR>', {noremap = true;});
vim.api.nvim_set_keymap('n', '<A-k>', ':wincmd k<CR>', {noremap = true;});
vim.api.nvim_set_keymap('n', '<A-l>', ':wincmd l<CR>', {noremap = true;});
