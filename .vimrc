call plug#begin()
Plug 'terryma/vim-multiple-cursors'
Plug 'itchyny/lightline.vim'
Plug 'tpope/vim-surround'
call plug#end()

" LIGHTLINE CONFIG
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'one',
      \ }
set noshowmode
set ttimeout ttimeoutlen=30

" OTHER
colorscheme elflord
set number

" tab as 4 spaces
set tabstop=8 softtabstop=0 expandtab shiftwidth=2 smarttab
set pastetoggle=<F2>
