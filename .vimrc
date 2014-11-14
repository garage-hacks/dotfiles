" NeoBundle {{{
set nocompatible

if has('vim_starting')
  set runtimepath+=~/.vim/bundle/neobundle.vim/
endif

call neobundle#rc(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
NeoBundleFetch 'Shougo/neobundle.vim'

au BufRead,BufNewFile,BufReadPre *.coffee setlocal filetype=coffee
au BufRead,BufNewFile,BufReadPre *.clj    setlocal filetype=clojure
au BufRead,BufNewFile,BufReadPre *.cljs   setlocal filetype=clojure

NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundleLazy 'Shougo/neocomplete.vim', {'autoload': {'insert' : 1}}
NeoBundle     'Shougo/unite.vim'
NeoBundle     'Shougo/neomru.vim'
NeoBundle     'Shougo/vimshell'

NeoBundle     'Shougo/vimshell.vim'
NeoBundle     'Shougo/vimfiler.vim'
NeoBundle     'itchyny/lightline.vim'
NeoBundle     't9md/vim-textmanip'
NeoBundleLazy 'ruby-matchit', {'autoload': {'filetypes': ['ruby', 'eruby', 'haml']}}
NeoBundle     'altercation/vim-colors-solarized'
NeoBundle     'kana/vim-fakeclip'
NeoBundle     'scrooloose/syntastic'
NeoBundle     'tpope/vim-surround'
NeoBundle     'wincent/Command-T'
NeoBundle     'terryma/vim-multiple-cursors'
NeoBundle     'aharisu/vim_goshrepl'
NeoBundle     'aharisu/vim-gdev'
NeoBundle     'bling/vim-airline'
" }}}

filetype on

filetype plugin on
filetype plugin indent on
syntax on

"---------------------------------------------------------------------------
" Fuzzy finder {{{
set rtp+=~/.fzf
" }}}

"---------------------------------------------------------------------------
" Search {{{
set ignorecase
set smartcase
set incsearch
set hlsearch
set wrapscan

set grepprg=grep\ -nH
" }}}

"---------------------------------------------------------------------------
" Edit Setting {{{
set expandtab
set smarttab
set tabstop=2
set shiftwidth=2
set softtabstop=0

set autoindent
set smartindent
set copyindent

set backspace=2
set showmatch
set wildmenu
set hidden

set formatoptions-=or
set formatoptions+=mM

if has('mouse')
      set mouse=a
endif

set clipboard+=unnamed
set matchpairs=(:),{:},[:]

:let java_highlight_functions=1
" }}}

"" Strip trailing whitespace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
endfunction
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()

" Anywhere SID.
function! s:SID_PREFIX()
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction

" Set tabline.
function! s:my_tabline()  "{{{
  let s = ''
  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears
    let no = i  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '
    let title = fnamemodify(bufname(bufnr), ':t')
    let title = '[' . title . ']'
    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor
  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'
set showtabline=2 " 常にタブラインを表示

" The prefix key.
nnoremap    [Tag]   <Nop>
nmap    t [Tag]
" Tab jump
for n in range(1, 9)
  execute 'nnoremap <silent> [Tag]'.n  ':<C-u>tabnext'.n.'<CR>'
endfor
" t1 で1番左のタブ、t2 で1番左から2番目のタブにジャンプ

map <silent> [Tag]c :tablast <bar> tabnew<CR>
" tc 新しいタブを一番右に作る
map <silent> [Tag]x :tabclose<CR>
" tx タブを閉じる
map <silent> [Tag]n :tabnext<CR>
" tn 次のタブ
map <silent> [Tag]p :tabprevious<CR>
" tp 前のタブ
"---------------------------------------------------------------------------
" Visual {{{
set number
set ruler
" show TAB/CRLF
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
"set listchars=tab:>-,extends:<,trail:-,eol:<

set wrap
" always display command line
set laststatus=2

set cmdheight=1
set showcmd
set title

