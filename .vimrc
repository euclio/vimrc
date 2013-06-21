" " "
" Compatibility fixes
"
" viMprove yourself
set nocompatible

" Make $VIMHOME point to .vimrc location independent of OS
if has('win32') || has('win64')
    let $VIMHOME=$HOME.'/vimfiles'

    " Fix the path of vimrc and gvimrc for Windows
    let $MYVIMRC=$VIMHOME.'/.vimrc'
    let $MYGVIMRC=$VIMHOME.'/.gvimrc'
else
    let $VIMHOME=$HOME.'/.vim'
endif


" " "
" Plugins
"
" Enable vundle
source $VIMHOME/bundles.vim


" " "
" File-specific settings
"
" Set default encoding to utf8 and read all types of files
set encoding=utf8
set ffs=unix,dos,mac

" Set column width to 80 characters, display a line at the limit, and don't
" wrap lines
set tw=79 cc=+1 nowrap

" Enable syntax highlighting
syntax enable

" Set filetype specific indentation
filetype plugin indent on

" Make tabs into spaces...
autocmd FileType * set expandtab ts=4 sw=4 sts=4
" ...but not for Makefiles
autocmd FileType make setlocal noexpandtab

" Fix quirkiness in HTML-specific indentation and set tab width to 2
autocmd FileType html* setlocal indentkeys-=*<Return>
autocmd FileType html* setlocal ts=2 sw=2 sts=2

" Make html lines longer, and don't break lines automatically
autocmd FileType html* setlocal tw=120 linebreak textwidth=0


" " "
" Editing Window Improvements
"
" Show line numbers, ruler, last command, and mode
set ruler laststatus=2 showcmd showmode number

" Ensure that the cursor is at least 5 lines above bottom
set scrolloff=5

" Show arrows when there are long lines, and show ¤ on trailing space
set list listchars=tab:\ \ ,trail:¤,precedes:←,extends:→


" " "
" Motions
"
" Disable arrow keys; hjkl are way better anyways!
noremap  <up>    <nop>
inoremap <up>    <nop>
noremap  <down>  <nop>
inoremap <down>  <nop>
noremap  <left>  <nop>
inoremap <left>  <nop>
noremap  <right> <nop>
inoremap <right> <nop>

" Make backspace work as expected (across lines)
set backspace=2

" Make searching behave like a web browser
set incsearch ignorecase smartcase hlsearch


" " "
" New Commands
"
" F9 opens .vimrc
map <F9> :e $MYVIMRC<CR>


" " "
" Fix Annoyances
"
" Disable visual and audio bell
set noerrorbells visualbell t_vb=


" " "
" Colorscheme
"
" Use a colorscheme that is safe for 16 colors 
colorscheme slate
