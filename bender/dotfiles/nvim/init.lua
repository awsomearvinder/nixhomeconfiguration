--local setOptions = function()
--    local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
--    local opt = function(scope, key, value)
--        scopes[scope][key] = value
--        if scope ~= 'o' then scopes['o'][key] = value end
--    end
--    vim.wo.relativenumber = true
--    vim.wo.number = true
--    vim.bo.shiftwidth = 4
--    vim.bo.tabstop = 4
--    vim.bo.expandtab = true
--    vim.o.updatetime = 300
--    vim.o.splitbelow = true
--    vim.o.termguicolors = true
--    vim.o.showcmd = true
--end
--
--local latexSetUp = function()
--    vim.g.tex_flavor = 'latex'
--    vim.g.vimtex_view_general_viewer =  'zathura'
--end
--
--local cocSetUp = function() 
--    vim.g.coc_global_extensions = { 'coc-omnisharp', 'coc-rust-analyzer', 'coc-go', 'coc-actions', 'coc-emmet', 'coc-css', 'coc-tsserver', 'coc-prettier', 'coc-deno','coc-html', 'coc-eslint', 'coc-texlab', 'coc-pyright'}
--end
--
--local gitgutterSetUp = function() 
--    vim.g.gitgutter_sign_added = '✚'
--    vim.g.gitgutter_sign_modified = '✹'
--    vim.g.gitgutter_sign_removed = '-'
--    vim.g.gitgutter_sign_removed_first_line = '-'
--    vim.g.gitgutter_sign_modified_removed = '-'
--end
--
--local setUpAll = function()
--    setOptions()
--    gitgutterSetUp()
--    latexSetUp()
--    cocSetUp()
--end
--
--local setKeybindings = function() 
--    --keybindings (would love to get vimp working)
--    vim.api.nvim_set_keymap('', '<c-n>', ':lua require(\'plugins/Terminal\').open(0.8, 0.8) <CR>', {silent = true})
--    vim.api.nvim_set_keymap('', '<c-t>', ':lua require(\'plugins/FZF\').open(\'vert new\', 0.8, 0.8) <CR>', {silent = true})
--    vim.api.nvim_set_keymap('', '<c-r>', ':lua require(\'plugins/FZF\').open(\'e\', 0.8, 0.8) <CR>', {silent = true})
--    vim.api.nvim_set_keymap('', '<A-h>', ':wincmd h <CR>', {})
--    vim.api.nvim_set_keymap('', '<A-j>', ':wincmd j <CR>', {})
--    vim.api.nvim_set_keymap('', '<A-k>', ':wincmd k <CR>', {})
--    vim.api.nvim_set_keymap('', '<A-l>', ':wincmd l <CR>', {})
--    vim.api.nvim_set_keymap('n', 'gd', '<Plug>(coc-definition)', {})
--    vim.api.nvim_set_keymap('n', 'gy', '<Plug>(coc-type-definition)', {})
--    vim.api.nvim_set_keymap('n', 'ga', '<Plug>(coc-codeaction)', {})
--    vim.api.nvim_command('autocmd BufWritePre * :silent! call CocActionAsync(\'format\')')
--end
--
--
-- entry point
--local main = function()
--    --set color
--    vim.cmd('colorscheme base16-gruvbox-dark-hard')
--    setKeybindings()
--    setUpAll()
--end
--
modules = {
    "lsp",
    "telescope",
    "treesitter",
    "nerdtree",
    "keybindings",
    "orgmode-notes",
    "octo"
}

function main()
    vim.cmd'colorscheme gruvbox'
    vim.opt.updatetime = 250;
    vim.opt.termguicolors = true
    vim.opt.number = true;
    vim.opt.smartindent = false;
    vim.opt.autoindent = true;
    vim.cmd'filetype plugin indent on'
    vim.opt.relativenumber = true;
    vim.g.mapleader=" "
    for _, module in ipairs(modules) do
        require("config." .. module)
    end
end

main()
