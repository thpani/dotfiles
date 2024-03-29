" vim: foldmethod=marker

" vim-plug {{{

call plug#begin()

" utils
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
Plug 'easymotion/vim-easymotion'
" Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
" editing
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'junegunn/vim-easy-align'
Plug 'junegunn/rainbow_parentheses.vim'
Plug 'sbdchd/neoformat'
Plug 'chrisbra/Recover.vim'
Plug 'christoomey/vim-titlecase', { 'for': 'tex' }
" windows
Plug 'roman/golden-ratio'
" git
Plug 'airblade/vim-gitgutter'
" distraction-free writing
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
" syntax
Plug 'scrooloose/syntastic'
" filetype plugins
Plug 'hashivim/vim-terraform', { 'for': 'tf' }
Plug 'lervag/vimtex', { 'for': 'tex' }
Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' }
Plug 'bohlender/vim-smt2', { 'for': 'smt2' }
Plug 'hwayne/tla.vim', { 'for': 'tla' }
" color
Plug 'connorholyday/vim-snazzy'
" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
" LSP
Plug 'prabirshrestha/vim-lsp'

call plug#end()

" }}}

" color {{{
colorscheme snazzy
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
set textwidth=80
set colorcolumn=+1 " Colored column one behind last column
set nojoinspaces   " Don't insert 2 spaces after .!? after a join command
set autoindent     " Copy indent when starting a new line. Required for indenting lists.

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

function GitBranch()
  silent let l:branch = system("git rev-parse --abbrev-ref HEAD 2>/dev/null | tr -d '\n'")
  return l:branch
endfunction

function StatuslineGit()
  let l:branchname = GitBranch()
  return strlen(l:branchname) > 0 ? '  '.l:branchname.' ' : ''
endfunction

set statusline=
set statusline+=%#PmenuSel#
set statusline+=%{StatuslineGit()}
set statusline+=%#LineNr#
set statusline+=\ %F
set statusline+=\ %{&paste?'[paste]':''}
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
set pastetoggle=<leader>p
" cd to current files dir
nnoremap <leader>cd :cd %:p:h<cr>
" ag and ag word under cursor
nnoremap <leader>a :Rg
nnoremap <Leader>ag :Rg <C-R><C-W><cr>
" terminal
nnoremap <leader>t :vert term<cr>
" goyo + asdf
nnoremap <leader>w :Goyo<cr>
" switch colorscheme
nnoremap <leader>l :colorscheme base16-default-light<cr>
nnoremap <leader>d :colorscheme base16-tomorrow-night<cr>
" edit config files
nnoremap <leader>ev <C-w>v:e $MYVIMRC<cr>
nnoremap <leader>evb <C-w>v:e $MYVIMRC.bak<cr>
nnoremap <leader>rv :source $MYVIMRC<cr>
nnoremap <leader>ez <C-w>v:e ~/.zshrc<cr>
" format
nnoremap <leader>f :Neoformat<cr>

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

" Python {{{

let g:syntastic_python_checkers = ['flake8']
let g:neoformat_python_black = {
      \ 'exe': 'black',
      \ 'stdin': 1,
      \ 'args': ['-S', '-q', '-'],
      \ }
let g:neoformat_enabled_python = ['black']

" }}}

" Quint {{{

if executable('quint-language-server')
  au User lsp_setup call lsp#register_server({
    \ 'name': 'quint',
    \ 'cmd': {server_info->['quint-language-server', '--stdio']},
    \ 'allowlist': ['quint'],
    \ })
endif

augroup quint
  au! BufNewFile,BufRead *.qnt set filetype=quint
  if filereadable(expand("~/src/quint/editor-plugins/vim/quint.vim"))
    au BufNewFile,BufRead *.qnt source ~/src/quint/editor-plugins/vim/quint.vim
  endif
augroup END

" }}}

" }}}

" plugin settings {{{

" LSP {{{

function! s:on_lsp_buffer_enabled() abort
  setlocal omnifunc=lsp#complete
  setlocal signcolumn=yes
  if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
  nmap <buffer> gd <plug>(lsp-definition)
  nmap <buffer> gs <plug>(lsp-document-symbol-search)
  nmap <buffer> gS <plug>(lsp-workspace-symbol-search)
  nmap <buffer> gr <plug>(lsp-references)
  nmap <buffer> gi <plug>(lsp-implementation)
  nmap <buffer> gt <plug>(lsp-type-definition)
  nmap <buffer> <leader>rn <plug>(lsp-rename)
  nmap <buffer> [g <plug>(lsp-previous-diagnostic)
  nmap <buffer> ]g <plug>(lsp-next-diagnostic)
  nmap <buffer> K <plug>(lsp-hover)
  nnoremap <buffer> <expr><c-f> lsp#scroll(+4)
  nnoremap <buffer> <expr><c-d> lsp#scroll(-4)
endfunction

augroup lsp_install
  au!
  autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" }}}

" vimtex {{{

let g:vimtex_view_method = 'skim'
" let g:vimtex_view_automatic = 1
let g:vimtex_format_enabled = 1
let g:vimtex_quickfix_ignore_filters = [
    \ 'Overfull',
    \ 'Underfull',
    \]

" }}}

" goyo {{{

function! WordCount()
   let s:old_status = v:statusmsg
   let position = getpos(".")
   exe ":silent normal g\<c-g>"
   let stat = v:statusmsg
   let s:word_count = 0
   if stat != '--No lines in buffer--'
     let s:word_count = str2nr(split(v:statusmsg)[11])
     let v:statusmsg = s:old_status
   end
   call setpos('.', position)
   return s:word_count 
endfunction

function! s:goyo_enter()
  let s:old_font=&guifont
  let s:old_statusline=&statusline
  set guifont=SFMono-Regular:h16
  set statusline=%#LineNr#%=%{WordCount()}
  Limelight0.7
  set nocursorline
endfunction

function! s:goyo_leave()
  Limelight!
  let &guifont=s:old_font
  let &statusline=s:old_statusline
  set cursorline
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

" }}}

" }}}

" UI settings {{{

set splitright " split windows to right
set cursorline " highlight cursor line

" }}}

" GUI settings {{{
if has('gui_macvim')
  set guifont=FiraCodeNerdFontCompleteM-Regular:h12
endif

" set gui cursor blinking options
set guicursor+=n-v-c:blinkon0
set guicursor+=i:blinkon0-ver25-Cursor/lCursor
" }}}
