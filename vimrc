" .vimrc, http://github.com/euclio/vim-settings
" by Andy Russell (andy@acrussell.com)
"
" =============================================================================
" Setup
" =============================================================================
"
" Use utf-8 everywhere
set encoding=utf8
scriptencoding utf8

" Allow the neovim Python plugin to work inside a virtualenv, by manually
" specifying the path to python2. This variable must be set before any calls to
" `has('python')`.
if has('nvim')
  let g:python_host_prog='/usr/bin/python2'
  let g:python3_host_prog='/usr/bin/python3'
endif

" Store vim configuration in $XDG_CONFIG_HOME
let $VIMHOME=$XDG_CONFIG_HOME . '/vim'
set runtimepath+=$VIMHOME,$VIMHOME/after
let $MYVIMRC=$VIMHOME . '/vimrc'
let $MYGVIMRC=$VIMHOME . '/gvimrc'

" Store vim caches in $XDG_CACHE_HOME
let $VIMCACHE=$XDG_CACHE_HOME . '/vim'
let $VIMDATA=$XDG_DATA_HOME . '/vim'

" Set tmp directory
set directory=$VIMCACHE,$TMP

" Save viminfo in the data directory
let viminfodir = $VIMDATA
if !isdirectory(viminfodir)
  call mkdir(viminfodir, 'p')
endif
let &viminfo="'100,<50,s10,h,n" . viminfodir
if has('nvim')
  let &viminfo.='/info.shada'
else
  let &viminfo.='/info'
endif

" Store undo history across sessions
if v:version >= 703
  let &undodir=$VIMDATA . '/undodir'
  if !isdirectory(&undodir)
    call mkdir(&undodir, 'p')
  endif
  set undofile
endif

" Store netrw history in cache
let g:netrw_home=$VIMDATA

" Change leader to spacebar.
let mapleader=' '
" This could cause filetype plugins to have mappings that conflict with other
" plugins, but as I have encountered few filetype plugins that add additional
" mappings there is little concern.
let maplocalleader=mapleader

" Ensure that vim uses the correct shell
if has('patch-7.4.276') && executable('fish')
  set shell=/bin/fish
else
  if has('win32') || has('win64')
    set shell=cmd.exe
  else
    set shell=/bin/bash
  endif
endif

" Install plugins
source $VIMHOME/plugins.vim
nnoremap <silent> <leader>pu :PlugUpdate<cr>

" Set filetype specific indentation
filetype plugin indent on

" Enable syntax highlighting
syntax enable
syntax sync minlines=250

" =============================================================================
" File settings
" =============================================================================
" Use Unix line endings by default
set fileformats=unix,dos,mac

" Set column width to 80 characters, and display a line at the limit
set textwidth=80 colorcolumn=+1

" Don't wrap lines
set nowrap

" Make tabs into spaces and indent with 4 spaces
if has('patch-7.3.629')
    set expandtab tabstop=4 shiftwidth=0 softtabstop=0
else
    set expandtab tabstop=4 shiftwidth=4 softtabstop=4
endif

" Autoformat comments into paragraphs when modifying text
set formatoptions=cqr
if has('patch-7.3.541')
    " Join comment leaders automatically
    set formatoptions+=j
endif

" Assume that .tex files are LaTeX
let g:tex_flavor='latex'

" Use one space between sentences
set nojoinspaces

" Set default dictionary to english
set spelllang=en_us

" =============================================================================
" Editing Window Improvements
" =============================================================================
" Show line numbers
set number relativenumber

" Hide line numbers when entering diff mode
augroup hide_lines
  autocmd!
  autocmd FilterWritePre * if &diff | set nonumber norelativenumber | endif
augroup END

" When leaving buffer, hide it instead of closing it
set hidden

" Statusline settings
set laststatus=2 noshowmode showcmd cmdheight=2

" Ensure that the cursor is at least 5 lines above bottom
set scrolloff=5

" Show arrows when there are long lines, and show · for trailing space
set list listchars=tab:»·,trail:·,precedes:←,extends:→

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

" Press escape to exit terminal
if has('nvim')
  tnoremap <Esc> <C-\><C-n>
endif

" Backspace works as expected (across lines)
set backspace=indent,eol,start

" Searching behaves like a web browser
set incsearch ignorecase smartcase hlsearch

" =============================================================================
" New Commands
" =============================================================================
" F9 opens .vimrc in a new window
map <f9> :sp $MYVIMRC<cr>
" F10 opens plugins.vim in a new window
map <f10> :execute 'sp $VIMHOME/plugins.vim'<cr>

" <leader><leader> clears previous search highlighting
map <silent> <leader><leader> :nohlsearch<cr>

" w!! saves file with superuser permissions
if has('unix') || has('macunix')
  cabbrev w!! w !sudo tee > /dev/null %
endif

" <leader>d deletes without filling the yank buffer
nmap <silent> <leader>d "_d
vmap <silent> <leader>d "_d

" <leader>/ opens current search in Quickfix window
map <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<cr>:copen<cr>

" <leader>df toggles diff mode for the current buffer
nnoremap <silent> <leader>df :call DiffToggle()<CR>
function! DiffToggle()
  if &diff
    diffoff
  else
    diffthis
  endif
endfunction

" %% expands to the current directory
cabbrev <expr> %% expand('%:p:h')

" =============================================================================
" Fix Annoyances
" =============================================================================
" Disable visual and audio bell
set noerrorbells visualbell t_vb=

" Don't make backups or swaps
set nobackup noswapfile

" Make regex a little easier
set magic

" Custom Terminal title
let &titlestring=hostname() . ' : %F %r: VIM %m'
set title

" Let vim reload files after shelling out
set autoread

" Don't show the scratch buffer during completions
set completeopt-=preview

" Show mode changes faster
set ttimeoutlen=50

" Jump to the last known cursor position when opening a file
augroup last_cursor_position
  autocmd!
  autocmd BufReadPost *
        \ if line("'\"") > 1 && line("'\"") <= line("$") |
        \     execute "normal! g`\"" |
        \ endif
augroup END

" Unfold all folds by default
set nofoldenable

" Allow the virtual cursor to move one space beyond actual text
set virtualedit=onemore

" Toggle showing tabs and expanding tabs, in the case that the file already
" uses tabs. Mnemonic: tt = toggle tab
nnoremap <leader>tt :set expandtab! list!<CR>

" Remove all trailing whitespace in the file, while preserving cursor position
function! RemoveTrailingSpaces()
  let l = line('.')
  let c = col('.')
  " vint: -ProhibitCommandWithUnintendedSideEffect -ProhibitCommandRelyOnUser
  %s/\s\+$//e
  " vint: +ProhibitCommandWithUnintendedSideEffect +ProhibitCommandRelyOnUser
  call cursor(l, c)
endfunction

" Enable mouse in all modes (don't overuse it)
set mouse=a

" Make Y behavior consistent with C and D
nnoremap Y y$

" Move cursor as usual through wrapped lines
nnoremap j gj
nnoremap k gk

" Open new splits below and to the right of the current window
set splitbelow splitright

" =============================================================================
" Colorscheme
" =============================================================================
" Use a dark colorscheme
set background=dark
if &t_Co >= 88
  silent! colorscheme nocturne
else
  colorscheme default
endif

" Allow local configuration to override
if filereadable(expand('~/.vimrc_local'))
  source ~/.vimrc_local
endif
