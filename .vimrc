set background=dark

if has("syntax")
  syntax on
endif

if has("autocmd")
  filetype plugin indent on
endif

" Use space instead of tabs for indentation
set tabstop=4
set shiftwidth=4
set expandtab

set showcmd     " Show (partial) command in status line.
set showmatch   " Show matching brackets.
set ignorecase  " Do case insensitive matching
set autowrite   " Automatically save before commands like :next and :make
set hidden      " Hide buffers when they are abandoned
