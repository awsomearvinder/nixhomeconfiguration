vim.opt.completeopt = "menu,menuone,noselect";
vim.opt.signcolumn = "yes";

local cmp = require'cmp';
cmp.setup.cmdline('/', {sources = cmp.config.sources({ { name = "buffer" }, { name = "nvim_lsp_document_symbol" } })})
cmp.setup({
  snippet = {
    expand = function(args)
	require'luasnip'.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Replace,
      select = true,
    }),
    ["<Tab>"] = cmp.mapping(cmp.mapping.select_next_item(), { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(cmp.mapping.select_prev_item(), { "i", "s" }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = "orgmode" },
    { name = 'buffer' },
  }
})

local nvim_lsp = require'lspconfig';
local servers = {"rust_analyzer", "pyright", "tsserver", "elmls", "hls", "purescriptls", "rnix", "gopls"};
for _, server in ipairs(servers) do 
  nvim_lsp[server].setup {
    capabilities = require('cmp_nvim_lsp')
      .update_capabilities(vim.lsp.protocol.make_client_capabilities());
  }
end

vim.cmd'nnoremap <silent> gd   <cmd>lua vim.lsp.buf.type_definition()<CR>'
vim.cmd'nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>'
vim.cmd'nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>'
vim.cmd'nnoremap <silent> ga <cmd>lua vim.lsp.buf.code_action()<CR>'


vim.cmd'autocmd BufWritePre *.rs lua vim.lsp.buf.formatting()'
vim.cmd'autocmd BufWritePre *.elm lua vim.lsp.buf.formatting()'
vim.cmd(
  'autocmd BufWritePre *.js,*.ts,*.tsx,*.jsx Neoformat prettier'
)
