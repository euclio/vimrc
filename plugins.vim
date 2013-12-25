" =============================================================================
" Neobundle Setup
" =============================================================================
"
" Install neobundle if it doesn't exist
let new_neobundle_install=0
let neobundle_readme=expand('$VIMHOME/bundle/neobundle.vim/README.md')
let $NEOBUNDLE=expand('$VIMHOME/bundle/neobundle.vim')
if !filereadable(neobundle_readme)
    echom 'NeoBundle not found. Installing...'

    call mkdir(expand('$VIMHOME/bundle'), 'p')
    silent exec '!git clone https://github.com/Shougo/neobundle.vim' $NEOBUNDLE
    let new_vundle_install=1
endif

" Add neobundle to runtime path
if has('vim_starting')
    set rtp+=$NEOBUNDLE
endif

call neobundle#rc(expand('$VIMHOME/bundle/'))

" Allow neobundle to manage itself
NeoBundleFetch 'Shougo/neobundle.vim'

" =============================================================================
" Interface
" =============================================================================
"
" Syntax checking on save
NeoBundle 'scrooloose/syntastic'
let g:syntastic_python_checkers=['pyflakes', 'pylint', 'pep8', 'python']

" Git wrapper
NeoBundle 'tpope/vim-fugitive'

" Statusline improvements
NeoBundle 'bling/vim-airline'
let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='badwolf'

" Filetree viewer
NeoBundle 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
let NERDTreeHijackNetrw=1           " Use NERDtree instead of netrw
" Close vim if NERDTree is the only window
autocmd bufenter *
  \ if (winnr("$") == 1 &&
  \     exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" =============================================================================
" Features
" =============================================================================
"
" Autocompletion for Python and C-like languages
NeoBundle 'Valloric/YouCompleteMe', {
            \ 'build': {
            \     'unix': './install.sh --clang-completer --system-libclang',
            \   },
            \ 'disabled': !has('python'),
            \ 'vim_version': '7.3.584',
            \ }
let g:EclimCompletionMethod='omnifunc'      " Let YCM use Eclipse autocomplete

" Automatic completion of parenthesis, brackets, etc.
NeoBundle 'Raimondi/delimitMate'
let delimitMate_expand_cr=1                 " Put new brace on newline after CR

" View highlight groups under cursor
NeoBundle 'gerw/vim-HiLinkTrace'

" =============================================================================
" Languages
" =============================================================================
"
" Filetype plugin for Scala
NeoBundle 'derekwyatt/vim-scala'

" LaTeX compilation commands and autocomplete
NeoBundle 'LaTeX-Box-Team/LaTeX-Box'
let g:LatexBox_latexmk_preview_continuously=1   " Auto-compile TeX on save

" Jinja2 template syntax highlighting
NeoBundle 'Glench/Vim-Jinja2-Syntax'

" Better JavaScript syntax highlighting and indentation
NeoBundle 'pangloss/vim-javascript'

" =============================================================================
" Cosmetic
" =============================================================================
"
" My personal colorscheme
NeoBundle 'euclio/vim-nocturne'

" Allow GUI colorschemes in 256-color or 88-color terminals
NeoBundle 'CSApprox'
let g:CSApprox_verbose_level=0      " Disable warnings for <88 colors

" Check installation
NeoBundleCheck
