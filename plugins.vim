scriptencoding utf-8

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

" =============================================================================
" Interface
" =============================================================================

" Signs and highlighting for errors, etc.
let s:error_sign = '✘'
let s:error_hl = 'ErrorMsg'
let s:warning_sign = '♦'
let s:warning_hl = 'WarningMsg'
let s:message_sign = '→'
let s:message_hl = 'Normal'
let s:info_sign = '…'
let s:info_hl = 'Normal'

" Syntax checking on save
Plug 'neomake/neomake'
augroup run_neomake
  autocmd!
  autocmd BufReadPost,BufWritePost * Neomake
augroup END
let g:neomake_open_list = 2
let g:neomake_verbose = 1
let g:neomake_rust_enabled_makers=[]
let g:neomake_error_sign = {
      \ 'text': s:error_sign,
      \ 'texthl': s:error_hl,
      \ }
let g:neomake_warning_sign = {
      \ 'text': s:warning_sign,
      \ 'texthl': s:warning_hl,
      \ }
let g:neomake_message_sign = {
      \ 'text': s:message_sign,
      \ 'texthl': s:message_hl,
      \ }
let g:neomake_info_sign = {
      \ 'text': s:info_sign,
      \ 'texthl': s:info_hl,
      \ }

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
let g:airline#extensions#hunks#enabled=0
let g:airline#extensions#neomake#enabled=1
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_min_count=2
let g:airline#extensions#tabline#buffer_nr_show=1
let g:airline#extensions#tabline#tab_min_count=2
let g:airline#extensions#tabline#show_close_button=0
let g:airline#extensions#tabline#left_sep=''
let g:airline#extensions#tabline#right_sep=''
let g:airline#extensions#whitespace#enabled=1
let g:airline#extensions#whitespace#symbol='µ'
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'

if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif
let g:airline_symbols.linenr = ''

function! AirlineInit()
  call airline#parts#define_raw('colnr', '%2c')
  call airline#parts#define_accent('colnr', 'bold')
  let g:airline_section_z = airline#section#create(['colnr', ':%l'])
endfunction
augroup airline_config
  autocmd!
  autocmd User AirlineAfterInit call AirlineInit()
augroup END

" Extended % matching
runtime macros/matchit.vim

" Place signs to indicate current version control diff
Plug 'mhinz/vim-signify'
let g:signify_vcs_list = ['git', 'svn', 'hg', 'perforce']
let g:signify_sign_change = '~'

" Provides command to rename the current buffer.
Plug 'danro/rename.vim'

Plug 'osyo-manga/vim-anzu'
nmap n <Plug>(anzu-n)
nmap N <Plug>(anzu-N)
nmap * <Plug>(anzu-star)
nmap # <Plug>(anzu-sharp)
let g:anzu_status_format = '%p(%i/%l) '
exe 'map <silent> <leader><leader> :AnzuClearSearchStatus \|' . maparg('<leader><leader>')

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
  Plug 'xolox/vim-easytags' | Plug 'xolox/vim-misc'
  let g:easytags_file=$VIMDATA . '/tags'
  if !(has('win32') || has('win64'))
    let g:easytags_async=1
  endif

  " Class outline viewer
  if has('patch-7.0.167')
    Plug 'majutsushi/tagbar'
    nnoremap <leader>tb :TagbarToggle<cr>
  endif
endif

" Fuzzy file finder
Plug 'junegunn/fzf', { 'dir': $XDG_DATA_HOME . '/fzf', 'do': './install --bin' }
let g:fzf_action = {
      \ 'ctrl-s': 'split',
      \ 'ctrl-v': 'vsplit'
      \ }
nnoremap <c-p> :FZF<cr>

" Undo tree viewer
Plug 'sjl/gundo.vim'

" Unit-testing framework
Plug 'junegunn/vader.vim'

" =============================================================================
" Language Plugins
" =============================================================================

" Language server support
Plug 'autozimu/LanguageClient-neovim', { 'do': ':UpdateRemotePlugins' }
let g:LanguageClient_autoStart = 1

nnoremap <silent> K :call LanguageClient_textDocument_hover()<CR>
nnoremap <silent> gd :call LanguageClient_textDocument_definition()<CR>
nnoremap <silent> <leader>r :call LanguageClient_textDocument_rename()<CR>

let g:LanguageClient_diagnosticsDisplay = {
      \  1: {
      \    'name': 'Error',
      \    'texthl': s:error_hl,
      \    'signText': s:error_sign,
      \    'signTexthl': s:error_hl,
      \  },
      \  2: {
      \    'name': 'Warning',
      \    'texthl': s:warning_hl,
      \    'signText': s:warning_sign,
      \    'signTexthl': s:warning_hl,
      \  },
      \  3: {
      \    'name': 'Information',
      \    'texthl': s:info_hl,
      \    'signText': s:info_sign,
      \    'signTexthl': s:info_hl,
      \  },
      \  4: {
      \    'name': 'Hint',
      \    'texthl': s:message_hl,
      \    'signText': s:message_sign,
      \    'signTexthl': s:message_hl,
      \  },
      \ }
let g:LanguageClient_serverCommands = {}

" Rust language server
if executable('rls')
  let g:LanguageClient_serverCommands['rust'] = ['rls', '+nightly']
endif

" Haskell omnifunc
if executable('ghc-mod')
  Plug 'eagletmt/neco-ghc', { 'for': 'haskell' }
  let g:necoghc_enable_detailed_browse=1          " Show types of symbols
endif

" Perl omnifunc
Plug 'c9s/perlomni.vim', { 'for': 'perl' }
let $PATH.=':' . g:plugins . 'perlomni.vim/bin'

" Markdown automatic HTML preview
if executable('cargo')
  function! g:BuildComposer(info)
    if a:info.status !=# 'unchanged' || a:info.force
      if has('nvim')
        !cargo build --release
      else
        !cargo build --release --no-default-features --features json-rpc
      endif
    endif
  endfunction

  Plug 'euclio/vim-markdown-composer', { 'do': function('BuildComposer') }
  let g:markdown_composer_syntax_theme='hybrid'
endif

" 100+ common filetype plugins
Plug 'sheerun/vim-polyglot'
let g:polyglot_disabled = ['markdown']

" LaTeX
let g:LatexBox_latexmk_preview_continuously=1   " Auto-compile TeX on save
let g:LatexBox_build_dir='latexmk'              " Build files are in 'latexmk'

" Rust
let g:rustfmt_autosave=0                        " Don't rustfmt on save
let g:rustfmt_fail_silently=1                   " Don't report rustfmt errors

" =============================================================================
" Cosmetic
" =============================================================================
"
" My personal colorscheme
Plug 'euclio/vim-nocturne'

augroup load_slow_plugins
  autocmd!
  " autocmd InsertEnter * call plug#load('ultisnips', 'YouCompleteMe')
  "                   \ | call youcompleteme#Enable() | autocmd! load_slow_plugins
  autocmd InsertEnter * call plug#load('ultisnips')
                    \ | autocmd! load_slow_plugins
augroup END
