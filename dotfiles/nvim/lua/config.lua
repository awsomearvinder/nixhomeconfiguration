local setOptions = function()
    local scopes = {o = vim.o, b = vim.bo, w = vim.wo}
    local opt = function(scope, key, value)
        scopes[scope][key] = value
        if scope ~= 'o' then scopes['o'][key] = value end
    end
    vim.wo.relativenumber = true
    vim.wo.number = true
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
    vim.bo.expandtab = true
    vim.o.updatetime = 300
    vim.o.splitbelow = true
    vim.o.termguicolors = true
    vim.o.showcmd = true
end

local latexSetUp = function()
    vim.g.tex_flavor = 'latex'
    vim.g.vimtex_view_general_viewer =  'zathura'
end

local cocSetUp = function() 
    vim.g.coc_global_extensions = { 'coc-omnisharp', 'coc-rust-analyzer', 'coc-go', 'coc-actions', 'coc-emmet', 'coc-css', 'coc-tsserver', 'coc-prettier', 'coc-deno','coc-html', 'coc-eslint'}
    vim.api.nvim_command('autocmd BufWritePre * :silent! call CocAction(\'format\')')
end

-- Makes a window and returns it's buffer.
local make_window = function(width, height, x, y, style, relative)
    local buf = vim.api.nvim_create_buf(false, true)
    local opts = {
        style = style,
        relative = relative,
        width = width,
        height = height,
        row = x,
        col = y
    }
    local win = vim.api.nvim_open_win(buf, true, opts)
    return buf
end

--Opens a terminal in a floating window.
local OpenTerminal = function()
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")
    local win_height = math.ceil(height * 0.8)
    local win_width = math.ceil(width * 0.8)
    local col_pos = math.floor(width * 0.1)
    local row_pos = math.floor(height * 0.1)
    local buffer = make_window(win_width, win_height, row_pos, col_pos, "minimal", "editor")
    vim.api.nvim_command('term')
end

local gitgutterSetUp = function() 
    vim.g.gitgutter_sign_added = '✚'
    vim.g.gitgutter_sign_modified = '✹'
    vim.g.gitgutter_sign_removed = '-'
    vim.g.gitgutter_sign_removed_first_line = '-'
    vim.g.gitgutter_sign_modified_removed = '-'
end

local setUpAll = function()
    setOptions()
    gitgutterSetUp()
    latexSetUp()
    cocSetUp()
end

local setKeybindings = function() 
    --keybindings
    vimp.nnoremap({'silent'}, '<c-n>', OpenTerminal)
    vimp.bind('ni','<A-h>', function() vim.cmd(':wincmd h') end)
    vimp.bind('ni','<A-j>', function() vim.cmd(':wincmd j') end)
    vimp.bind('ni','<A-k>', function() vim.cmd(':wincmd k') end)
    vimp.bind('ni','<A-l>', function() vim.cmd(':wincmd l') end)
    vimp.bind('n', 'gd<Plug>', '(coc-definition)' )
    vimp.bind('n', 'gy<Plug>', '(coc-type-definition)')
end


-- entry point
local main = function()
    --set color
    vim.cmd('colorscheme base16-gruvbox-dark-hard')
    setKeybindings()
    setUpAll()
end

main()
