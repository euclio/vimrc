" Required for vundle
filetype off

" VIMHOME fix for Windows
if has('win32') || has('win64')
    let $VIMHOME = $HOME.'/vimfiles'
else
    let $VIMHOME = $HOME.'/.vim'
endif

" Install vundle if it doesn't exist
let new_vundle_install=0
let vundle_readme=expand('$VIMHOME/bundle/vundle/README.md')
if !filereadable(vundle_readme)
    echom 'vundle not found. Installing...'
    call mkdir('bundle')
    silent !git clone https://github.com/gmarik/vundle bundle/vundle
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
    echom 'Please restart viM to ensure correct installation.'
endif
