" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather then Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" Allow backspacing over everything in insert mode
set backspace=indent,eol,start

set history=50      " Keep 50 lines of command line history
set ruler           " Show the cursor position all the time
set showcmd         " Display incomplete commands
set incsearch       " Do incremental searching
set autowrite       " Automatically save before commands like :next and :make

" Default editing options
set encoding=utf-8
set et sw=4 ts=4    " Use 4 spaces for indentation

let c_comment_strings=1
set laststatus=2
hi StatusLine cterm=bold

" Don't use Ex mode, use Q for formatting
map Q gq

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  set background=dark
  syntax on
  set hlsearch
endif
if has("gui_running")
  colorscheme torte
  set guifont=Monaco:h14
  set columns=100
  set lines=40
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")
  " Enable file type detection.
  filetype on
  filetype plugin on
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  autocmd BufRead,BufNewFile /etc/apache2/* set filetype=apache
  autocmd BufRead,BufNewFile *.xsl set ts=2 sw=2
  autocmd BufRead,BufNewFile *.py  set et ts=4 sw=4 sts=4 ai nosi
  autocmd BufRead,BufNewFile .git/COMMIT_EDITMSG set tw=0

  augroup END
else
  set autoindent    " Always set autoindenting on
endif " has("autocmd")

