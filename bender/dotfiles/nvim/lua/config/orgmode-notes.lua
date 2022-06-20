-- Load custom tree-sitter grammar for org filetype
require('orgmode').setup_ts_grammar()

-- Tree-sitter configuration
require'nvim-treesitter.configs'.setup {
  -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = {'org'}, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
  },
  ensure_installed = {'org'}, -- Or run :TSUpdate org
}

require('orgmode').setup({
  org_agenda_files = {"~/org/agendas/active.org"},
  org_highlight_latex_and_related = "entities",
  org_capture_templates = {
    t = {
        description = "Todo",
        template = "* TODO %?\n  %t",
        target = "~/org/agendas/active.org",
    },
    j = {
        description = "journal",
        template = "* %U %?",
        target = "~/org/journal/%<%Y-%M-%D %A>.org",
    },
  },
})
