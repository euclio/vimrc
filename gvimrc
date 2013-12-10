" =============================================================================
" Colorscheme
" =============================================================================
silent! colorscheme nocturne

" Font settings
if has('gui_gtk2')
  set guifont=Inconsolata\ 11
elseif has('gui_win32')
  set guifont=Inconsolata:h11:cDEFAULT
endif

" =============================================================================
" Fix Annoyances
" =============================================================================
" Remove scrollbars, menu, and toolbar
set guioptions-=r
set guioptions-=l
set guioptions-=L
set guioptions-=m
set guioptions-=T

" Force GUI to use text dialogs instead of popups
set guioptions+=c

" Remove visual and audio bell for GUI
set visualbell t_vb=

" Maximize window by default
set lines=999 columns=999

" Avoid visual artifacts on Windows
set linespace=0
set ttyscroll=0
