set nocompatible

"pathogen bundles
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

if has("autocmd")
  filetype on            " enables filetype detection
  filetype plugin on     " enables filetype specific plugins
  filetype indent on

  autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
  autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
endif

set tabstop=4
set softtabstop=4
set shiftwidth=4
set smarttab
set noexpandtab
set smartindent

"open new things * whitespace intentional *
nnoremap <C-N> :tabnew 
"move between tabs
nnoremap <C-Right> :tabnext 
nnoremap <C-Left> :tabprev 
nnoremap <C-S-Left> :tabfirst 
nnoremap <C-S-Right> :tablast 

"basic options
syntax on
set autoindent
set hlsearch
set spelllang=en_gb
set listchars=tab:»\ ,eol:¬

"fuf
nnoremap <F2> :FufFile 
nnoremap <F3> :FufMruFile 
let g:fuf_keyOpenTabpage = "<cr>"
let g:fuf_modesDisable = []

" text formatting see what we have we will use perl's autoformat if is
" it there else try to use par
silent! !perl -e'use Text::Autoformat'
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

" colour scheme
function! RandomColour()
	let mycolors = split(globpath(&rtp,"**/colors/*.vim"),"\n")
	let chosen = mycolors[localtime() % len(mycolors)]
	exe 'so ' . chosen
	unlet chosen
	unlet mycolors
endfunction

nnoremap <F12> :RandomColour 
command! RandomColour  call RandomColour()

" show column limit
function! ColourColumn()
	if !exists("w:colorcolumns")
		set cc=81
		let w:colorcolumns = 1
	else
		set cc=0
		unlet w:colorcolumns
	endif
endfunction

command! ColourColumn call ColourColumn()

" Shortcut to rapidly toggle `set list`
nmap <silent> <leader>l :set list!<CR>
nmap <silent> <leader>n :set number!<CR>
nmap <silent> <leader>w :ToggleBadWhitespace<CR>
nmap <silent> <leader>e :EraseBadWhitespace<CR>
nmap <silent> <leader>c :ColourColumn<CR>
nmap <silent> <leader>s :set spell!<CR>
nmap <silent> <leader>v :tabedit $MYVIMRC<CR>
nmap <leader>h :call HexHighlight()<CR>


" Source the vimrc file after saving it
if has("autocmd")
  autocmd bufwritepost .vimrc source $MYVIMRC
endif

" Show syntax highlighting groups for word under cursor
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc
