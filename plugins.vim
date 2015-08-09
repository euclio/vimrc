" =============================================================================
" Plugin Manager Setup
" =============================================================================
"
" Install the plugin manager if it doesn't exist
let s:plugins=$VIMDATA . '/bundle'
let s:plugin_manager=$VIMHOME . '/autoload/plug.vim'
let s:plugin_url='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

if empty(glob(s:plugin_manager))
  echom 'vim-plug not found. Installing...'
  if executable('curl')
    silent exec '!curl -fLo ' . s:plugin_manager . ' --create-dirs ' .
        \ s:plugin_url
  elseif executable('wget')
    call mkdir(fnamemodify(s:plugin_manager, ':h'), 'p')
    silent exec '!wget --force-directories --no-check-certificate -O ' .
        \ expand(s:plugin_manager) . ' ' . s:plugin_url
  else
    echom 'Could not download plugin manager. No plugins were installed.'
    finish
  endif
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
" Dependencies
" =============================================================================
" Google plugins have some required setup...
Plug 'google/vim-maktaba'

" Workaround for vim-maktaba#158
if has('nvim')
  let &rtp .= ',' . s:plugins . '/vim-maktaba'
  call maktaba#json#python#Disable()
endif

Plug 'google/vim-glaive'

" =============================================================================
" Interface
" =============================================================================
"
" Syntax checking on save
Plug 'scrooloose/syntastic'
" Languages with slow checkers should only be checked manually.
let g:syntastic_mode_map = {
      \ "passive_filetypes": ["scala"]
      \}
let g:syntastic_vim_checkers = ['vint']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
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

" Place signs to indicate current version control diff
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
  let g_ycm_filetype_blacklist = {
        \ 'rust': 1
        \}
endif

" Snippets
if has('python')
  Plug 'honza/vim-snippets'
  Plug 'SirVer/ultisnips'
  let g:UltiSnipsExpandTrigger='<c-j>'
  let g:UltiSnipsJumpForwardTrigger='<c-j>'
  let g:UltiSnipsJumpBackwardTrigger='<c-k>'
endif

" Automatic completion of parenthesis, brackets, etc.
Plug 'Raimondi/delimitMate'
let delimitMate_expand_cr=1                 " Put new brace on newline after CR

" View highlight groups under cursor
Plug 'gerw/vim-HiLinkTrace'

" On save, create directories if they don't exist
Plug 'dockyard/vim-easydir'

" On Arch Linux, the exuberant-ctags executable is named 'ctags'. Elsewhere, it
" is 'ctags-exuberant'. On Macs, the ctags executable provided is NOT exuberant
" ctags.
"
" Detect OSX
let s:has_mac = 0
if has('unix')
  let s:uname = system('uname -s')
  if s:uname =~ 'Darwin'
    let s:has_mac = 1
  endif
endif

if executable('ctags') && !s:has_mac || executable('ctags-exuberant')
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

" Code formatting
Plug 'google/vim-codefmt'

" Automatically format on save for all filetypes supported by clang-format
autocmd FileType c,cpp,java,javascript,proto,python AutoFormatBuffer

" =============================================================================
" Languages
" =============================================================================
"
" Filetype plugin for Scala and SBT
Plug 'derekwyatt/vim-scala', { 'for': ['scala', 'sbt.scala'] }
Plug 'derekwyatt/vim-sbt', { 'for': 'sbt.scala' }

" LaTeX compilation commands and autocomplete
if executable('latexmk')
  Plug 'LaTeX-Box-Team/LaTeX-Box', { 'for': 'tex' }
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
if has('nvim')
  function! BuildComposer(info)
    if a:info.status != 'unchanged' || a:info.force
      !cargo build --release
      UpdateRemotePlugins
    endif
  endfunction

  Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
  let g:markdown_composer_syntax_theme='hybrid'
elseif executable('npm')
  Plug 'euclio/vim-instant-markdown', {
        \ 'for': 'markdown',
        \ 'do': 'npm install euclio/vim-instant-markdown-d'
        \}
endif

" Haskell omnifunc
if executable('ghc-mod')
  Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
  let g_necoghc_enable_detailed_browse=1          " Show types of symbols
endif

if executable('cargo')
  Plug 'phildawes/racer', { 'for': 'rust', 'do': 'cargo build --release' }
  let g:racer_cmd = s:plugins . '/racer/target/release/racer'
  let $RUST_SRC_PATH=$HOME . '/build/rust/src'

  function! BuildDeoplete(info)
    if a:info.status != 'unchanged' || a:info.force
      UpdateRemotePlugins
    endif
  endfunction

  " Until YouCompleteMe supports Rust, let's use a plugin that does.
  if has('nvim')
    Plug 'Shougo/deoplete.nvim', {
          \ 'for': 'rust',
          \ 'do': function('BuildDeoplete')
          \}
  endif
  let g:deoplete#enable_at_startup=1
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
if !has('gui_running')
  Plug 'godlygeek/CSApprox'
  let g:CSApprox_verbose_level=0      " Disable warnings for <88 colors
endif

call plug#end()

" Google plugin configuration
call glaive#Install()
Glaive codefmt plugin[mappings]
