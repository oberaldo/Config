" -*- vim: set sts=2 sw=2 et fdm=marker: -------------  vim modeline -*-

" Basic Settings -------------------------------------- {{{1
syntax on
set nocompatible
filetype plugin indent on
let g:mapleader = " "

set sw=2 sts=2 et nu sr
set diffopt=filler,context:3
set display=lastline
set hidden
set hlsearch
set incsearch
set nrformats=hex
set ruler
set showcmd
set isfname-==
set shortmess+=s
set tags=./tags,tags,./../tags,./../../tags,./../../../tags
set title
set whichwrap=b,s,[,]
set wildcharm=<tab>
set wildmenu
set wildmode=list:longest,list:full
set wildignore=*.o,*.bak,*.byte,*.native,*~,*.sw?,*.aux,*.toc,*.hg,*.git,*.svn,*.hi,*.so,*.a,*.pyc,*.aux,*.toc,*.exe,*.cm?,*.zi,*.zo
"set autochdir
set winaltkeys=no
set scrolloff=3 scrolljump=5
set showbreak=↪
set sidescroll=10 sidescrolloff=10
set switchbuf=useopen
"set ignorecase smartcase
set timeoutlen=300
set ttimeoutlen=0
set matchpairs=(:),[:],{:},<:>,':',":"
set laststatus=2

set backup
set backupdir=~/.vimtmp/backup//
set directory=~/.vimtmp/swap//
set noswapfile
if has('persistent_undo')
  set undofile
  set undolevels=200
  set undodir=~/.vimtmp/undo
end
set viminfo+=n~/.vimtmp/viminfo

" set backspace=indent,eol,start
set history=200

set fileencodings=ucs-bom,utf8,cp936,gbk,big5,euc-jp,euc-kr,gb18130,latin1

if executable('par')
  set formatprg="par rTbgqR B=.,?_A_a Q=_s>|"
el
  set formatprg=fmt
en
set formatoptions+=nj " support formatting of numbered lists
set guiheadroom=20

" tabs and spaces
set listchars+=tab:▸\ ,trail:⋅,nbsp:⋅
" eols and others
set listchars+=eol:¬,extends:»,precedes:«

" highlight columns after 'textwidth'
set colorcolumn=+1,+2,+4,+5,+6,+7,+8

if has('mouse')
  set mouse=a
endif

if has("gui_running")
  " Ctrl-F12 Toggle Menubar and Toolbar
  nnoremap <silent> <C-F12> :
    \ if &guioptions =~# 'T' <Bar>
      \ set guioptions-=T <Bar>
      \ set guioptions-=m <Bar>
    \ else <Bar>
      \ set guioptions+=T <Bar>
      \ set guioptions+=m <Bar>
    \ endif<CR>

  set guioptions-=T
  set guioptions-=m
  " no scroll bars
  set guioptions-=r
  set guioptions-=L
endif

" Status Line ----------------------------------------- {{{1
set laststatus=2

set statusline=%#ColorColumn#%2f              " buffer number
set statusline+=%*»                           " separator
set statusline+=%<                            " truncate here
set statusline+=%*»                           " separator
set statusline+=%*»                           " separator
set statusline+=%#DiffText#%m                 " modified flag
set statusline+=%r                            " readonly flag
set statusline+=%*»                           " separator
set statusline+=%#CursorLine#(%l/%L,%c)%*»    " line no./no. of lines,col no.
set statusline+=%=«                           " right align the rest
set statusline+=%#Cursor#%02B                 " value of current char in hex
set statusline+=%*«                           " separator
set statusline+=%#ErrorMsg#%o                 " byte offset
set statusline+=%*«                           " separator
set statusline+=%#Title#%y                    " filetype
set statusline+=%*«                           " separator
set statusline+=%#ModeMsg#%3p%%               " % through file in lines
set statusline+=%*                            " restore normal highlight
" Fonts ----------------------------------------------- {{{1
if has("gui_running")
  " Envy Code R
  " http://damieng.com/blog/2008/05/26/envy-code-r-preview-7-coding-font-released
  " set guifont=Monaco\ 15
  " set guifont=Inconsolata\ 15
  " set guifont=Monofur\ 16
  set guifont=Fantasque\ Sans\ Mono\ 18
  set guifontwide=Source\ Han\ Sans\ 15
endif

