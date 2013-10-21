" .vimrc, http://github.com/euclio/vim-settings
" by Andy Russell (andy@acrussell.com)
"
" =============================================================================
" Setup
" =============================================================================
" viMproved!
set nocompatible

" Make $VIMHOME point to .vimrc location independent of OS
if has('win32') || has('win64')
  let $VIMHOME=$HOME . '/vimfiles'

  " Fix the path of vimrc and gvimrc for Windows
  let $MYVIMRC=$VIMHOME . '/.vimrc'
  let $MYGVIMRC=$VIMHOME . '/.gvimrc'
else
  let $VIMHOME=$HOME . '/.vim'
endif

" Change leader to comma
let mapleader=","
let g:mapleader=","

" Enable vundle and plugins
source $VIMHOME/bundles.vim

" =============================================================================
" File settings
" =============================================================================
" Set default encodings and file formats
set encoding=utf8
set fileformats=unix,dos,mac

" Set column width to 79 characters, and display a line at the limit
set textwidth=79 colorcolumn=+1

" Don't wrap lines
set nowrap

" Enable syntax highlighting
syntax enable

" Set filetype specific indentation
filetype plugin indent on

" Make tabs into spaces and indent with 4 spaces
set expandtab tabstop=4 shiftwidth=4 softtabstop=4

" Store undo history across sessions
if v:version >= 703
  let &undodir=$VIMHOME . '/undofiles'
  set undofile
endif

" Autoformat comments into paragraphs when modifying text
set formatoptions=cqar

" Assume that .tex files are LaTeX
let g:tex_flavor='latex'

" =============================================================================
" Editing Window Improvements
" =============================================================================
" Show line numbers
set number relativenumber

" When leaving buffer, hide it instead of closing it
set hidden

" Statusline settings
set laststatus=2 noshowmode showcmd cmdheight=2

" Ensure that the cursor is at least 5 lines above bottom
set scrolloff=5

" Show arrows when there are long lines, and show · for trailing space
set list listchars=tab:\ \ ,trail:·,precedes:←,extends:→

" Enable autocomplete menu
set wildmenu

" On first tab, complete the longest common command. On second tab, cycle menu
set wildmode=longest,full

" Files to ignore in autocompletion
set wildignore=*.o,*.pyc,*.class,*.bak,*~

" =============================================================================
" Motions
" =============================================================================
" Disable arrow keys; hjkl are way better anyways!
noremap  <up>    <nop>
inoremap <up>    <nop>
noremap  <down>  <nop>
inoremap <down>  <nop>
noremap  <left>  <nop>
inoremap <left>  <nop>
noremap  <right> <nop>
inoremap <right> <nop>

" Backspace works as expected (across lines)
set backspace=indent,eol,start

" Searching behaves like a web browser
set incsearch ignorecase smartcase hlsearch

" =============================================================================
" New Commands
" =============================================================================
" F9 opens .vimrc
map <f9> :e $MYVIMRC<cr>

" <leader><leader> clears previous search highlighting
map <silent> <leader><leader> :nohlsearch<cr>

" w!! saves file with superuser permissions
if has('unix') || has('macunix')
  cmap w!! w !sudo tee > /dev/null %
endif

" <leader>d deletes without filling the yank buffer
nmap <silent> <leader>d "_d
vmap <silent> <leader>d "_d

" <leader>/ opens current search in Quickfix window
map <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>

" =============================================================================
" Fix Annoyances
" =============================================================================
" Disable visual and audio bell
set noerrorbells visualbell t_vb=

" Don't make backups
set nobackup

" Make regex a little easier
set magic

" Custom Terminal title
let &titlestring=hostname() . ' %F %y %r- VIM %m'
set title

" =============================================================================
" Colorscheme
" =============================================================================
" Use a dark colorscheme
set background=dark
if &t_Co >= 88
  colorscheme nocturne
else
  colorscheme slate
endif
