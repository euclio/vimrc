compiler perl

" Show perldoc for the current file
if has('nvim')
  nnoremap <silent> <leader>pd :split +terminal\ perldoc\ -T\ %<cr>
else
  nnoremap <silent> <leader>pd :silent !perldoc -T %<cr> <bar> :redraw!<cr>
endif

" Highlight known function tags as functions
highlight link perlFunctionTag Function
