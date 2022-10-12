" turn off compatibility mode
set nocompatible

" determine filetype and indent accordingly
filetype indent plugin on

syntax on

" case insensitive search
set ignorecase
" excet when using caps
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

" show matching bracket
set showmatch

"how many 10ths of a second to blink with matching brackets
set mat=2


" tab = 4 spaces
set shiftwidth=4
set tabstop=4

set background=dark

if &term =~ '256color'
	 set t_ut=
endif

noremap! <C-?> <C-h>
