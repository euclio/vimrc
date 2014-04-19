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
map <leader>n :NERDTreeToggle<CR>
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
            \ 'lazy': 1,
            \ 'augroup': 'youcompletemeStart',
            \ 'autoload': {
            \   'insert': 1,
            \ },
            \ 'build': {
            \     'unix': './install.sh --clang-completer --system-libclang',
            \ },
            \ 'disabled': !has('python'),
            \ 'vim_version': '7.3.584',
            \}
let g:ycm_confirm_extra_conf=0              " Disable .ycm_extra_conf confirmation
let g:EclimCompletionMethod='omnifunc'      " Let YCM use Eclipse autocomplete
" Hack to allow automatic neco-ghc completions
let g:ycm_semantic_triggers={
            \ 'haskell': ['.'],
            \}

" Automatic completion of parenthesis, brackets, etc.
NeoBundle 'Raimondi/delimitMate', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'insert': 1
            \ },
            \}
let delimitMate_expand_cr=1                 " Put new brace on newline after CR

" View highlight groups under cursor
NeoBundle 'gerw/vim-HiLinkTrace', {
            \ 'lazy': 1,
            \}

" On save, create directories if they don't exist
NeoBundle 'dockyard/vim-easydir'

" =============================================================================
" Languages
" =============================================================================
"
" Filetype plugin for Scala
NeoBundle 'derekwyatt/vim-scala', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': [
            \       'scala',
            \   ],
            \ },
            \}

" LaTeX compilation commands and autocomplete
NeoBundle 'LaTeX-Box-Team/LaTeX-Box', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': [
            \       'tex',
            \   ],
            \ },
            \}
let g:LatexBox_latexmk_preview_continuously=1   " Auto-compile TeX on save

" Jinja2 template syntax highlighting
NeoBundle 'Glench/Vim-Jinja2-Syntax', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': [
            \       'jinja',
            \   ],
            \ },
            \}

" Better JavaScript syntax highlighting and indentation
NeoBundle 'pangloss/vim-javascript', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': [
            \       'javascript',
            \   ],
            \ },
            \}

" Syntax highlighting, indentation, etc. for haxe
NeoBundleLazy 'jdonaldson/vaxe', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': [
            \       'haxe',
            \       'hss',
            \       'hxml',
            \       'lime',
            \       'nmml',
            \   ],
            \ },
            \}
let g:vaxe_lime_target="flash"                  " Set default target to flash

" Markdown preview
NeoBundle 'suan/vim-instant-markdown', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': [
            \       'markdown',
            \   ],
            \ },
            \}

" Haskell omnifunc
NeoBundle 'eagletmt/neco-ghc', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': [
            \       'haskell',
            \   ],
            \ },
            \}

" Syntax highlighting for fish scripts
NeoBundle 'dag/vim-fish', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': [
            \       'fish',
            \   ],
            \ },
            \}

" =============================================================================
" Cosmetic
" =============================================================================
"
" My personal colorscheme
NeoBundle 'euclio/vim-nocturne'

" Allow GUI colorschemes in 256-color or 88-color terminals
NeoBundle 'godlygeek/CSApprox', {
            \ 'terminal': 1,
            \}
let g:CSApprox_verbose_level=0      " Disable warnings for <88 colors

" Check installation
NeoBundleCheck
