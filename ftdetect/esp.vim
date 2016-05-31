" Set esp files as ASP Perl
autocmd BufRead,BufNewFile *.esp set filetype=aspperl
autocmd BufRead,BufNewFile *.esp syn match htmlPreAttr contained "\w\+=[^"][^-]\+" contains=htmlPreProcAttrError,htmlPreProcAttrName
