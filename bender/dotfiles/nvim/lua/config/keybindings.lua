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
vim.api.nvim_set_keymap('i', '<C-c>', '<ESC>', {noremap = true;});
vim.api.nvim_set_keymap('n', 'gh', ':wincmd h<CR>', {noremap = true;});
vim.api.nvim_set_keymap('n', 'gj', ':wincmd j<CR>', {noremap = true;});
vim.api.nvim_set_keymap('n', 'gk', ':wincmd k<CR>', {noremap = true;});
vim.api.nvim_set_keymap('n', 'gl', ':wincmd l<CR>', {noremap = true;});
vim.api.nvim_set_keymap('n', '<leader>d', ":put =strftime('- [%a %Y-%m-%d %H:%M:%S%z]')<CR>f]a", {noremap = true;})
vim.api.nvim_set_keymap('t', '<ESC>', '<C-\\><C-n>', {noremap = true;});