" show encoding and cr/lf type on status line
" see: http://vimwiki.net/?plugin=related&page=%27statusline%27
set statusline=%<%F\ %m%R%H%W%{'['.(&fenc!=''?&fenc:&enc).']['.&ff.']'}%=%l/%L,%c%V%8P

" no beep
set visualbell
set vb t_vb=

" }}}

"---------------------------------------------------------------------------
" Windows {{{
set splitbelow
set splitright
" }}}

"---------------------------------------------------------------------------
" Fold {{{
set foldenable
" set foldmethod=expr
set foldmethod=marker
" Show folding level
set foldcolumn=2
" }}}

"---------------------------------------------------------------------------
" File Manipulation {{{
set nobackup
set nowritebackup
set noswapfile
set tags+=./tags;
"set autochdir

set wildignore+=*.o,*.obj,.git,*.pyc,*.jar,*.a,*.lib,*~
" }}}

"---------------------------------------------------------------------------
" Key Mapping {{{
let mapleader=","
"let maplocalleader ="\\"

nmap <C-\> <C-]>

" use <Space> for plugin launcher prefix
nnoremap <Space> <Nop>
nnoremap <Space>s :shell<CR>

nnoremap gh ^
nnoremap gl $
nnoremap gp o<ESC>p
nnoremap Y y$

nnoremap [c [czz
nnoremap ]c ]czz

nnoremap <C-n> :<C-u>cn<CR>
nnoremap <C-p> :<C-u>cp<CR>

nnoremap <C-H> <C-W>h
nnoremap <C-J> <C-W>j
nnoremap <C-K> <C-W>k
nnoremap <C-L> <C-W>l
nnoremap <C-W><C-W> <C-w>c

nnoremap < <C-W>4<
nnoremap > <C-W>4>
nnoremap <Space>a :Ack<Space>

" same action as 'o' but keep normal mode
nnoremap <C-o> :<C-u>call append(expand('.'), '')<Cr>j

" double ESC to cancel search highlighting
nnoremap <ESC><ESC> :nohlsearch<CR><ESC>
vnoremap <ESC> <ESC>

" insert TAB char regardless expandtab setting
inoremap <C-t>  <C-v><TAB>

" emacs like key binds for insert mode
inoremap <C-d>  <Del>
inoremap <C-h> <BS>
inoremap <C-l> <C-o>zz
inoremap <C-k> <C-o>D
inoremap <C-y> <C-o>P
inoremap <C-a> <Home>
inoremap <C-e> <End>
inoremap <C-p> <Up>
inoremap <C-n> <Down>
inoremap <C-b> <Left>
inoremap <C-f> <Right>
inoremap jj <ESC>

