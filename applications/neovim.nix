pkgs: {
  enable = true;
  #defaultEditor = true;
  vimAlias = true;
  viAlias = true;
  withPython = true;
  withNodeJs = true;
  withRuby = true;
  /*plugins = with pkgs.vimPlugins; [
    coc-nvim
    auto-pairs
    vim-highlightedyank
    vim-rooter
    fzf-vim
    base16-vim
    typescript-vim
    vim-nix
    vimtex
    vim-airline
    #vim-jsx-typescript
    #vim-floaterm
  ];*/
  configure = {
    packages.myVimPackage = with pkgs.vimPlugins; {
      start = [
        coc-nvim
        auto-pairs
        vim-highlightedyank
        vim-rooter
        fzf-vim
        base16-vim
        typescript-vim
        vim-nix
        vimtex
        vim-airline
        vim-sensible
      ];
      opt = [];
    };
  };
  /*extraConfig = ''
    set nocompatible
    set shell=/bin/bash
    set hidden
    set number relativenumber
    set showcmd
    set incsearch
    set hlsearch
    set shiftwidth=4
    set tabstop=4
    let mapleader=" "

    "COC
    set cmdheight=2
    set updatetime=300
    function! s:check_back_space() abort
    	let col = col('.') - 1
    	return !col || getline('.')[col - 1]  =~# '\s'
    endfunction
    inoremap <silent><expr> <TAB>
    			\ pumvisible() ? "\<C-n>" :
    			\ <SID>check_back_space() ? "\<TAB>" :
    			\ coc#refresh()
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"
    nmap <silent> gd <Plug>(coc-definition)
    " Remap for do codeAction of selected region
    function! s:cocActionsOpenFromSelected(type) abort
      execute 'CocCommand actions.open ' . a:type
    endfunction

    xmap <leader>a  <Plug>(coc-codeaction-selected)
    nmap <leader>a  <Plug>(coc-codeaction-selected)
    xmap <silent> <leader>a :<C-u>execute 'CocCommand actions.open ' . visualmode()<CR>
    nmap <silent> <leader>a :<C-u>set operatorfunc=<SID>cocActionsOpenFromSelected<CR>

    command! -nargs=0 Format :call CocAction('format')
    autocmd BufWritePre * :Format
    let g:coc_global_extensions=[ 'coc-omnisharp', 'coc-rust-analyzer', 'coc-go', 'coc-actions', 'coc-tsserver', 'coc-emmet', 'coc-css', 'coc-tsserver', 'coc-prettier']

    "FZF
    let $FZF_DEFAULT_COMMAND =  "rg --files"
    let $FZF_DEFAULT_OPTS=' --color=dark --color=fg:15,bg:-1,hl:1,fg+:#ffffff,bg+:#343D46,hl+:1 --color=info:0,prompt:0,pointer:12,marker:4,spinner:11,header:-1 --layout=reverse  --margin=1,4'
    let g:fzf_layout = { 'window': 'call FloatingFZF()' }

    function! FloatingFZF()
    	let buf = nvim_create_buf(v:false, v:true)
    	call setbufvar(buf, '&signcolumn', 'no')

    	let height = float2nr(12)
    	let width = float2nr(80)
    	let horizontal = float2nr((&columns - width) / 2)
    	let vertical = 1

      let opts = {
      \ 'relative': 'editor',
      \ 'row': vertical,
      \ 'col': horizontal,
      \ 'width': width,
      \ 'height': height,
      \ 'style': 'minimal'
      \ }
      
    call nvim_open_win(buf, v:true, opts)
    endfunction
      
    "BASE16
    let base16colorspace=256  " Access colors present in 256 colorspace
    if filereadable(expand("~/.vimrc_background"))
      let base16colorspace=256
      source ~/.vimrc_background
    endif
    set guifont=FiraCode:h12
    nnoremap <c-t> :FloatermToggle <CR>
    nnoremap <silent> ; :call fzf#vim#files('.', {'options': '--prompt ""'})<CR> nnoremap <silent> <leader>b :Buffers<CR>
    noremap <c-c> <esc>
    let g:vimtex_view_general_viewer = 'zathura'
  '';*/
}
