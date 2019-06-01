call plug#begin()
Plug 'terryma/vim-multiple-cursors'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
Plug 'davidhalter/jedi-vim'
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
colorscheme elflord
set number

" Split windows
set splitbelow 
set splitright

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

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
