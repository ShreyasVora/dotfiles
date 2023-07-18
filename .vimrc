" =====================
" General vim settings
" =====================

let mapleader = ","              " Remap leader to ,
set nocompatible                 " turn off compatibility mode
set viminfo+=:1000               " Increase vim command history
set history=1000                 " Increase vim command history
set hidden                       " Necessary for ctrlspace plugin
filetype indent plugin on        " determine filetype and indent accordingly
syntax on                        " set colour scheme settings
set t_md=                        " I think this is required to help vim work in tmux
set ignorecase smartcase         " case insensitive search except when using caps
set backspace=indent,eol,start   " allow backspacing over autoindent, line break and start of insert action
set autoindent                   " when creating new line
set visualbell                   " use visual instead of audio warning
set path+=**                     " search down into all subdirs when looking for files with :find
set wildmenu                     " when using tab completion for filenames
silent! set wildoptions=pum      " show popup menu instead of horizontal menu
set noswapfile                   " no swp file
set guioptions+=a                " visual mode text copied to clipboard (this doesn't seem to work)
set list                         " By default, show whitespace characters
let g:netrw_silent = 1           " Silence the prompts when editting files with vim scp://

" --------------------
" Colorscheme settings
" --------------------
source ~/dotfiles/vim/colorscheme.vim
set cursorline cursorcolumn

" Vim folds, game changing
set foldcolumn=1
set foldmethod=indent

" allow use of mouse
if has('mouse')
	set mouse=a
endif

" Lineno bar settings
set relativenumber number  " Show relative line number from current line
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

" ------------
" Autocommands
" ------------

augroup SetFileType
	autocmd!
	autocmd BufRead,BufNewFile .bash* set filetype=sh
	autocmd BufRead,BufNewFile procMan.* set filetype=dosini
	autocmd BufRead,BufEnter *.ini set filetype=dosini
	autocmd BufNewFile,BufRead *.md set filetype=markdown
augroup END



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
" Clear shell output and execute current script with no args
nnoremap <F9> :!clear && %:p<CR>
" Use Leader to move buffers / tabs. Map d to close buffer
nnoremap <Leader><Left> :bprev<CR>
nnoremap <Leader><Right> :bnext<CR>
noremap <Leader><Up> gT
noremap <Leader><Down> gt
nnoremap <Leader>d :bd<CR>
nnoremap <Leader>co :copen<CR>
nnoremap <Leader>cl :cclose<CR>
nnoremap <Leader>gw :Gw<CR>

" Vim folds
" zf creates a fold
" zE deletes all folds in file
" zo opens fold, zc closes. za toggles open/closed
" zR opens all folds in file, zM closes them
" If I find folds annoying, I will disable the below mapping
nnoremap <Space> zA
nnoremap z<Up> zk
nnoremap z<Down> zj
nnoremap <Leader>cp :set foldcolumn=0 nonumber norelativenumber<CR>
nnoremap <Leader>cP :set foldcolumn=1 number relativenumber<CR>

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
	Plug 'vimwiki/vimwiki'
	call plug#end()

	" NERDTree Config            > View filestructure in tree view
	" Define colors
	hi Directory ctermfg=red guifg=red
	" Mapping to open NERDTree
	nnoremap <Leader>n :NERDTreeToggle<CR>
	" Enable seeing hidden files (beginning with .)
	let NERDTreeShowHidden=1
	" Close the tab if NERDTree is the only window remaining in it.
	autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

	" Fugitive                   > An implementation of git into vim
	" --------
	autocmd StdinReadPre * let s:std_in=1
	augroup FugitiveAutocommand
		autocmd!
		autocmd VimEnter * if argc() == 0 | call timer_start(100, { -> execute('silent! 0Git') }) | endif
	augroup END

	" Git gutter                 > Show git status of lines in left bar
	" ----------
	nnoremap <Leader>g :set cursorline! cursorcolumn!<CR>:GitGutterLineHighlightsToggle<CR>
	let g:gitgutter_preview_win_floating = 1
	command! Gqf GitGutterQuickFix | copen

	" Airline Config             > Customise status bar and tabline
	" --------------
	let g:airline_theme = g:sv_color_theme  " This is defined in the imported colorschemes.vim file
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
	autocmd BufRead,BufEnter *ini normal zR

	" Vim wiki preferences
	let g:vimwiki_list = [
				\{'path': '~/scripts/docs/', 'syntax': 'markdown', 'ext': '.md'},
				\{'path': '~/scripts/docs/bash/', 'syntax': 'markdown', 'ext': '.md'},
				\{'path': '~/scripts/docs/cpp/', 'syntax': 'markdown', 'ext': '.md'},
				\{'path': '~/scripts/docs/vim/', 'syntax': 'markdown', 'ext': '.md'},
				\{'path': '~/scripts/docs/fvwm/', 'syntax': 'markdown', 'ext': '.md'}]
	let g:vimwiki_global_ext = 0

endif
