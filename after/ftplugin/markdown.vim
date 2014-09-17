" Enable spellchecking
setlocal spell spelllang=en_us

" Automatically wrap lines at 80 characters
setlocal textwidth=80

" Enable syntax highlighting within fences
let g:markdown_fenced_languages=[
            \ 'c',
            \ 'cpp',
            \ 'css',
            \ 'html',
            \ 'java',
            \ 'javascript',
            \ 'python',
            \ 'scala',
            \ 'sh',
            \]

" Let triple backticks behave properly
autocmd FileType markdown let b:delimitMate_nesting_quotes = ['`']

" Automatically format paragraphs
setlocal formatoptions+=a
