compiler perl

" Show perldoc for the current file
if has('nvim')
  nnoremap <silent> <leader>pd :split +terminal\ perldoc\ -T\ %<cr>
else
  nnoremap <silent> <leader>pd :silent !perldoc -T %<cr> <bar> :redraw!<cr>
endif

" athena-specific settings
if !empty($ATHENA_HOME)
  setlocal noexpandtab
  setlocal number norelativenumber
  setlocal makeprg=perl\ -MAthena::Lib\ -Wc\ %
endif

" Highlight known function tags as functions
highlight link perlFunctionTag Function
