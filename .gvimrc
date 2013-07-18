" =============================================================================
" Colorscheme
" =============================================================================
colorscheme nocturne

" Font settings
if has('gui_gtk2')
  set guifont=Inconsolata\ 12
elseif has('gui_win32')
  set guifont=Inconsolata:h12:cANSI
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

" Remove visual and audio bell for GUI
set visualbell t_vb=
