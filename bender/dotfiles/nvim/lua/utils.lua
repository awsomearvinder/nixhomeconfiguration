local out = {}
function out.t(term)
    return vim.api.nvim_replace_termcodes(term, true, true, true)
end
return out
