" =============================================================================
" Neobundle Setup
" =============================================================================
"
" Install neobundle if it doesn't exist
let neobundle_readme=expand('$VIMHOME/bundle/neobundle.vim/README.md')
let $NEOBUNDLE=expand('$VIMHOME/bundle/neobundle.vim')
if !filereadable(neobundle_readme)
    echo "NeoBundle not found. Installing...\n"

    call mkdir(expand('$VIMHOME/bundle'), 'p')
    silent exec '!git clone https://github.com/Shougo/neobundle.vim' $NEOBUNDLE
endif

" Add neobundle to runtime path
if has('vim_starting')
    set rtp+=$NEOBUNDLE
endif

call neobundle#begin(expand('$VIMHOME/bundle/'))

" Allow neobundle to manage itself
NeoBundleFetch 'Shougo/neobundle.vim'

" =============================================================================
" Interface
" =============================================================================
"
" Syntax checking on save
NeoBundle 'scrooloose/syntastic'
let g:syntastic_scala_checkers = []     " Don't check Scala -- it's too slow

" Git wrapper
NeoBundle 'tpope/vim-fugitive'

" Statusline improvements
NeoBundle 'bling/vim-airline'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_min_count=2
let g:airline#extensions#tabline#buffer_nr_show=1
let g:airline#extensions#tabline#tab_min_count=2
let g:airline#extensions#tabline#show_close_button=0
let g:airline#extensions#tabline#left_sep=''
let g:airline#extensions#tabline#right_sep=''
let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_theme='badwolf'

" Filetree viewer
NeoBundle 'scrooloose/nerdtree', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'commands': 'NERDTreeToggle',
            \   'explorer': 1,
            \ },
            \}
map <leader>n :NERDTreeToggle<CR>
let NERDTreeHijackNetrw=1           " Use NERDtree instead of netrw
" Close vim if NERDTree is the only window
autocmd bufenter *
  \ if (winnr("$") == 1 &&
  \     exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Extended % matching
runtime macros/matchit.vim

" Add files in gitignore to wildignore
NeoBundle 'euclio/gitignore.vim', {
            \ 'depends': 'tpope/vim-fugitive',
            \}

NeoBundle 'mhinz/vim-signify'
let g:signify_vcs_list = ['git']
let g:signify_sign_change = '~'

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
            \ 'build_commands': 'cmake',
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

" Class outline viewer
NeoBundle 'majutsushi/tagbar', {
           \ 'lazy': 1,
           \ 'autoload': {
           \    'commands': [
           \      'TagbarToggle',
           \    ],
           \ },
           \ 'external_commands': 'ctags-exuberant',
           \ 'vim_version': '7.0.167',
           \}
nnoremap <f8> :TagbarToggle<cr>

" Fuzzy file finder
NeoBundle 'kien/ctrlp.vim', {
          \ 'lazy': 1,
          \ 'autoload': {
          \   'commands': 'CtrlP',
          \   'mappings': '<c-p>',
          \ },
          \}

" =============================================================================
" Languages
" =============================================================================
"
" Filetype plugin for Scala
NeoBundle 'derekwyatt/vim-scala', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': 'scala',
            \ },
            \}

" LaTeX compilation commands and autocomplete
NeoBundle 'LaTeX-Box-Team/LaTeX-Box', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': 'tex',
            \ },
            \ 'external_commands': 'latexmk',
            \}
let g:LatexBox_latexmk_preview_continuously=1   " Auto-compile TeX on save
let g:LatexBox_build_dir='latexmk'              " Build files are in 'latexmk'

" Jinja2 template syntax highlighting
NeoBundle 'Glench/Vim-Jinja2-Syntax', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': 'jinja',
            \ },
            \}

" Better JavaScript syntax highlighting and indentation
NeoBundle 'pangloss/vim-javascript', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': 'javascript',
            \ },
            \}

" JavaScript omnicompletion
NeoBundle 'marijnh/tern_for_vim', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': 'javascript',
            \ },
            \ 'build': {
            \   'unix': 'npm install',
            \ },
            \ 'build_commands': 'npm',
            \}

" JSON Highlight and indent plugin
NeoBundle 'elzr/vim-json', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': 'json',
            \ },
            \}

" Syntax highlighting, indentation, etc. for haxe
NeoBundle 'jdonaldson/vaxe', {
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
NeoBundle 'euclio/vim-instant-markdown', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': 'markdown',
            \ },
            \ 'disabled': &shell =~ 'fish\>',
            \ 'build': {
            \   'unix': 'npm install euclio/instant-markdown-d',
            \   'windows': 'npm install euclio/instant-markdown-d',
            \ }
            \}

" Haskell omnifunc
NeoBundle 'eagletmt/neco-ghc', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': 'haskell',
            \ },
            \ 'external_commands': 'ghc-mod',
            \}

" Syntax highlighting for fish scripts
NeoBundle 'kballard/vim-fish', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': 'fish',
            \ },
            \}

NeoBundle 'othree/html5.vim', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': 'html',
            \ },
            \}

NeoBundle 'hail2u/vim-css3-syntax', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': ['css', 'scss'],
            \ },
            \}

NeoBundle 'digitaltoad/vim-jade', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': 'jade',
            \ },
            \}

NeoBundle 'alisdair/vim-armasm', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': 'armasm',
            \ },
            \}

NeoBundle 'wting/rust.vim', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': 'rust',
            \ },
            \}

NeoBundle 'cespare/vim-toml', {
            \ 'lazy': 1,
            \ 'autoload': {
            \   'filetypes': 'toml',
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

call neobundle#end()
