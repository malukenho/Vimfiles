" General
set clipboard=unnamed
set incsearch nohlsearch
set isfname-==
set nottybuiltin
set shortmess=aTOI
set showcmd
set sidescroll=4
set splitbelow
set switchbuf=useopen
set t_Co=256
set ttyfast
set updatetime=1000
set viminfo+=!

" Editing
set complete=.,w,b,k
set completeopt=menuone,longest
set formatoptions=croqn
set nojoinspaces

" View formatting
set number
set ruler
set diffopt=filler,vertical,iwhite
set fillchars=stl:-,stlnc:-,vert:│,fold:\ ,diff:-
set guioptions=crb
set linebreak showbreak=+
set listchars=eol:.,tab:\|-
set laststatus=2

set statusline=
set statusline+=%<%f\ %h%m%r             " filename and flags
set statusline+=%{fugitive#statusline()} " git info
set statusline+=%=                       " alignment separator
set statusline+=[%{&ft}]                 " filetype
set statusline+=%-14.([%l/%L],%c%V%)     " cursor info

" Files
set autoread autowrite
set encoding=utf-8
set ffs=unix
set nobackup nowritebackup noswapfile
if has('persistent_undo')
  set undodir=~/.vimundo
  set undofile
end

" Indentation
set backspace=indent,eol,start
set autoindent
set expandtab smarttab
set tabstop=8 softtabstop=2
set shiftwidth=2 shiftround

" Command-line
set cmdheight=1
set wildmenu
set wildmode=list:longest,full

" Timeouts
set notimeout
set ttimeout
set ttimeoutlen=200

" Cscope
set cscopetagorder=1 " Look in tags file first
set cscopequickfix=s-,c-,d-,i-,t-,e-
set nocscopetag

let mapleader="_"
let maplocalleader=","

let apache_version = "2.2"
