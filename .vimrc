" =====================
" General vim settings
" =====================

let mapleader = ","              " Remap leader to ,
set nocompatible                 " turn off compatibility mode
set hidden                       " Necessary for ctrlspace plugin
filetype indent plugin on        " determine filetype and indent accordingly
syntax on                        " set colour scheme settings
set t_md=                        " I think this is required to help vim work in tmux
set ignorecase                   " case insensitive search
set smartcase                    " ...except when using caps
set backspace=indent,eol,start   " allow backspacing over autoindent, line break and start of insert action
set autoindent                   " when creating new line
set visualbell                   " use visual instead of audio warning

" --------------------
" Colorscheme settings
" --------------------
colorscheme koehler
set background=dark
highlight Search ctermbg=blue
set cursorline
set cursorcolumn
highlight CursorLine cterm=bold ctermbg=236
highlight CursorColumn cterm=bold ctermbg=236

" allow use of mouse
if has('mouse')
	set mouse=a
endif

" Lineno bar settings
set relativenumber    " Show relative line number from current line
set number            " ...except for the current line
hi LineNrAbove ctermfg=240
hi LineNrBelow ctermfg=240
set so=7              " j/k moves by 7
set cmdheight=1       " command bar height
set hlsearch          " Enable higlighting of search results
set incsearch         " incremental search enabled
set showmatch         " show matching bracket
set showcmd           " show what keys are being hit in the bottom right
set mat=2             "how many 10ths of a second to blink with matching brackets
set shiftwidth=4      " tab = 4 spaces
set tabstop=4         " tab = 4 spaces

" Required for tmux
if &term =~ '256color'
	set t_ut=
endif



" ==============
" Key mappings
" ==============

" Toggle cursorline / column highlighting
nnoremap H :set cursorline! cursorcolumn!<CR>

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
	nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Add ]n amd [n binds to switch between matches from :vimgrep/pattern/ %,
" :copen         -  I don't use this, but found it and it seems quite cool so
" not deleting it
nnoremap <silent> ]n :cnext<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
nnoremap <silent> [n :cprevious<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>

" Map backspace to erase
noremap! <C-?> <C-h>
" Save and go to next file in buffer
nnoremap <F6> :wn<CR>
" Go to previous tab
noremap <F7> gT
" Go to next tab
noremap <F8> gt
" Clear shell output and execute current script with no args
nnoremap <F9> :!clear && %:p<CR>



" ============================
" Plugins and plugin settings
" ============================
" This is restricted to only being used in dev-lon

if($DOMAIN == "dev-lon")

	" Ctrlspace config
	" ----------------
	set showtabline=0
	let g:airline#extensions#ctrlspace#enabled = 1
	let g:CtrlSpaceStatuslineFunction = "airline#extensions#ctrlspace#statusline()"

	" Airline Config
	" --------------
	let g:airline_theme = 'dark'      " Still experimenting here
	let g:airline#extensions#tabline#enabled = 1
	" let g:airline_powerline_fonts = 1       Couldn't get this to work :(
	let g:airline#extensions#tabline#left_alt_sep = '>'
	let g:airline#extensions#tabline#left_sep = '>'
	let g:airline#extensions#tabline#formatter = 'unique_tail'
	let g:airline_left_sep='>'
	let g:airline_right_sep='<'
	let g:airline_focuslost_inactive = 0
	let g:airline#extensions#branch#enabled = 1
	let g:airline#extensions#bufferline#enabled = 1
	let g:airline_section_y = '%{getcwd()}'

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
