set nocompatible

"pathogen bundles
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab
set smartindent

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


