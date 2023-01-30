" turn off compatibility mode
set nocompatible

" determine filetype and indent accordingly
filetype indent plugin on

" set colour scheme settings
syntax on
colorscheme koehler
set background=dark
highlight Search ctermbg=blue

set cursorline
set cursorcolumn
highlight CursorLine ctermbg=17
highlight CursorColumn ctermbg=17

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

" show matching bracket
set showmatch

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
noremap <F7> gT
noremap <F8> gt

