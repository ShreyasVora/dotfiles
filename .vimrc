" Remap leader to ,
let mapleader = ","

" turn off compatibility mode
set nocompatible

" Necessary for ctrlspace plugin
set hidden

" determine filetype and indent accordingly
filetype indent plugin on

" set colour scheme settings
syntax on
colorscheme koehler
set background=dark
highlight Search ctermbg=blue

" set cursorline and columns, add mapping to toggle on/off
set cursorline
set cursorcolumn
highlight CursorLine cterm=bold ctermbg=234
highlight CursorColumn cterm=bold ctermbg=234
nnoremap H :set cursorline! cursorcolumn!<CR>

" think this is required to help vim work in tmux
set t_md=

" case insensitive search
set ignorecase
" except when using caps
set smartcase

" allow backspacing over autoindent, line break and start of insert action
set backspace=indent,eol,start

" when creating new line
set autoindent

" use visual instead of audio warning
set visualbell

" allow use of mouse
if has('mouse')
  set mouse=a
endif

" line nos
set number

" j/k moves by 7
set so=7

" Always show current position
set ruler

" command bar height
set cmdheight=1

" HL search results
set hlsearch

" incremental search enabled
set incsearch

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
  nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Add ]n amd [n binds to switch between matches from :vimgrep/pattern/ %,
" :copen
nnoremap <silent> ]n :cnext<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
nnoremap <silent> [n :cprevious<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" show matching bracket
set showmatch

" show what keys are being hit in the bottom right
set showcmd

"how many 10ths of a second to blink with matching brackets
set mat=2

" tab = 4 spaces
set shiftwidth=4
set tabstop=4

if &term =~ '256color'
 set t_ut=
endif

" vim very magic searching
"nnoremap / /\v
"nnoremap ? ?\v
"vnoremap / /\v
"vnoremap ? ?\v
" If I type // or ??, I don't EVER want \v, since I'm repeating the previous
" search.
"noremap // //
"noremap ?? ??
" no-magic searching
"noremap /v/ /\V
"noremap ?V? ?\V

noremap! <C-?> <C-h>
nnoremap <F6> :wn<CR>
noremap <F7> gT
noremap <F8> gt
nnoremap <F9> :!clear && %:p<CR>

if($DOMAIN == "dev-lon")

set showtabline=0
let g:airline#extensions#ctrlspace#enabled = 1
let g:CtrlSpaceStatuslineFunction = "airline#extensions#ctrlspace#statusline()"

" Airline Config
" ==============
"
let g:airline_theme = 'onedark'      " Still experimenting here
let g:airline#extensions#tabline#enabled = 1
" let g:airline_powerline_fonts = 1       Couldn't get this to work :(
let g:airline#extensions#tabline#left_alt_sep = '>'
let g:airline#extensions#tabline#left_sep = '>'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_left_sep='>'
let g:airline_right_sep='<'
let g:airline_focuslost_inactive = 0
let g:airline#parts#ffenc#skip_expected_string='utf-8[unix]'
let g:airline#parts#ffenc#skip_expected_string='[unix]'
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#bufferline#enabled = 1

call plug#begin()
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
Plug 'vim-ctrlspace/vim-ctrlspace'
call plug#end()

endif
