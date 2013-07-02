" Required for vundle
filetype off

" Install vundle if it doesn't exist
let new_vundle_install=0
let vundle_readme=expand('$VIMHOME/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    let $VUNDLE=$VIMHOME.'/bundle/vundle' 

    echom 'Vundle not found. Installing...'
    echom ''
    if has('win32') || has('win64')
        silent exe '!mkdir' $VIMHOME.'\bundle'
    else
        silent exe '!mkdir -p ' $VIMHOME.'/bundle'
    endif
    exe '!git clone https://github.com/gmarik/vundle' $VUNDLE
    let new_vundle_install=1
endif

" Add vundle to runtime path
set rtp+=$VIMHOME/bundle/vundle
call vundle#rc('$VIMHOME/bundle/')

" Allow vundle to manage itself
Bundle 'gmarik/vundle'

" Syntax checking on save
Bundle 'scrooloose/syntastic'

" Git wrapper
Bundle 'tpope/vim-fugitive'

" Statusline improvements
Bundle 'Lokaltog/vim-powerline'

" Filetype plugin for Scala
Bundle 'derekwyatt/vim-scala'

" Filetree viewer
Bundle 'scrooloose/nerdtree'
map <C-n> :NERDTreeToggle<CR>
" Close vim if NERDTree is the only window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" Allow GUI colorschemes in 256-color or 88-color terminals
Bundle 'CSApprox'
let g:CSApprox_verbose_level=0          " Disable warnings for <88 colors

" Colorschemes
Bundle 'altercation/vim-colors-solarized'

if new_vundle_install
    echom 'Installing all bundles...'
    BundleInstall!
    echom 'If there are errors, they can be safely ignored.'
endif
