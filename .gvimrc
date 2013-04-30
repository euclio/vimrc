" " "
" Colorscheme
"
" Use solaized colorscheme with 12pt Inconsolata for GUI
if has('gui_running')
    " Use solarized colorscheme
    set t_Co=256
    set background=dark
    colorscheme slate

    " Font settings
    if has('gui_gtk2')
        set guifont=Inconsolata\ 12
    elseif has('gui_win32')
        set guifont=Inconsolata:h12:cANSI
    endif
endif

" " "
" Fix Annoyances
"
" Remove visual and audio bell for GUI
autocmd GUIEnter * set visualbell t_vb=
