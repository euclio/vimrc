" =============================================================================
" Neobundle Setup
" =============================================================================
"
" Install neobundle if it doesn't exist
let new_neobundle_install=0
let neobundle_readme=expand('$VIMHOME/bundle/neobundle.vim/README.md')
if !filereadable(neobundle_readme)
    let $NEOBUNDLE=expand('$VIMHOME/bundle/neobundle.vim')

    echom 'NeoBundle not found. Installing...'
    echom ''

    call mkdir($VIMHOME . '/bundle', 'p')
    silent exe '!git clone https://github.com/Shougo/neobundle.vim' $NEOBUNDLE
    let new_vundle_install=1
endif

" Add neobundle to runtime path
if has('vim_starting')
    set rtp+=$VIMHOME/bundle/neobundle.vim
endif

call neobundle#rc(expand('$VIMHOME/bundle/'))

" =============================================================================
" Bundles
" =============================================================================
"
" Allow neobundle to manage itself
NeoBundleFetch 'Shougo/neobundle.vim'

" Syntax checking on save
NeoBundle 'scrooloose/syntastic'

" Git wrapper
NeoBundle 'tpope/vim-fugitive'

" Statusline improvements
NeoBundle 'bling/vim-airline'
let g:airline_left_sep = ''
let g:airline_right_sep = ''
let g:airline_branch_prefix = '⎇  '     " Symbol displayed next to Git branch
let g:airline_theme='badwolf'

" Filetype plugin for Scala
NeoBundle 'derekwyatt/vim-scala'

" View highlight groups under cursor
NeoBundle 'gerw/vim-HiLinkTrace'

" Filetree viewer
NeoBundle 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
" Close vim if NERDTree is the only window
autocmd bufenter *
  \ if (winnr("$") == 1 &&
  \     exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" My personal colorscheme
NeoBundle 'euclio/vim-nocturne'

" Allow GUI colorschemes in 256-color or 88-color terminals
NeoBundle 'CSApprox'
let g:CSApprox_verbose_level=0      " Disable warnings for <88 colors

" Autocompletion for Python and C-like languages
NeoBundle 'Valloric/YouCompleteMe', {
            \ 'build': {
            \     'unix': './install.sh --clang-completer',
            \   },
            \ }

" Automatic completion of parenthesis, brackets, etc.
NeoBundle 'Raimondi/delimitMate'

" Install the bundles if Vundle was installed for the first time
if new_neobundle_install
    echom 'Installing all bundles...'
    NeoBundleInstall!
    echom 'If there are errors, they can be safely ignored.'
endif

" Check installation
NeoBundleCheck
