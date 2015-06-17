" --- START OF Vundle ---
set nocompatible
filetype off

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

    Plugin 'gmarik/Vundle.vim'
    Plugin 'L9'
    Plugin 'FuzzyFinder'
    Plugin 'ervandew/supertab'
    Plugin 'scrooloose/syntastic'
	Plugin 'tpope/vim-fugitive'
	Plugin 'tpope/vim-surround'
	Plugin 'tpope/vim-unimpaired'

    Plugin 'bitc/vim-bad-whitespace'
    Plugin 'chrisbra/Colorizer'

	" html
    Plugin 'nekrox/vim-html-templates-syntax'

	" Javascript
    Plugin 'pangloss/vim-javascript'
    Plugin 'maksimr/vim-jsbeautify'
    Plugin 'beautify-web/js-beautify'

    " Python
    "Plugin 'tmhedberg/SimpylFold'
    Plugin 'klen/python-mode'
	"Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

call vundle#end()
filetype plugin indent on


" --- Configure Plugins


" pymode
" does line numbering by default which is enoying disable
let g:pymode_options = 0

"fuf
let g:fuf_keyOpenTabpage = "<cr>"
let g:fuf_modesDisable = []

"syntastic
"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 0
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_aggregate_errors = 1

let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
let g:syntastic_style_error_symbol = "✗"
let g:syntastic_style_warning_symbol = "⚠"

highlight SyntasticErrorLine guibg=#FCC
highlight SyntasticWarningLine guibg=#FFC
highlight SyntasticStyleErrorLine guibg=#CCF
highlight SyntasticStyleWarningLine guibg=#CCF

highlight SyntasticStyleErrorSign guibg=#99F guifg=#FFF
highlight SyntasticStyleWarningSign guibg=#99F guifg=#FFF

" --- General defaults

syntax on
set nofoldenable
set encoding=utf-8
set fileencoding=utf-8

set smarttab
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

set smartindent
set autoindent

set hlsearch
set spelllang=en_gb
set listchars=tab:→·,eol:¶

if has("gui_running")
    if has("gui_gtk2")
        set guifont=Inconsolata\ 12
    endif
endif


" --- File type specific actions

if has("autocmd")
    filetype on            " enables filetype detection
    filetype plugin on     " enables filetype specific plugins
    filetype indent on

    augroup GroupFileTypes
        autocmd!
        autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab
        autocmd FileType python setlocal ts=4 sts=4 sw=4 expandtab
                    \ complete+=t formatoptions-=t textwidth=79
                    \ commentstring=#%s define=^\s*\\(def\\\\|class\\)
        autocmd FileType html setlocal ts=2 sts=2 sw=2 expandtab
        autocmd FileType jinja setlocal ts=2 sts=2 sw=2 expandtab
        autocmd FileType javascript setlocal ts=2 sts=2 sw=2 expandtab
        autocmd FileType css setlocal ts=2 sts=2 sw=2 expandtab

        autocmd BufNewFile,BufRead *.dtml setfiletype django
        autocmd BufNewFile,BufRead *.html setfiletype jinja
    augroup END
endif


" --- Code beautification
" FIXME need to make this nicer so not keep remapping
" make function to do this

if has("autocmd")
    augroup GroupBeautify
        autocmd!

        " for js
        autocmd FileType javascript noremap <buffer>  <c-f> :call JsBeautify()<cr>
        autocmd FileType javascript vnoremap <buffer>  <c-f> :call RangeJsBeautify()<cr>

        " for html
        autocmd FileType html noremap <buffer> <c-f> :call HtmlBeautify()<cr>
        autocmd FileType html vnoremap <buffer> <c-f> :call RangeHtmlBeautify()<cr>

        " for css or scss
        autocmd FileType css noremap <buffer> <c-f> :call CSSBeautify()<cr>
        autocmd FileType css vnoremap <buffer> <c-f> :call RangeCSSBeautify()<cr>
    augroup END
endif



" FIXME get this working again more portably

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


" --- My wonderful functions

function! ToggleErrors()
    " Syntastic error location panel hide/show
    let old_last_winnr = winnr('$')
    lclose
    if old_last_winnr == winnr('$')
        Errors
    endif
endfunction


function! RandomColour()
    " colour scheme
    let mycolors = split(globpath(&rtp,"**/colors/*.vim"),"\n")
    let chosen = mycolors[localtime() % len(mycolors)]
    exe 'so ' . chosen
    unlet chosen
    unlet mycolors
endfunction


function! ColourColumn()
    " show column limit
    if !exists("w:colorcolumns")
        set cc=81
        let w:colorcolumns = 1
    else
        set cc=0
        unlet w:colorcolumns
    endif
endfunction


function! HexHighlight()
    " Hide/show colours in buffer
    if !exists("w:colorizertoggle")
        execute 'silent ColorHighlight'
        let w:colorizertoggle = 1
    else
        execute 'ColorClear'
        unlet w:colorizertoggle
    endif
endfunction


function! <SID>SynStack()
    " Show syntax highlighting groups for word under cursor
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc


" --- Commands

command! RandomColour call RandomColour()
command! ColourColumn call ColourColumn()


" --- Key mappings

"open new things * whitespace intentional *
nnoremap <C-N> :tabnew

"move between tabs
nnoremap <C-Right> :tabnext <CR>
nnoremap <C-Left> :tabprev <CR>
nnoremap <C-S-Left> :tabfirs <CR>
nnoremap <C-S-Right> :tablas <CR>

"fuf
nnoremap <F2> :FufFile <CR>
nnoremap <F3> :FufMruFile <CR>
nnoremap <C-F2> :FufRenewCache <CR>

" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" Misc
nmap <C-S-P> :call <SID>SynStack()<CR>
nnoremap <silent> <C-e> :<C-u>call ToggleErrors()<CR>
nnoremap <F12> :RandomColour <CR>


" --- Leaders

nmap <silent> <leader>l :set list!<CR>
nmap <silent> <leader>n :set number!<CR>
nmap <silent> <leader>w :ToggleBadWhitespace<CR>
nmap <silent> <leader>e :EraseBadWhitespace<CR>
nmap <silent> <leader>c :ColourColumn<CR>
nmap <silent> <leader>s :set spell!<CR>
nmap <silent> <leader>v :tabedit $MYVIMRC<CR>
nmap <leader>h :call HexHighlight()<CR>

" list moving
nmap <silent> <leader>, :lprev<CR>
nmap <silent> <leader>. :lnext<CR>


" Source the vimrc file after saving it
if has("autocmd")
    augroup GroupVimReload
        autocmd!
        autocmd bufwritepost .vimrc source $MYVIMRC
    augroup END
endif



