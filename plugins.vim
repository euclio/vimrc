scriptencoding utf-8

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

" Create a horizontal split at the bottom when installing plugins
let g:plug_window = 'botright new'

" Additional operating system detection
let s:has_mac = 0
let s:has_arch = 0
let s:has_oracle = 0
if has('unix')
  let s:uname = system('uname -s')
  if s:uname =~? 'Darwin'
    let s:has_mac = 1
  else
    let s:issue = system('cat /etc/issue')
    if s:issue =~? 'Arch Linux'
      let s:has_arch = 1
    elseif s:issue =~? 'Oracle Linux'
      let s:has_oracle = 1
    endif
  endif
endif

call plug#begin(s:plugins)

" =============================================================================
" Dependencies
" =============================================================================
" Google plugins have some required setup...
Plug 'google/vim-maktaba'

Plug 'google/vim-glaive'

" =============================================================================
" Interface
" =============================================================================
"
" Syntax checking on save
Plug 'benekastah/neomake'
augroup neomake_after_save
  autocmd!
  autocmd BufReadPost,BufWritePost *
        \ Neomake | if has('nvim') | Neomake! | endif
  autocmd BufReadPost,BufWritePost *.rs if has('nvim') | Neomake! cargo | endif
augroup END
let g:neomake_verbose = 0
let g:neomake_error_sign = {
      \ 'texthl': 'ErrorMsg'
      \ }
let g:neomake_warning_sign = {
      \ 'texthl': 'WarningMsg'
      \ }
" Disable rustc checker
let g:neomake_rust_enabled_makers = []

" Git wrapper
Plug 'tpope/vim-fugitive'

" Perforce wrapper
Plug 'nfvs/vim-perforce'

" Statusline improvements
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline_detect_spell=0
let g:airline_left_alt_sep='▒'
let g:airline_left_sep='▓▒░'
let g:airline_powerline_fonts=1
let g:airline_right_alt_sep='░'
let g:airline_right_sep='░▒▓'
let g:airline_skip_empty_sections = 1
let g:airline_theme='badwolf'
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_min_count=2
let g:airline#extensions#tabline#buffer_nr_show=1
let g:airline#extensions#tabline#tab_min_count=2
let g:airline#extensions#tabline#show_close_button=0
let g:airline#extensions#tabline#left_sep=''
let g:airline#extensions#tabline#right_sep=''
let g:airline#extensions#whitespace#enabled=0

" Extended % matching
runtime macros/matchit.vim

" Place signs to indicate current version control diff
Plug 'mhinz/vim-signify'
let g:signify_vcs_list = ['git', 'svn', 'hg', 'perforce']
let g:signify_sign_change = '~'

" Provides command to rename the current buffer.
Plug 'danro/rename.vim'

" =============================================================================
" Features
" =============================================================================

" Autocompletion
if has('nvim') && has('python3')
  function! DoRemote(arg)
    UpdateRemotePlugins
  endfunction

  Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
  let g:deoplete#enable_at_startup = 1
  inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
  inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<TAB>"

  " Rust
  Plug 'racer-rust/vim-racer'
  let s:rust_src_path='/usr/src/rust/src'
  if !isdirectory(s:rust_src_path)
    " Fallback to a cloned repository
    let s:rust_src_path=$HOME . '/repos/rust/src'
  endif
  let g:racer_cmd=$HOME . '/.cargo/bin/racer'
  let $RUST_SRC_PATH=s:rust_src_path
  let $CARGO_HOME = $HOME . '/.cargo'
endif

" Snippets
if has('python') && v:version >= 704
  Plug 'SirVer/ultisnips', { 'on': [] } | Plug 'honza/vim-snippets'
  let g:UltiSnipsExpandTrigger='<c-j>'
  let g:UltiSnipsJumpForwardTrigger='<c-j>'
  let g:UltiSnipsJumpBackwardTrigger='<c-k>'

  " Avoid conflict with YCM's python
  if s:has_arch
    let g:UltiSnipsUsePythonVersion=3
  else
    let g:UltiSnipsUsePythonVersion=2
  endif
endif

" Automatic completion of parenthesis, brackets, etc.
Plug 'Raimondi/delimitMate'
let g:delimitMate_expand_cr=1                 " Put new brace on newline after CR

" View highlight groups under cursor
Plug 'gerw/vim-HiLinkTrace'

" On save, create directories if they don't exist
Plug 'dockyard/vim-easydir'

" On Arch Linux, the exuberant-ctags executable is named 'ctags'. Elsewhere, it
" is 'ctags-exuberant'. On Macs, the ctags executable provided is NOT exuberant
" ctags.
if executable('ctags') && !s:has_mac || executable('ctags-exuberant')
  Plug 'xolox/vim-misc'       " Dependency for easytags
  Plug 'xolox/vim-easytags'
  let g:easytags_file=$VIMDATA . '/tags'
  if !(has('win32') || has('win64'))
    let g:easytags_async=1
  endif

  " Class outline viewer
  if has('patch-7.0.167')
    Plug 'majutsushi/tagbar'
    nnoremap <f8> :TagbarToggle<cr>
  endif
endif

" Fuzzy file finder
Plug 'junegunn/fzf', { 'dir': $XDG_DATA_HOME . '/fzf', 'do': 'yes n \| ./install' }
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
nnoremap <c-p> :FZF<cr>

" Code formatting
Plug 'google/vim-codefmt'

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

" JSON Highlight and indent plugin
Plug 'elzr/vim-json', { 'for': 'json' }

" Syntax highlighting, indentation, etc. for haxe
Plug 'jdonaldson/vaxe', { 'for': ['haxe', 'hss', 'hxml', 'lime', 'nmml'] }
let g:vaxe_lime_target='flash'                  " Set default target to flash

" Markdown preview
if has('nvim') && executable('cargo')
  function! g:BuildComposer(info)
    if a:info.status !=# 'unchanged' || a:info.force
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
  let g:necoghc_enable_detailed_browse=1          " Show types of symbols
endif

" Syntax highlighting
Plug 'Glench/Vim-Jinja2-Syntax', { 'for': 'jinja' }

Plug 'mustache/vim-mustache-handlebars', { 'for': 'html.handlebars' }

Plug 'pangloss/vim-javascript', { 'for': 'javascript' }

Plug 'kballard/vim-fish', { 'for': 'fish' }

Plug 'othree/html5.vim', { 'for': ['html', 'jinja'] }

Plug 'hail2u/vim-css3-syntax', { 'for': ['css', 'scss'] }

Plug 'digitaltoad/vim-jade', { 'for': 'jade' }

Plug 'alisdair/vim-armasm', { 'for': 'armasm' }

Plug 'rust-lang/rust.vim'
let g:rustfmt_autosave = 1

Plug 'cespare/vim-toml', { 'for': 'toml' }

Plug 'avakhov/vim-yaml', { 'for': 'yaml' }

let $PATH=$PATH . ':' . s:plugins . '/perlomni.vim/bin'
Plug 'c9s/perlomni.vim', { 'for': 'perl' }

Plug 'vim-perl/vim-perl', { 'for': 'perl', 'do': 'make clean try-tiny' }

Plug 'groenewege/vim-less', { 'for': 'less' }

" =============================================================================
" Cosmetic
" =============================================================================
"
" My personal colorscheme
Plug 'euclio/vim-nocturne'

call plug#end()

augroup load_slow_plugins
  autocmd!
  " autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
  "                   \ | call youcompleteme#Enable() | autocmd! load_slow_plugins
  autocmd InsertEnter * call plug#load('ultisnips')
                    \ | autocmd! load_slow_plugins
augroup END