" Colorschemes ---------------------------------------- {{{1
set background=dark
if has("gui_running")
  "colorscheme badwolf
  "colorscheme harlequin
  "colorscheme molokai
  "colorscheme hemisu
  colorscheme hybrid
else
  set t_Co=256
  "colorscheme bocau
  colorscheme hybrid
endif

" Functions --------------------- {{{1
" DiffOrig {{{2
" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vnew | setlocal bt=nofile bh=wipe nobl noswf | r ++edit # | 0d_ | diffthis
  \ | wincmd p | diffthis
endif

" ErrorsToggle & QFixToggle {{{2
function! ErrorsToggle()
  if exists("g:is_error_window")
    lclose
    unlet g:is_error_window
  else
    botright lwindow 5
    let g:is_error_window = 1
  endif
endfunction

"command! -bang -nargs=? QFixToggle call QFixToggle(<bang>0)
function! QFixToggle()
  if exists("g:qfix_win")
    cclose
    unlet g:qfix_win
  else
    botright copen 5
    let g:qfix_win = 1
  endif
endfunction

" StripTrailingWhitespace {{{2
function! StripTrailingWhitespace()
  " To disable this function, either set ft as keewhitespace prior saving
  " or define a buffer local variable named keepWhitespace
  if &ft =~ 'whitespace\|keep_whitespace' || exists('b:keep_whitespace')
    return
  endif
  let l:savedview = winsaveview()
  silent! %s/\s*$//e
  call winrestview(l:savedview)
endfunction

" MatchUnwantedWhitespaces {{{2
fu! MatchUnwantedWhitespaces()
  " Show all trailing whitespaces: /\s\+$/
  " and spaces followed by tabs:   / \+\t\+\s*/
  " and tabs followed by spaces:   /\t\+ \+\s*/
  " combine them together: /\s\+$\| \+\t\+\s*\|\t\+ \+\s*/
  if bufname('%') != '' && bufname('%') != 'vimfiler:explorer'
    if exists('b:showextrawhitespace') && b:showextrawhitespace == 0
      hi clear ExtraWhitespace
      match none ExtraWhitespace
    else
      hi ExtraWhitespace ctermbg=red guibg=red
      match ExtraWhitespace /\s\+$\| \+\t\+\s*\|\t\+ \+\s*/
    endif
  en
endf
fu! ToggleUnwantedWhitespaces()
  if exists('b:showextrawhitespace') && b:showextrawhitespace == 0
    let b:showextrawhitespace = 1
  else
    let b:showextrawhitespace = 0
  endif
  call MatchUnwantedWhitespaces()
endf
" VSetSearch {{{2
" makes * and # work on visual mode too.
function! s:VSetSearch(cmdtype)
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, a:cmdtype.'\'), '\n', '\\n', 'g')
  let @s = temp
