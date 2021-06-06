--Make a new fzf window.
local OpenFZF = function(action, size_x_percent, size_y_percent)
    --vim.g.fzf_colors = {
    --    ["fg"]=      {'fg', 'Normal'},
    --    ["bg"]=      {'bg', 'Normal'},
    --    ["hl"]=      {'fg', 'Comment'},
    --    ["fg+"]=     {'fg', 'CursorLine', 'CursorColumn', 'Normal'},
    --    ["bg+"]=     {'bg', 'CursorLine', 'CursorColumn'},
    --    ["hl+"]=     {'fg', 'Statement'},
    --    ["info"]=    {'fg', 'PreProc'},
    --    ["border"]=  {'fg', 'Ignore'},
    --    ["prompt"]=  {'fg', 'Conditional'},
    --    ["pointer"]= {'fg', 'Exception'},
    --    ["marker"]=  {'fg', 'Keyword'},
    --    ["spinner"]= {'fg', 'Label'},
    --    ["header"]=  {'fg', 'Comment'}
    --}
    local cmd = ":call fzf#run(fzf#wrap({"..
        string.format("'sink': '%s',", action)..
        "'source': 'rg --files',"..
        [['options': '--preview-window=50% --preview="bat {} --color=always --style=plain"',]]..
        string.format("'window': {'width': %f, 'height': %f, 'border': 'no'},", size_x_percent, size_y_percent)..
    "}))"
    vim.api.nvim_command(cmd)
end

local r = {
    open = function(action, x, y) OpenFZF(action, x, y) end
}

return r
