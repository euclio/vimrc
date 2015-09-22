compiler perl

" Show perldoc for the current file
if has('nvim')
  nnoremap <silent> <leader>pd :split +terminal\ perldoc\ %<cr>
else
  nnoremap <silent> <leader>pd :silent !perldoc %<cr> <bar> :redraw!<cr>
endif

