call plug#begin()
Plug 'terryma/vim-multiple-cursorsn'
Plug 'itchyny/lightline.vim'
call plug#end()

" LIGHTLINE CONFIG
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'one',
      \ }
set noshowmode

" OTHER
colorscheme elflord
set number
