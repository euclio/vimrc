" Don't dedent labels. Useful when typing the scope resolution operator.
setlocal cinoptions+=L0

" Braces on their own lines, spacing between keywords.
if executable("astyle")
  setlocal equalprg=astyle\ --options=$VIMHOME/astyle
endif
