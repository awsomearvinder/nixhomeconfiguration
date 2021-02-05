--Opens a terminal in a floating window.
local OpenTerminal = function(size_x_percent, size_y_percent)
    local utils = require('plugins/utils')
    local width = vim.api.nvim_get_option("columns")
    local height = vim.api.nvim_get_option("lines")
    local win_height = math.ceil(height * size_x_percent)
    local win_width = math.ceil(width * size_y_percent)
    local col_pos = math.floor(width * (1-size_y_percent)/2)
    local row_pos = math.floor(height * (1-size_x_percent)/2)
    local buffer = utils.make_window(win_width, win_height, row_pos, col_pos, "minimal", "editor")
    vim.api.nvim_command('term')
end


local r = {
    -- Takes a x and y as percentage size of the screen.
    open = function(x, y) OpenTerminal(x, y) end
}

return r