endfunction
" Autocommands ---------------------------------------- {{{1
if has("autocmd")
  aug C_support
    au!
    au FileType c,cpp :call C_init()
    au BufEnter *.cpp let b:fswitchdst = 'hpp,hh,h' | let b:fswitchlocs = './,../include'
    au BufEnter *.cc let b:fswitchdst = 'hh,h' | let b:fswitchlocs = '.,../include'
    au BufEnter *.hh let b:fswitchdst = 'cpp,cc' | let b:fswitchlocs = '.'
    au BufEnter *.h let b:fswitchdst = 'cpp,cc' | let b:fswitchlocs = '.'
    au FileType make setl ts=8 sts=0 sw=8 noet
  aug CoffeeScript_support
    au!
    au BufNewFile,BufRead *.iced setfiletype coffee
  aug Fortran_support
    au!
    au FileType fortran :call Fortran_init()
  aug JavaScript_support
    au!
    au FileType javascript :call JavaScript_init()
  aug MarkDown_support
    au!
    au FileType markdown :call MarkDown_init()
  aug OCaml_support
    au!
    au FileType ocaml :call OCaml_init()
  aug Python_support
    au!
    au FileType python :call Python_init()
  aug Ruby_support
    au!
    au FileType ruby :call Ruby_init()
  aug Rust_support
    au!
    au FileType rust :call Rust_init()
  aug Tex_support
    au!
    au FileType tex :call Tex_init()
  " Show trailing whitespaces when necessary {{{2
  " That is, most of the cases other than editing source code in Whitespace,
  " the programming language.
  augroup show_whitespaces
    au!
    " Make sure this will not be cleared by colorscheme
    "autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
    " Highlight unwanted whitespaces
    autocmd BufWinEnter,WinEnter,InsertLeave * call MatchUnwantedWhitespaces()
    " In insert mode, show trailing whitespaces except when typing at the end
    " of a line
    "autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
    " Show whitespaces in insert mode
    autocmd InsertEnter * set list
    " and turn it off when leave insert mode
    autocmd InsertLeave * set nolist
    " Clear highlight when lose focus
    autocmd WinLeave * call clearmatches()
  aug Textify
    au!
    au BufNewFile,BufRead *.txt,*.doc,*.pdf setl ft=txt
    au BufReadPre *.doc,*.class,*.pdf setl ro
    au BufReadPost *.doc silent %!antiword "%"
    au BufRead *.class exe 'silent %!javap -c "%"' | setl ft=java
    au BufReadPost *.pdf silent %!pdftotext -nopgbrk "%" -
  aug misc
    au!
    " When editing a file, always jump to the last known cursor position.
    " Don't do it when the position is invalid or when inside an event handler
    " (happens when dropping a file on gvim).
    " Also don't do it when the mark is in the first line, that is the default
    " position when opening a file.
    autocmd BufReadPost *
      \ if line("'\"") > 1 && line("'\"") <= line("$") |
      \   exe "normal! g`\"" |
      \ endif
    " turn on spell checker for commit messages
    au FileType gitcommit,hgcommit setlocal spell
    " and emails and plain text files
    au FileType mail,text setlocal spell
    " except 'help' files
    au BufEnter *.txt if &filetype == 'help' | setlocal nospell | endif
    " au FileType * exe('setl dictionary+='.$VIMRUNTIME.'/syntax/'.&filetype.'.vim')

    au Filetype dot let &makeprg="dot -Tpng -O -v % && feh %.png"
    au Filetype r let &makeprg="R <% --vanilla"
    au Filetype ocaml let &makeprg='ocaml %'
    "au FileType tex let &makeprg = 'xelatex -shell-escape -interaction=nonstopmode % && xdotool key Super+4'
  aug misc
    au BufWritePost .Xresources sil !xrdb %
  aug end
endif


