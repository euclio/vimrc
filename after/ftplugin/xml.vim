" vim initially detects typescript files as xml. In this case, we exit early to
" avoid picking up unwanted configuration.
if expand('%:e') ==# 'ts'
  finish
endif

" Treat xml just like html
source $VIMHOME/after/ftplugin/html.vim
