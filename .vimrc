" Using viM
set nocompatible

" Enable vundle
source bundles.vim

" Set filetype specific indentation
filetype plugin indent on

" Space indentation
autocmd FileType * set expandtab ts=4 sw=4 sts=4

" Searching behaves like a web browser
set incsearch ignorecase smartcase hlsearch

" Use 256 Colors if available
if has('gui_running')
    set t_Co=256
    set background=dark " Enables solarized 'dark'
    colorscheme solarized
else
    " Use a colorscheme that is safe for 16 colors 
    colorscheme slate
endif

" Enable syntax highlighting
syntax enable

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
map <F9> :e $MYVIMRC<CR>

" Show line numbers, ruler, last command, and mode
set nocompatible ruler laststatus=2 showcmd showmode number

" Set column width and change background color after width
set tw=79 cc=+1

" Fix HTML indentation in filetype plugin indentation
autocmd FileType html setlocal indentkeys-=*<Return>

" Make backspace work as expected (works across lines)
set backspace=2

" Disable bell (visual and normal)
set noerrorbells visualbell t_vb=
if has('autocmd')
    autocmd GUIEnter * set visualbell t_vb=
endif

" Ensure that the cursor is at least 5 lines above bottom
set scrolloff=5
