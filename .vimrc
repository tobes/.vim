set nocompatible

filetype on            " enables filetype detection
filetype plugin on     " enables filetype specific plugins

"pathogen bundles
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab
set smartindent
set iskeyword+='

"open new things
nnoremap <C-N> :tabnew
"move between tabs
nnoremap <C-Right> :tabnext 
nnoremap <C-Left> :tabprev 
nnoremap <C-S-Left> :tabfirst 
nnoremap <C-S-Right> :tablast 

"basic options
syntax on
set hlsearch

"fuf
nnoremap <F2> :FufFile 
nnoremap <F3> :FufMruFile 
let g:fuf_keyOpenTabpage = "<cr>"
let g:fuf_modesDisable = []

"Js linting
function! Jslint()
    execute 'w'
    let nose_output = system('js ~/.vim/bin/js/runjslint.js "`cat ' . expand('%') . '`" | python2 ~/.vim/bin/python/format_lint_output.py' )
    execute 'tabnew'
    setlocal buftype=nofile readonly modifiable
    silent put=nose_output
    keepjumps 0d
    setlocal nomodifiable
endfunction

command! Js   call Jslint()
