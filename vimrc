" vim: foldmethod=marker

" vim-plug {{{

call plug#begin()

" utils
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'easymotion/vim-easymotion'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
" editing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'junegunn/vim-easy-align'
Plug 'sbdchd/neoformat'
Plug 'chrisbra/Recover.vim'
" syntax
Plug 'scrooloose/syntastic'
" filetype plugins
Plug 'lervag/vimtex', {'for': 'tex'}
" color
Plug 'chriskempson/base16-vim'
" fzf
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'

call plug#end()

" }}}

" color {{{
colorscheme base16-default-light
" }}}

" editing {{{

set hidden " hide abandoned buffers instead of unloading

" }}}

" spacing and wrapping {{{

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set wrap
set textwidth=79
set colorcolumn=+1 " colored column one behind last column

" }}}

" search and substitute {{{

" make :substitute 'g'lobal by default
set gdefault

" ignore case in search patterns except when upperase is present
set ignorecase
set smartcase

" }}}

" wildmenu completion {{{
set wildmenu " show command-line completion
" }}}

" status line {{{

set laststatus=2 " show status line for any number of windows

function! GitBranch()
  return system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
endfunction

function! StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0?'  '.l:branchname.' ':''
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %F
set statusline+=\ %m%r%h%w
set statusline+=%=
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%#CursorColumn#
set statusline+=\ \[%{&filetype}\|%{&fileencoding?&fileencoding:&encoding}\|%{&fileformat}\]
set statusline+=\ %3p%%
set statusline+=\ %3l\/%L:%2c
set statusline+=\ 


" }}}

" backups {{{

if !isdirectory($HOME."/.vim")
    call mkdir($HOME."/.vim", "", 0770)
endif
if !isdirectory($HOME."/.vim/backup")
    call mkdir($HOME."/.vim/backup", "", 0700)
endif
if !isdirectory($HOME."/.vim/swap")
    call mkdir($HOME."/.vim/swap", "", 0700)
endif
if !isdirectory($HOME."/.vim/undo")
    call mkdir($HOME."/.vim/undo", "", 0700)
endif

set backupdir=~/.vim/backup/ " backups
set directory=~/.vim/swap/   " swap files
set undodir=~/.vim/undo/     " undo files
set backup                       " keep backup file
set undofile                     " persist undo
" set backup filename before writing
au BufWritePre * let &bex = '-' . strftime("%F.%H:%M:%S") . '~'

" }}}

" key mappings {{{

let mapleader=','

" jj or jk to escape
inoremap jj <esc>
inoremap jk <esc>

" <tab> jumps to match
map <tab> %

" ` for last buffer
noremap ` <C-^>

" buffer navigation
noremap <C-h>  <C-w>h
noremap <C-j>  <C-w>j
noremap <C-k>  <C-w>k
noremap <C-l>  <C-w>l

" space to toggle folds
nnoremap <space> za
vnoremap <space> za

" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

" Fn key mapping
nnoremap <F5> :UndotreeToggle<cr>
nnoremap <F7> :TagbarToggle<cr>

" leader key mapping
" open files / buffers
nnoremap <leader>n :vne<cr>
nnoremap <leader>o :Files<cr>
" cd to current files dir
nnoremap <leader>cd :cd %:p:h<cr>
" ag and ag word under cursor
nnoremap <leader>a :Ag 
nnoremap <Leader>ag :Ag <C-R><C-W><cr>
" terminal
nnoremap <leader>t :vert term<cr>
" switch colorscheme
nnoremap <leader>l :colorscheme base16-default-light<cr>
nnoremap <leader>d :colorscheme base16-tomorrow-night<cr>
" edit config files
nnoremap <leader>ev <C-w>v:e $MYVIMRC<cr>
nnoremap <leader>evb <C-w>v:e $MYVIMRC.bak<cr>
nnoremap <leader>rv :source $MYVIMRC<cr>
nnoremap <leader>ez <C-w>v:e ~/.zshrc<cr>

" }}}

" filetype settings {{{

" LaTeX {{{

" fix vim detecting tex as filetype='plaintext'
let g:tex_flavor = 'latex'

" }}}

" OCaml {{{

let &rtp = &rtp . ',' . substitute(system("opam config var share"), '\n\+$', '', '') . "/merlin/vim"
let g:syntastic_ocaml_checkers = ['merlin']
autocmd FileType ocaml setlocal commentstring=(*%s*) foldmethod=marker

" }}}

" plugin settings {{{

" vimtex {{{

let g:vimtex_view_method = 'skim'
let g:vimtex_format_enabled = 1
let g:vimtex_quickfix_latexlog = { 'overfull' : 0, 'underfull' : 0 }
" }}}

" }}}

" UI settings {{{

set splitright " split windows to right
set cursorline " highlight cursor line

" }}}

" GUI settings {{{
if has('gui_macvim')
  set guifont=Menlo:h11
endif

" set gui cursor blinking options
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkon0-ver25-Cursor/lCursor
" }}}
