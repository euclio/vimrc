" Set filetype specific indentation
filetype plugin indent on

" Space indentation
autocmd FileType * set expandtab ts=4 sw=4 sts=4

" Searching behaves like a web browser
" set incsearch ignorecase smartcase hlsearch

" Use 256 Colors if available
set t_Co=256

" Set colorscheme
syntax enable
set background=dark
colorscheme solarized

" Default encoding and file behavior
set encoding=utf8
set ffs=unix,dos,mac

" Disable arrow keys
noremap <up> <nop>
noremap <down> <nop>
noremap <left> <nop>
noremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>

" F9 opens .vimrc
map <F9> :e $HOME/.vimrc<CR>

" Show line numbers, ruler, last command, and mode
set nocompatible ruler laststatus=2 showcmd showmode number

" Set column width and change background color after width
set tw=80 cc=+1
