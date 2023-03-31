" =====================
" General vim settings
" =====================

let mapleader = ","              " Remap leader to ,
set nocompatible                 " turn off compatibility mode
set hidden                       " Necessary for ctrlspace plugin
filetype indent plugin on        " determine filetype and indent accordingly
syntax on                        " set colour scheme settings
set t_md=                        " I think this is required to help vim work in tmux
set ignorecase smartcase         " case insensitive search except when using caps
set backspace=indent,eol,start   " allow backspacing over autoindent, line break and start of insert action
set autoindent                   " when creating new line
set visualbell                   " use visual instead of audio warning
set wildmenu wildoptions=pum     " when using tab completion for filenames, show popup menu instead of horizontal menu
if wildoptions&? =~ 'pum'
	set wildoptions=pum
endif
set noswapfile                   " no swp file
set guioptions+=a                " visual mode text copied to clipboard
set timeoutlen=3000              " Configure timeout time in ms for various command types
set list                         " By default, show whitespace characters

" --------------------
" Colorscheme settings
" --------------------
colorscheme koehler
set background=dark
set cursorline cursorcolumn
highlight Search ctermbg=blue
highlight CursorLine cterm=bold ctermbg=236
highlight CursorColumn cterm=bold ctermbg=236
hi VertSplit ctermbg=19 ctermfg=19

" Vim folds, game changing
set foldcolumn=1
set foldmethod=indent
hi foldcolumn ctermbg=bg ctermfg=39
hi folded ctermbg=bg ctermfg=39

" allow use of mouse
if has('mouse')
	set mouse=a
endif

" Lineno bar settings
set relativenumber number  " Show relative line number from current line
hi LineNrAbove ctermfg=240
hi LineNrBelow ctermfg=240
set so=7                   " j/k moves by 7
set cmdheight=1            " command bar height
set hlsearch               " Enable higlighting of search results
set incsearch              " incremental search enabled
set showmatch              " show matching bracket
set showcmd                " show what keys are being hit in the bottom right
set mat=2                  " how many 10ths of a second to blink with matching brackets
set shiftwidth=4 tabstop=4 " tab = 4 spaces

" Required for tmux
if &term =~ '256color'
	set t_ut=
endif



" ==============
" Key mappings
" ==============

" Fundamental
" -----------
nnoremap ; :
nnoremap <Leader>, <C-w>
" Comment out lines matching previous search
nnoremap <Leader># :%g//s/^/#sv/gc<CR>
nnoremap <C-Up> {
nnoremap <C-Down> }
" Map backspace to erase
noremap! <C-?> <C-h>
" Save and go to next file in buffer
nnoremap <F6> :wn<CR>
" Clear shell output and execute current script with no args
nnoremap <F9> :!clear && %:p<CR>
" Use Leader to move buffers / tabs. Map d to close buffer
nnoremap <Leader><Left> :bprev<CR>
nnoremap <Leader><Right> :bnext<CR>
noremap <Leader><Up> gT
noremap <Leader><Down> gt
nnoremap <Leader>d :bd<CR>

" Vim folds
" zf creates a fold
" zE deletes all folds in file
" zo opens fold, zc closes. za toggles open/closed
" zR opens all folds in file, zM closes them
" If I find folds annoying, I will disable the below mapping
nnoremap <Space> za
nnoremap z<Up> zk
nnoremap z<Down> zj

" Misc
" -----------
" When you have search results up, but want to highlight something else
" without jumping there, hit ctrl-f. Yeah I know, very niche.
nnoremap <C-f> :let @/=""<Left>

" Toggle list mode on or off. This displays whitespace characters nicely
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
nnoremap <Leader>l :set list! list?<CR>

" Toggle cursorline / column highlighting
nnoremap H :set cursorline! cursorcolumn!<CR>

" Use <C-L> to clear the highlighting of :set hlsearch.
if maparg('<C-L>', 'n') ==# ''
	nnoremap <silent> <C-L> :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
endif

" Add ]n amd [n binds to switch between matches from :vimgrep/pattern/ %, :copen
" I don't use this, but found it and it seems quite cool so not deleting it
nnoremap <silent> ]n :cnext<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>
nnoremap <silent> [n :cprevious<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR><C-L>



" ============================
" Plugins and plugin settings
" ============================
" This is restricted to only being used in dev-lon

if($DOMAIN == "dev-lon")

	call plug#begin()
	" sensible default settings for vim
	" Plug 'tpope/vim-sensible'
	Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
	Plug 'Xuyuanp/nerdtree-git-plugin'
	Plug 'tpope/vim-fugitive'
	Plug 'airblade/vim-gitgutter'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'
	Plug 'bling/vim-bufferline'
	Plug 'vim-ctrlspace/vim-ctrlspace'
	Plug 'matze/vim-ini-fold'
	Plug 'tpope/vim-unimpaired'
	call plug#end()

	" NERDTree Config            > View filestructure in tree view
	" ---------------
	"  Best shortcuts in NERDTree
	" t: Open the selected file in a new tab
	" i: Open the selected file in a horizontal split window
	" s: Open the selected file in a vertical split window
	" I: Toggle hidden files
	" m: Show the NERD Tree menu
	" R: Refresh the tree, useful if files change outside of Vim
	" ?: Toggle NERD Tree's quick help
	"
	" Define colors
	hi Directory ctermfg=red
	" Mapping to open NERDTree
	nnoremap <Leader>n :NERDTreeToggle<CR>
	" Enable seeing hidden files (beginning with .)
	let NERDTreeShowHidden=1
	" Start NERDTree if vim is opened without a file specified
	" Close the tab if NERDTree is the only window remaining in it.
	autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

	" Fugitive                   > An implementation of git into vim
	" --------
	autocmd StdinReadPre * let s:std_in=1
	augroup GitOnVimStartup
		autocmd!
		autocmd VimEnter * if argc() == 0 && isdirectory(getcwd()) && system('git rev-parse --is-inside-work-tree >/dev/null 2>&1') == 0 | call timer_start(100, { -> execute('0Git') }) | endif
	augroup END

	" Git gutter                 > Show git status of lines in left bar
	" ----------
	nnoremap <Leader>g :GitGutterLineHighlightsToggle<CR>

	" Airline Config             > Customise status bar and tabline
	" --------------
	let g:airline_theme = 'dark'      " Still experimenting here
	let g:airline#extensions#tabline#enabled = 1
	let g:airline#extensions#tabline#left_alt_sep = '>'
	let g:airline#extensions#tabline#left_sep = '>'
	let g:airline#extensions#tabline#formatter = 'unique_tail'
	let g:airline_left_sep='>'
	let g:airline_right_sep='<'
	let g:airline_focuslost_inactive = 0
	let g:airline#extensions#branch#enabled = 1
	let g:airline_section_y = '%{getcwd()}'

	" Bufferline                 > Integrate bufferline into airline
	" ----------
	let g:airline#extensions#bufferline#enabled = 1

	" Ctrlspace config           > Improved interactions with buffers and tabs
	" ----------------
	set showtabline=0
	let g:airline#extensions#ctrlspace#enabled = 1
	let g:CtrlSpaceStatuslineFunction = "airline#extensions#ctrlspace#statusline()"

	" Vim ini fold autocmd
	autocmd BufRead * normal zR

endif