" Plugins --------------------------------------------- {{{1
" Vundle ---------------------------------------------- {{{2
if 1 || has("gui_running")
  filetype off
  set rtp+=~/.vim/bundle/vundle/
  call vundle#rc()

  Bundle 'gmarik/vundle'
  Bundle 'AndrewRadev/splitjoin.vim'
  Bundle 'Rykka/colorv.vim'
  Bundle 'SirVer/UltiSnips'
  Bundle 'tpope/vim-dispatch'
  Bundle 'tpope/vim-endwise'
  Bundle 'tpope/vim-eunuch'
  Bundle 'ppwwyyxx/vim-PinyinSearch'
  Bundle 'vim-scripts/VisIncr'
  Bundle 'tpope/vim-unimpaired'

  " Window
  "Bundle 'bling/vim-airline'
  Bundle 'majutsushi/tagbar'
  "Bundle 'vim-scripts/ZoomWin' neovim
  Bundle 'mhinz/vim-startify'
  Bundle 'sjl/gundo.vim'

  " Tools
  Bundle 'chrisbra/NrrwRgn'
  Bundle 'dhruvasagar/vim-table-mode'
  Bundle 'Lokaltog/vim-easymotion'
  Bundle 'Shougo/neocomplete.vim'
  Bundle 'Shougo/neomru.vim'
  Bundle 'Shougo/unite.vim'
  Bundle 'Shougo/vimfiler.vim'
  Bundle 'Shougo/vimproc.vim'
  Bundle 'Shougo/vimshell.vim'
  Bundle 'airblade/vim-gitgutter'
  "Bundle 'vim-scripts/surfer.vim' neovim
  Bundle 'haya14busa/incsearch.vim'
  Bundle 'glts/vim-textobj-comment'
  Bundle 'glts/vim-textobj-indblock'
  Bundle 'godlygeek/tabular'
  Bundle 'kana/vim-textobj-user'
  Bundle 'lucapette/vim-textobj-underscore'
  Bundle 'nathanaelkane/vim-indent-guides'
  Bundle 'qstrahl/vim-matchmaker'
  Bundle 'rhysd/clever-f.vim'
  Bundle 'rhysd/vim-clang-format'
  Bundle 'rking/ag.vim'
  Bundle 'scrooloose/nerdcommenter'
  Bundle 'scrooloose/syntastic'
  Bundle 'terryma/vim-multiple-cursors'
  Bundle 'terryma/vim-expand-region'
  Bundle 'thinca/vim-quickrun'
  Bundle 'tommcdo/vim-exchange'
  Bundle 'tpope/vim-abolish'
  Bundle 'tpope/vim-fugitive'
  Bundle 'tpope/vim-surround'

  " FileTypes
  "Bundle 'R-plugin'
  "Bundle 'Superbil/llvm.vim'
  "Bundle 'danchoi/ri.vim'
  "Bundle 'emmet'
  "Bundle 'pytest.vim'
  "Bundle 'python-mode'
  "Bundle 'vimside'
  Bundle 'LaTeX-Box-Team/LaTeX-Box'
  "Bundle 'RubyJump' neovim
  "Bundle 'Valloric/YouCompleteMe'
  Bundle 'davidhalter/jedi-vim'
  Bundle 'derekwyatt/vim-fswitch'
  Bundle 'gkz/vim-ls'
  Bundle 'marijnh/tern_for_vim'
  Bundle 'spf13/PIV'
  "Bundle 'tpope/vim-rails' " neovim
  "Bundle 'vim-ruby/vim-ruby' " neovim
  Bundle 'wting/rust.vim'
  Bundle 'zah/nimrod.vim'

  " Syntax
  Bundle 'chrisbra/csv.vim'
  Bundle 'def-lkb/ocp-indent-vim'
  Bundle 'digitaltoad/vim-jade'
  Bundle 'evanmiller/nginx-vim-syntax'
  Bundle 'gorodinskiy/vim-coloresque'
  Bundle 'groenewege/vim-less'
  Bundle 'hail2u/vim-css3-syntax'
  Bundle 'kchmck/vim-coffee-script'
  Bundle 'nvie/vim-flake8'
  Bundle 'sheerun/vim-polyglot'
  Bundle 'slim-template/vim-slim'
  Bundle 'tpope/vim-markdown'
  Bundle 'wavded/vim-stylus'


  filetype plugin indent on    " required!

  "so ~/.opam/system/share/vim/syntax/ocp-indent.vim
  so /usr/share/gtags/gtags.vim
  ru macros/matchit.vim

  " TODO neovim
  let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
  execute "set rtp+=" . g:opamshare . "/merlin/vim"
  execute "set rtp+=" . g:opamshare . "/merlin/vimbufsync"
  let g:syntastic_ocaml_checkers=['merlin']
endif
" EasyMotion {{{2
let g:EasyMotion_do_mapping = 1
let g:EasyMotion_leader_key = ","
" FSwitch {{{2
command! A FSHere
command! AV FSSplitRight
" GitGutter {{{2
let g:gitgutter_enabled = 0
" Syntastic {{{2
let g:syntastic_loc_list_height=5
let g:syntastic_stl_format="Err:%fe %e,%w"
let g:syntastic_cpp_compiler = 'clang++'
"let g:syntastic_cpp_compiler_options = '-std=c++11 -isystem/usr/lib/gcc/x86_64-unknown-linux-gnu/5.1.0/include -fopenmp'
let g:syntastic_cpp_compiler_options = '-std=c++11 -fopenmp -Wno-shift-op-parentheses -Wno-bitwise-op-parentheses'
" Tagbar {{{2
let g:tagbar_autofocus = 1
let g:tagbar_autoshowtag = 1
" UltiSnips {{{2
let g:UltiSnipsExpandTrigger = "<Tab>"
let g:UltiSnipsJumpForwardTrigger = "<Tab>"
let g:UltiSnipsJumpBackwardTrigger = "<S-Tab>"
" local snippets only:
let g:UltiSnipsSnippetDirectories = ["UltiSnips"]
" vsplit the snippets edit window
let g:UltiSnipsEditSplit = 'vertical'
" Unite {{{2
if executable('ag')
  let g:unite_source_grep_command = 'ag'
  let g:unite_source_grep_default_opts = '--line-numbers --nocolor --nogroup --smart-case'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
  let g:unite_source_grep_command='ack'
  let g:unite_source_grep_default_opts='--no-heading --no-color -C4'
  let g:unite_source_grep_recursive_opt=''
