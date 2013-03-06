" Required for vundle
filetype off

let $VIMHOME=$HOME.'/.vim'

" VIMHOME fix for Windows
if has('win32') || has('win64')
    let $VIMHOME=$HOME.'\vimfiles'
endif

let $VUNDLE=$VIMHOME.'/bundle/vundle'

" Install vundle if it doesn't exist
let new_vundle_install=0
let vundle_readme=expand('$VIMHOME/bundle/vundle/README.md')
if !filereadable(vundle_readme)
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

" My bundles
" 
" Solarized Color Scheme (the best!)
Bundle 'altercation/vim-colors-solarized'

" Syntax checking on save
Bundle 'scrooloose/syntastic'

" Git wrapper
Bundle 'tpope/vim-fugitive'

" Statusline improvements
Bundle 'Lokaltog/vim-powerline'

" Filetype plugin for Scala
Bundle 'derekwyatt/vim-scala'

if new_vundle_install
    echom 'Installing all bundles...'
    BundleInstall!
    echom 'If there are errors, they can be safely ignored.'
endif
