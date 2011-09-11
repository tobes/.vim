set nocompatible

"pathogen bundles
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

if has("autocmd")
  filetype on            " enables filetype detection
  filetype plugin on     " enables filetype specific plugins

  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
endif

set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set noexpandtab
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

" text formatting see what we have we will use perl's autoformat if is
" it there else try to use par
!perl -e'use Text::Autoformat'
if !v:shell_error
	set formatprg=perl\ -MText\:\:Autoformat\ -e'autoformat{all=>1}'
else
	if executable("par")
		set formatprg=par
	endif
endif


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


" Shortcut to rapidly toggle `set list`
nmap <leader>l :set list!<CR>
set listchars=tab:¿\ ,eol:¬
nmap <leader>n :set number!<CR>
