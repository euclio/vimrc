" Automatically wrap lines at 80 characters
setlocal textwidth=80

" Enable syntax highlighting within fences
" FIXME: Java is NOT enabled because it breaks spellchecking in markdown. Weird.
let g:markdown_fenced_languages=[
            \ 'c',
            \ 'cpp',
            \ 'css',
            \ 'html',
            \ 'javascript',
            \ 'python',
            \ 'sh',
            \ 'vim'
            \]

" Let triple backticks behave properly
autocmd FileType markdown let b:delimitMate_nesting_quotes = ['`']
