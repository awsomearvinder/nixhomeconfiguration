local r = {
    -- Makes a window and returns it's buffer.
    make_window = function(width, height, x, y, style, relative)
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
}

return r