" see: http://vim-users.jp/2011/04/hack214/
onoremap ) t)
onoremap ( t(
vnoremap ) t)
vnoremap ( t(

" shortcuts to change settings
nnoremap @tr  :<C-u>set ruler!<cr>
nnoremap @tn  :<C-u>set number!<cr>
nnoremap @tet :<C-u>set expandtab!<cr>
nnoremap @i2  :<C-u>set tabstop=2 shiftwidth=2<cr>
nnoremap @i4  :<C-u>set tabstop=4 shiftwidth=4<cr>
nnoremap @i8  :<C-u>set tabstop=8 shiftwidth=8<cr>

nnoremap <Space>e mmT(i<Space><ESC>h%i<Space><ESC>`ml
nnoremap E viw

call togglebg#map("@tbg")
" }}}

" Unite.vim {{{
nnoremap <silent>;b :<C-u>Unite buffer<CR>
nnoremap <silent>;f :<C-u>UniteWithBufferDir -buffer-name=file file file_mru file/new<CR>
nnoremap <silent>;m :<C-u>Unite file_mru<CR>
nnoremap <silent>;g :<C-u>Unite grep<CR>
nnoremap <silent>;o :<C-u>Unite outline<CR>
nnoremap <silent>;r :<C-u>Unite register<CR>
nnoremap <silent>;l :<C-u>Unite line<CR>
nnoremap <silent>;t :<C-u>UniteWithCursorWord -buffer-name=tag tag<CR>
nnoremap <silent>;; :<C-u>Unite file_rec/async<CR>
nnoremap <silent>;y :<C-u>Unite history/yank<CR>
nnoremap <silent>;s :<C-u>Unite snippet<CR>

" Overwrite settings.
au FileType unite call s:unite_my_settings()
function! s:unite_my_settings()
  nmap <silent><buffer> <ESC><ESC> q
  imap <silent><buffer> <ESC><ESC> <ESC>q
  imap <buffer> <TAB>   <Plug>(unite_select_next_line)
  imap <buffer> <C-w>   <Plug>(unite_delete_backward_path)

  " shortcuts
  call unite#custom#substitute('file', '\$\w\+', '\=eval(submatch(0))', 200)
  call unite#custom#substitute('file', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/"', 2)
  call unite#custom#substitute('file', '^@', '\=getcwd()."/*"', 1)
  call unite#custom#substitute('file', '^;r', '\=$VIMRUNTIME."/"')
  call unite#custom#substitute('file', '^\~', escape($HOME, '\'), -2)
  call unite#custom#substitute('file', '\\\@<! ', '\\ ', -20)
  call unite#custom#substitute('file', '\\ \@!', '/', -30)
endfunction

let g:unite_source_file_mru_limit = 300
let g:unite_source_directory_mru_limit = 300
let g:unite_source_history_yank_limit = 1000

" start on insert mode
let g:unite_enable_start_insert=1
"let g:unite_source_file_rec_ignore_pattern = '\%(^\|/\)\.$\|\~$\|\.\%(o\|so\|class\|a\|exe\|dll\|bak\|sw[po]\)$\|\%(^\|/\)\.\%(hg\|git\|bzr\|svn\|neocon\|android\|rvm\|gem\)\%($\|/\)'
let g:unite_source_file_rec_min_cache_files=1000
let g:unite_source_history_yank_enable=1
let g:unite_source_history_yank_limit=1000
" }}}

" Command-T {{{
nnoremap <silent>t  :<C-u>CommandT<Return>
nnoremap <silent>T  :<C-u>CommandTTag<Return>
let g:CommandTCancelMap=['<ESC>','<C-c>']
let g:CommandTMaxFiles=10000
let g:CommandTMatchWindowReverse=1
" }}}

" surround.vim {{{
let g:surround_custom_mapping = {}
let g:surround_custom_mapping._ = {
      \ 'p':  "<pre> \r </pre>",
      \ 'w':  "%w(\r)",
      \ }
let g:surround_custom_mapping.help = {
      \ 'p':  "> \r <",
      \ }
let g:surround_custom_mapping.ruby = {
      \ '-':  "<% \r %>",
      \ '=':  "<%= \r %>",
      \ '9':  "(\r)",
      \ '5':  "%(\r)",
      \ '%':  "%(\r)",
      \ 'w':  "%w(\r)",
      \ '#':  "#{\r}",
      \ '3':  "#{\r}",
      \ 'e':  "begin \r end",
      \ 'E':  "<<EOS \r EOS",
      \ 'i':  "if \1if\1 \r end",
      \ 'u':  "unless \1unless\1 \r end",
      \ 'c':  "class \1class\1 \r end",
      \ 'm':  "module \1module\1 \r end",
      \ 'd':  "def \1def\1\2args\r..*\r(&)\2 \r end",
      \ 'p':  "\1method\1 do \2args\r..*\r|&| \2\r end",
      \ 'P':  "\1method\1 {\2args\r..*\r|&|\2 \r }",
      \ }
let g:surround_custom_mapping.javascript = {
      \ 'f':  "function(){ \r }"
      \ }
let g:surround_custom_mapping.lua = {
      \ 'f':  "function(){ \r }"
      \ }
let g:surround_custom_mapping.python = {
      \ 'p':  "print( \r)",
      \ '[':  "[\r]",
      \ }
let g:surround_custom_mapping.vim= {
      \'f':  "function! \r endfunction"
      \ }
