" Neat .vimrc
" Based on example .vimrc file by Bram Moolenaar <Bram@vim.org>
"
" Maintainer:   Daniel Sabelnikov <dsabelnikov@gmail.com>
" Created:      5 May 2014
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"         for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"       for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
    finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
    set nobackup      " do not keep a backup file, use versions instead
else
    set backup        " keep a backup file
endif
set backupdir=~/.vimbackup,~/.tmp/,~/
set history=50      " keep 50 lines of command line history
set ruler       " show the cursor position all the time
set showcmd     " display incomplete commands
set incsearch       " do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
    set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
    syntax on
    set hlsearch
endif


" ******************************** "
" =====    Setup Plugins     ===== "
" ******************************** "
"
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

" NERDTree
Plugin 'scrooloose/nerdtree'

" Javascript syntax
Plugin 'jelera/vim-javascript-syntax'

" My fork of vim-javascript
Plugin 'dragn/vim-javascript'

" Awesome plugin to track most-recently used files
Plugin 'yegappan/mru'

" Highlight and fix trailing whitespaces
Plugin 'bronson/vim-trailing-whitespace'

" Support for istanbul code coverage files
Plugin 'juanpabloaj/vim-istanbul'

" Preview markdown files in browser (requires Livedown: http://github.com/shime/vim-livedown)
Plugin 'shime/vim-livedown'

Plugin 'vim-stylus'
Plugin 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line
call vundle#end()            " required
"
" ===== End of Plugins setup ===== "

" Enable file type detection.
" Use the default filetype settings, so that mail gets 'tw' set to 72,
" 'cindent' is on in C files, etc.
" Also load indent files, to automatically do language-dependent indenting.
filetype plugin indent on

" Put these in an autocmd group, so that we can delete them easily.
augroup vimrcEx
au!

" For all text files set 'textwidth' to 78 characters.
autocmd FileType text setlocal textwidth=78

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
" Also don't do it when the mark is in the first line, that is the default
" position when opening a file.
autocmd BufReadPost *
            \ if line("'\"") > 1 && line("'\"") <= line("$") |
            \   exe "normal! g`\"" |
            \ endif

augroup END

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
    command DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
                \ | wincmd p | diffthis
endif

" Set directory for swaps and backups
set dir=~/.vim/tmp,.
set bdir=~/.vim/tmp,.
set undodir=~/.vim/tmp,.

" ******************************** "
" ===== Neat .vimrc features ===== "
" ******************************** "

" The default is 2 spaces per tab
set tabstop=2
set shiftwidth=2

" cindent options:
" - disable indent inside C++ namespaces
set cino=N-s

" 4 spaces for Java and JavaScript files
autocmd FileType java setlocal shiftwidth=4 tabstop=4
autocmd FileType javascript setlocal shiftwidth=4 tabstop=4

" Expand tabs to spaces
set expandtab

" Enable line numbers
set number

set undofile

" ===== Netrw Setup =====
let g:netrw_browse_split = 4
let g:netrw_preview      = 1
let g:netrw_altv         = 1

" ===== Custom Key Mappings =====

" F2 opens current directory listing
map <F2> :NERDTree<CR>
map <C-F> :NERDTreeFind<CR>

" F3 saves current file
map <F3> :w<CR>

" F4 formats and saves file
map <F4> gg=G'':w<CR>

" F5 opens up most-recently used files listing
map <F5> :MRU<CR>

" F6 show javascript code coverage
let g:coverage_json_path = './coverage.json'
map <F6> :IstanbulShow<CR>

" F12 lookup header files for a word under cursor
map <F12> bvey:vim /<C-R>"/ **/*.hpp<CR>:cw<CR>

" Ctrl-W closes current window
map <C-W> :close<CR>

" Ctrl-Q closes current buffer without saving
map <C-Q> :q!<CR>

" Ctrl-R in visual mode: replace current selection
vmap <C-R> y:%s/<C-R>"/

" Ctrl-F in visual mode: search current selection
vmap <C-F> y/<C-R>"<CR>

" Ctrl-C in visual mode: copy selection to clipboard (MacOS)
vmap <C-C> :w !pbcopy<CR><CR>

" Ctrl-V: paste to current position from clipboard (MacOS)
map <C-V> :.!pbpaste<CR>

" Moving around tabs with Alt + Arrows
map <A-LEFT>  :wincmd h<CR>
map <A-RIGHT> :wincmd l<CR>
map <A-UP>    :wincmd k<CR>
map <A-DOWN>  :wincmd j<CR>

" MacOS/iTerm2 fix (Alt + Arrows)
map <ESC>[1;9D :wincmd h<CR>
map <ESC>[1;9C :wincmd l<CR>
map <ESC>[1;9A :wincmd k<CR>
map <ESC>[1;9B :wincmd j<CR>

" Ctrl-Shift-Left, Ctrl-Shift-Right: resize current vertical tab
map <C-S-LEFT> :vertical resize +10<CR>
map <C-S-RIGHT> :vertical resize -10<CR>

" set type javascript for *.bemhtml/*.bemtree files
au BufNewFile,BufRead *.bemhtml setf javascript
au BufNewFile,BufRead *.bemtree setf javascript

" set type markdown for *.md files
au BufNewFile,BufReadPost *.md set filetype=markdown

" stylus files
au BufNewFile,BufReadPost *.styl set filetype=stylus

" My colorscheme of choice
colorscheme ron
