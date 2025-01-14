call plug#begin()
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
Plug 'vim-syntastic/syntastic'
call plug#end()

" LIGHTLINE CONFIG
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'one',
      \ }
let python_highlight_all=1
set noshowmode
set ttimeout ttimeoutlen=30

set pastetoggle=<F2>
colorscheme retrobox
set number

nnoremap <Leader>c :set cursorline!<CR>
nnoremap <F3> :set hlsearch!<CR>

" Split windows
set splitbelow 
set splitright

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
nnoremap = <C-w>=
" nmap <C-P> :ls<CR> 

" Enable folding
set foldmethod=indent
set foldlevel=99

" Enable folding with the spacebar 
nnoremap <space> za

" tab as 4 spaces
set tabstop=2 softtabstop=2 expandtab shiftwidth=2 smarttab

au BufNewFile,BufRead *.py
    \ set tabstop=4 |
    \ set softtabstop=4 |
    \ set shiftwidth=4 |
    \ set textwidth=119 |
    \ set expandtab |
    \ set autoindent |
    \ set fileformat=unix

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" Workaround for creating transparent bg
autocmd SourcePost * highlight Normal     ctermbg=NONE guibg=NONE
        \ | highlight LineNr     ctermbg=NONE guibg=NONE
        \ | highlight SignColumn ctermbg=NONE guibg=NONE
        \ | highlight CursorLine cterm=bold ctermbg=NONE ctermfg=1