endif
" VimFiler {{{2
let g:vimfiler_as_default_explorer=1
let g:vimfiler_ignore_pattern = '^\.\|\.\%(byte\|cm.\|doc\|native\|o\|ppt\|pdf\|zi\|zo\)$'
" YouCompleteMe {{{2
let g:rust_recommended_style = 0
let g:ycm_global_ycm_extra_conf = $HOME . "/.vim/static/ycm_extra_conf.py"
let g:ycm_key_detailed_diagnostics = "<Leader>yd"
let g:ycm_key_invoke_completion = "<F5>"
let g:ycm_complete_in_comments = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:ycm_confirm_extra_conf = 0
let g:ycm_cache_omnifunc = 0
let g:ycm_filetype_blacklist = {'markdown' : 1,  'txt' : 1, 'help' : 1}
let g:ycm_auto_trigger = 0
" Misc --------------------- {{{1
" vim hacks #181
" Open junk file."{{{
command! -nargs=0 JunkFile call s:open_junk_file()
function! s:open_junk_file()
  let l:junk_dir = '/tmp/.junk'. strftime('/%Y/%m')
  if !isdirectory(l:junk_dir)
    call mkdir(l:junk_dir, 'p')
  endif

  let l:filename = input('Junk Code: ', l:junk_dir.strftime('/%Y-%m-%d-%H%M%S.'))
  if l:filename != ''
    execute 'edit ' . l:filename
  endif
endfunction "}}}

" Beginning & End
noremap H ^
noremap L g_

" Open a Quickfix window for the last search.
nnoremap <silent> <leader>/ :execute 'vimgrep /'.@/.'/g %'<CR>:botright copen<CR>

" Paste toggle
set pastetoggle=<F7>

map /  <Plug>(incsearch-forward)
map ?  <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

au BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$") |
      \   exe "normal g`\"" |
      \ endif

nn K :silent !zeal --query "<cword>" & wmctrl -a zeal <cr>

" ; :
nn ; :
nn : ;
vn ; :
vn : ;

ino jk <esc>

" surf
nnoremap <leader>sf :Surf<cr>

" SplitJoin
vnoremap <leader>sj :SplitJoinJoin<cr>
vnoremap <leader>sJ :SplitJoinSplit<cr>

" clang-format
let g:clang_format#style_options = {
      \ "AccessModifierOffset" : -2,
      \ "AllowShortIfStatementsOnASingleLine" : "true",
      \ "AlwaysBreakTemplateDeclarations" : "true",
      \ "Standard" : "C++11",
      \ "BreakBeforeBraces" : "Stroustrup"}

" Command-line editing
cnoremap <C-R><C-L> <C-R>=getline('.')<CR>

let g:haddock_browser = "firefox"
autocmd BufRead *.hs setlocal equalprg=~/bin/pp-haskell.hs

let g:Tex_Flavor='latex'
let g:Tex_CompileRule_pdf = 'xelatex -interaction=nonstopmode $*'

fu! C_init()
  setl cino+=g0,:0,l1,N-s,t0,(0
  "setl mps+==:;  neovim
  setl tags+=~/.vim/static/cpp                        " core in cpp
  setl dictionary=~/.vim/dict/cpp
  abbr #i #include
  setl syntax=cpp11.doxygen
  "let &makeprg="clang++ % -g -Wall -Wextra -O0 -std=c++11 -o %<"
  syn keyword cppType real_t Vec Vec2D Vector Matrix Plane Sphere Geometry Ray Color Img imgptr
  syn keyword cppSTL priority_queue hypot isnormal isfinite isnan shared_ptr make_shared numeric_limits move
  syn keyword cppSTLType T
  noremap <buffer> [[ ?{<cr>w99[{
  noremap <buffer> ][ /}<cr>b99]}
  map <buffer> ]] j0[[%/{<cr>
  map <buffer> [] k$][%?}<cr>

  ia <buffer> re return
  ia <buffer> return a<bs>

  command! A FSHere
  command! AV FSSplitRight
endf

fu! CSS_init()
  setl dictionary=~/.vim/dict/css
endf

fu! Fortran_init()
  let g:fortran_free_source = 1
endf

fu! JavaScript_init()
  nnoremap <buffer> [D :TernDef<CR>
  nnoremap <buffer> [I :TernRefs<CR>
endf

fu! MarkDown_init()
  ia <buffer> ``` ```<cr>```<up><end><esc>
  ia <buffer> more <!-- more -->
endf

fu! OCaml_init()
  setl isk-=.
endf

fu! Python_init()
  ia <buffer> #! #!/usr/bin/env python
  ia <buffer> #e # -*- coding: utf=8 -*-
  syn keyword pythonDecorator self
  " Setting 'python_space_error_highlight' = 1 will only highlight mixed
  " tabs and spaces, I go as far as mark all tabs as error.
  autocmd Syntax python syn match ExtraWhitespace /\t/
  nmap <leader>p :call Flake8()<cr>
endf

fu! Ruby_init()
  let &makeprg="ruby -c %"
  imap <C-CR> <CR><CR>end<Esc>-cc
  nnoremap <silent><buffer> ]] :RubyJumpForward<cr>
  nnoremap <silent><buffer> [[ :RubyJumpBackward<cr>
  nnoremap <silent><buffer> ]<space> :RubyJump<cr>

  nnoremap <buffer><space>rc :Rcontroller<space><tab>
  nnoremap <buffer><space>rh :Rhelper<space><tab>
  nnoremap <buffer><space>rj :Rjavascript<space><tab>
  nnoremap <buffer><space>rl :Rlayout<space><tab>
  nnoremap <buffer><space>ro :Rlocale<space><tab>
  nnoremap <buffer><space>rm :Rmodel<space><tab>
  nnoremap <buffer><space>rt :Rspec<space><tab>
  nnoremap <buffer><space>rk :Rtask<space><tab>
  nnoremap <buffer><space>rs :Rstylesheet<space><tab>
  nnoremap <buffer><space>rv :Rview<space><tab>

  ia <buffer> #! #!/usr/bin/env ruby
  ia <buffer> #e # encoding: utf-8
endf

fu! Rust_init()
endf

func! Tex_init()
    " pdf auto refresh preview

    setl nocursorline                                " for performance
    hi clear Conceal
    setl sw=2 sts=2 expandtab
    setl textwidth=150
    setl errorformat=aaaaaaa                        " disable quickfix
    setl fo-=q
    setl cole=0

    inoremap <buffer> $$ $<Space>$<Left>
    inoremap <buffer> " ``''<Left><Left>
    nmap <buffer> <Leader>" xi``<Esc>,f"axi''<Esc>
    inoremap <buffer> ... \cdots<Space>

    inoremap <buffer> \[ \[<Space>\]<Left><Left>
    inoremap <buffer> \{ \{<Space>\}<Left><Left>
    inoremap <buffer> \langle \langle<Space><Space>\rangle<Esc>7hi
    inoremap <buffer> \verb \verb<Bar><Bar><Left>
    inoremap <buffer> \beg \begin{}<Left>
    inoremap <buffer> \bb <Esc>:call Tex_Block("")<Left><Left>
    inoremap <buffer> \bbt <Esc>:call Tex_Block("t")<CR><Up><End>[H]<Down>\centering<CR>\caption{\label{tab:}}<Esc>k:call Tex_Block("tabular")<CR>
    inoremap <buffer> \bbf <Esc>:call Tex_Block("f")<CR><Up><End>[H]<Down>\centering<CR>\includegraphics[width=\textwidth]{res/}<CR>\caption{\label{fig:}}<Esc>
    inoremap <buffer> \bbm <Esc>:call Tex_Block("mp")<CR><Up><End>[b]{0.46\linewidth}<Down>\centering<CR>\includegraphics[width=\textwidth]{res/}<CR>\caption{\label{fig:}}<Esc>
    inoremap <buffer> \bf \textbf{}<Left>
    xmap <buffer> \bbe di\bbe<CR><Tab><Esc>pj
    xmap <buffer> \bbd di\bbd<CR><Tab><Esc>pj
    xmap <buffer> \bf s}i\textbf<Esc>
    xmap <buffer> \em s}i\emph<Esc>
    xmap <buffer> <Leader>tab :s/\s\+/ \&/g<CR>gv:s/$/\\\\/g<CR>gv<Space>tt

    " Plugin: LaTeX-Box
    let g:LatexBox_no_mappings = 1
    inoremap <buffer> [[ \begin{}<Left>
    imap <buffer> ]] <Plug>LatexCloseCurEnv
    inoremap <buffer> <C-n> <Esc><Right>:call LatexBox_JumpToNextBraces(0)<CR>i
    nmap <buffer> P l:call LatexBox_JumpToNextBraces(0)<CR>
    nmap <buffer> Q :call LatexBox_JumpToNextBraces(1)<CR>

    xmap <buffer> ie <Plug>LatexBox_SelectCurrentEnvInner
    xmap <buffer> ae <Plug>LatexBox_SelectCurrentEnvOuter
    omap <buffer> ie :normal vie<CR>
    omap <buffer> ae :normal vae<CR>
    xmap <buffer> im <Plug>LatexBox_SelectInlineMathInner
    xmap <buffer> am <Plug>LatexBox_SelectInlineMathOuter
    omap <buffer> im :normal vim<CR>
    omap <buffer> am :normal vam<CR>

    nmap <buffer> <Leader>ce <Plug>LatexChangeEnv
    xmap <buffer> <Leader>tc <Plug>LatexWrapSelection
    xmap <buffer> <Leader>te <Plug>LatexEnvWrapSelection
endfunc


func! Make()						" silent make with quickfix window popup
	make
	" silent make ?
	redraw!
	for i in getqflist()
		if i['valid']
			cwin | winc p | return
		endif
	endfor
endfunc

" map --------- {{{1
" cmap          {{{2
cmap w!! w !sudo tee % >/dev/null
cnoreab cdh cd %:p:h
cnoreab lcdh lcd %:p:h
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" nmap -------- {{{2
" nmap - -------- {{{3
nn -+ :set modified!<cr>
" nmap <leader> {{{3
nn <leader>nt :VimFilerCurrentDir -explorer -winwidth=20<cr>
" nmap <leader>c (ctags) {{{4
nn <leader>ta :!gtags && ctags -R<cr>
" nmap <leader>d (diff) {{{4
nn <leader>dt :diffthis<CR>
nn <leader>do :bufdo diffoff<CR>
" nmap <leader>e (edit) {{{4
nn <leader>ee :e <C-R>=expand("%:p:h") . "/" <CR>
nn <leader>es :sp <C-R>=expand("%:p:h") . "/" <CR>
nn <leader>ev :vsp <C-R>=expand("%:p:h") . "/" <CR>
nn <leader>et :tabe <C-R>=expand("%:p:h") . "/" <CR>
" nmap <leader>g (Fugitive) {{{4
nn <leader>gg :GitGutterToggle<cr>
nn <leader>gs :Gstatus<CR>
nn <leader>gd :Gdiff<CR>
nn <leader>gc :Gcommit<CR>
nn <leader>gb :Gblame<CR>
nn <leader>gp :Git push<CR>
" nmap <leader>h (highlight) {{{4
nn <leader>hh :execute 'match InterestingWord1 /\<c-r><c-w>\>/'<cr>
nn <leader>h1 :execute 'match InterestingWord1 /\<c-r><c-w>\>/'<cr>
nn <leader>h2 :execute '2match InterestingWord2 /\<c-r><c-w>\>/'<cr>
nn <leader>h3 :execute '3match InterestingWord3 /\<c-r><c-w>\>/'<cr>
hi InterestingWord1 guifg=#000000 guibg=#FF4300 ctermfg=16 ctermbg=196
hi InterestingWord2 guifg=#000000 guibg=#53FF00 ctermfg=16 ctermbg=82
hi InterestingWord3 guifg=#000000 guibg=#FF74F8 ctermfg=16 ctermbg=165
" nmap <leader> misc {{{4
nn <leader>1 :set cmdheight=1<cr>
nn <leader>2 :set cmdheight=2<cr>
nn <leader>3 :set cmdheight=3<cr>
nn <leader>4 :set cmdheight=4<cr>
nn <leader>5 :set cmdheight=5<cr>
nn <leader>a :Ag<space>
nn <leader>l :call ErrorsToggle()<cr>
nn <leader>q :call QFixToggle()<cr>
nn <Leader>cp :!xsel -ib < %<cr><cr>
nn <Leader>bk :!cp % ~/tmp/%.bak --backup=numbered<cr>
nn <leader>ig :IndentGuidesToggle<cr>:se list!<cr>
nn <Leader>mk :call Make()<cr>
nn <Leader>dd :Dispatch<cr>
nn <Leader>di :Dispatch!<cr>
nn <leader>jf :JunkFile<cr>
nn <leader>st :SyntasticToggleMode<cr>
nn <leader>tb :TagbarToggle<cr>
nn <leader>u :GundoToggle<cr>
nn <leader>w :set wrap!<CR>
nn <leader>wh :call ToggleUnwantedWhitespaces()<cr>
nn <leader>z zMzzzv
nn <leader>S V:execute @@<cr>
" nmap s (Unite) {{{3
nn <silent> sm :Unite -no-split -buffer-name=file -start-insert file_mru<cr>
nn <silent> sf :Unite -no-split -buffer-name=file -start-insert file<cr>
nn <silent> sr :Unite -no-split -buffer-name=file_rec -start-insert file_rec/async<cr>
nn <silent> ss :Unite -no-split -buffer-name=buffer -start-insert buffer<cr>
nn <silent> sc :Unite -no-split -buffer-name=change change<cr>
nn <silent> so :Unite -no-split -buffer-name=outline outline<cr>
nn <silent> sn :Unite -no-split -quick-match buffer<cr>
nn <silent> sl :Unite -auto-resize -buffer-name=line line<cr>
nn <silent> sy :Unite -auto-resize -buffer-name=yank history/yank<cr>
nn <silent> sg :Unite -no-split -buffer-name=ag grep<cr>
" nmap Y (Gtags) {{{3
nn Yy :Gtags <C-r><C-w><cr>
nn Ys :Gtags -s <C-r><C-w><cr>
nn Yr :Gtags -r <C-r><C-w><cr>
nn Yp :Gtags -P <C-r><C-w><cr>
nn Yg :Gtags -g <C-r><C-w><cr>
nn Y<space> :Gtags
" nmap misc {{{3
nn <silent> <C-l> :nohls<cr><C-l>
nn gz :bdelete<cr>
" Error navigation
nn <m-down> :lnext<cr>zvzz
nn <m-up> :lprevious<cr>zvzz
nn <m-j> :cnext<cr>zvzz
nn <m-k> :cprevious<cr>zvzz
" imap {{{2
" move in insert mode
ino <m-h> <left>
ino <m-l> <Right>
ino <m-j> <C-o>gj
ino <m-k> <C-o>gk
" insert word of the line above
ino <C-Y> <C-C>:let @z = @"<CR>mz
      \:exec 'normal!' (col('.')==1 && col('$')==1 ? 'k' : 'kl')<CR>
      \:exec (col('.')==col('$') - 1 ? 'let @" = @_' : 'normal! yw')<CR>
      \`zp:let @" = @z<CR>a
" xmap {{{2
xn <C-c> "+y
" visual shifting (does not exit Visual mode)
vn < <gv
vn > >gv
" * #
xn * :<C-u>call <SID>VSetSearch('/')<CR>/<C-R>=@/<CR><CR>
xn # :<C-u>call <SID>VSetSearch('?')<CR>?<C-R>=@/<CR><CR>
" search for visual-mode selected text
vmap // y/<C-R>"<CR>
vn <leader>S y:execute @@<cr>

" omap {{{2
" Motion for "next/last object". For example, "din(" would go to the next "()" pair
" and delete its contents.

onoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
xnoremap an :<c-u>call <SID>NextTextObject('a', 'f')<cr>
onoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>
xnoremap in :<c-u>call <SID>NextTextObject('i', 'f')<cr>

onoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
xnoremap al :<c-u>call <SID>NextTextObject('a', 'F')<cr>
onoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>
xnoremap il :<c-u>call <SID>NextTextObject('i', 'F')<cr>

function! s:NextTextObject(motion, dir)
  let c = nr2char(getchar())

  if c ==# "b"
      let c = "("
  elseif c ==# "B"
      let c = "{"
  elseif c ==# "d"
      let c = "["
  endif

  exe "normal! ".a:dir.c."v".a:motion.c
endfunction

" Load local vimrc if exists -------------------------- {{{1
if filereadable(glob("~/.vimrc.local"))
  source ~/.vimrc.local
endif
