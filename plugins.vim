" =============================================================================
" Plugin Manager Setup
" =============================================================================
"
" Install the plugin manager if it doesn't exist
let s:plugins=$VIMDATA . '/bundle'
let s:plugin_manager=s:plugins . '/vim-plug'

if empty(glob(s:plugin_manager))
  echom 'vim-plug not found. Installing...'
  silent exec '!curl -fLo ' . s:plugin_manager/autoload/vim-plug .
      \ ' --create-dirs ' .
      \ 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
  augroup vimplug
    autocmd!
    autocmd VimEnter * PlugInstall
  augroup END
endif

" Make sure vim-plug is on the runtime path
let &rtp .= ',' . s:plugin_manager

" Create a horizontal split at the bottom when installing plugins
let g:plug_window = 'botright new'

call plug#begin(s:plugins)

" =============================================================================
" Interface
" =============================================================================
"
" Syntax checking on save
Plug 'scrooloose/syntastic'
let g:syntastic_scala_checkers = []     " Don't check Scala -- it's too slow
let g:syntastic_vim_checkers = ['vint']
let g:syntastic_check_on_wq = 0

" Git wrapper
Plug 'tpope/vim-fugitive'

" Statusline improvements
Plug 'bling/vim-airline'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_min_count=2
let g:airline#extensions#tabline#buffer_nr_show=1
let g:airline#extensions#tabline#tab_min_count=2
let g:airline#extensions#tabline#show_close_button=0
let g:airline#extensions#tabline#left_sep=''
let g:airline#extensions#tabline#right_sep=''
let g:airline_powerline_fonts=1
let g:airline_left_sep=''
let g:airline_left_alt_sep='▶'
let g:airline_right_sep=''
let g:airline_right_alt_sep='◀'
let g:airline_theme='badwolf'

" Extended % matching
runtime macros/matchit.vim

Plug 'mhinz/vim-signify'
let g:signify_vcs_list = ['git', 'svn', 'hg']
let g:signify_sign_change = '~'

" =============================================================================
" Features
" =============================================================================
"
" Autocompletion for Python and C-like languages
if has('patch-7.3.584') && has('python') && executable('cmake')
  Plug 'Valloric/YouCompleteMe', {
      \ 'do': './install.sh --clang-completer --system-libclang'
      \}
  let g:ycm_confirm_extra_conf=0          " Disable .ycm_extra_conf confirmation
  let g:EclimCompletionMethod='omnifunc'  " Let YCM use Eclipse autocomplete
  " Allow automatic neco-ghc completions
  let g:ycm_semantic_triggers={
              \ 'haskell': ['.'],
              \}
endif

" Snippets
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
let g:UltiSnipsExpandTrigger='<c-j>'
let g:UltiSnipsJumpForwardTrigger='<c-j>'
let g:UltiSnipsJumpBackwardTrigger='<c-k>'

" Automatic completion of parenthesis, brackets, etc.
Plug 'Raimondi/delimitMate'
let delimitMate_expand_cr=1                 " Put new brace on newline after CR

" View highlight groups under cursor
Plug 'gerw/vim-HiLinkTrace'

" On save, create directories if they don't exist
Plug 'dockyard/vim-easydir'

" On Arch Linux, the exuberant-ctags executable is named 'ctags'. Elsewhere, it
" is 'ctags-exuberant'
if executable('ctags') || executable('ctags-exuberant')
  Plug 'xolox/vim-misc'       " Dependency for easytags
  Plug 'xolox/vim-easytags'
  let g:easytags_file=$VIMDATA . '/tags'

  " Class outline viewer
  if has('patch-7.0.167')
    Plug 'majutsushi/tagbar'
    nnoremap <f8> :TagbarToggle<cr>
  endif
endif

" Fuzzy file finder
Plug 'kien/ctrlp.vim'
let g:ctrlp_user_command = [
      \ '.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard'
      \]

" =============================================================================
" Languages
" =============================================================================
"
" Filetype plugin for Scala
Plug 'derekwyatt/vim-scala', { 'for': 'scala' }

" LaTeX compilation commands and autocomplete
if executable('latexmk')
  Plug 'euclio/LaTeX-Box', { 'for': 'tex' }
  let g:LatexBox_latexmk_preview_continuously=1   " Auto-compile TeX on save
  let g:LatexBox_build_dir='latexmk'              " Build files are in 'latexmk'
endif

" JavaScript omnicompletion
if executable('npm')
  Plug 'marijnh/tern_for_vim', { 'for': 'javascript', 'do': 'npm install' }
endif

" JSON Highlight and indent plugin
Plug 'elzr/vim-json', { 'for': 'json' }

" Syntax highlighting, indentation, etc. for haxe
Plug 'jdonaldson/vaxe', { 'for': ['haxe', 'hss', 'hxml', 'lime', 'nmml'] }
let g:vaxe_lime_target='flash'                  " Set default target to flash

" Markdown preview
Plug 'euclio/vim-instant-markdown', {
      \ 'for': 'markdown',
      \ 'do' : 'npm install euclio/instant-markdown-d'
      \}

" Haskell omnifunc
if executable('ghc-mod')
  Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
  let g_necoghc_enable_detailed_browse=1          " Show types of symbols
endif

" Syntax highlighting
Plug 'Glench/Vim-Jinja2-Syntax', { 'for': 'jinja' }

Plug 'pangloss/vim-javascript', { 'for': 'javascript' }

Plug 'kballard/vim-fish', { 'for': 'fish' }

Plug 'othree/html5.vim', { 'for': ['html', 'jinja'] }

Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'scss'] }

Plug 'digitaltoad/vim-jade', { 'for': 'jade' }

Plug 'alisdair/vim-armasm', { 'for': 'armasm' }

Plug 'wting/rust.vim', { 'for': 'rust' }

Plug 'cespare/vim-toml', { 'for': 'toml' }

" =============================================================================
" Cosmetic
" =============================================================================
"
" My personal colorscheme
Plug 'euclio/vim-nocturne'

" Allow GUI colorschemes in 256-color or 88-color terminals
if !has('gui')
  Plug 'godlygeek/CSApprox'
  let g:CSApprox_verbose_level=0      " Disable warnings for <88 colors
endif

call plug#end()
