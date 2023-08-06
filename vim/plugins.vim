" =====================
" Plugins and plugin settings / maps
" =====================

call plug#begin()

" Only load coc config if on dw919
" Load it first so it doesn't intrude with other keybinds
if ($HOST == "uk01dw919")
	Plug 'neoclide/coc.nvim', {'branch': 'release'}

	" Basic settings
	let g:coc_node_path='/snap/node/current/bin/node'
	set encoding=utf-8
	" Some servers have issues with backup files, see #649
	set nobackup
	set nowritebackup
	" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
	" delays and poor user experience
	set updatetime=300

	" Use tab for trigger completion with characters ahead and navigate
	" NOTE: There's always complete item selected by default, you may want to enable
	" no select by `"suggest.noselect": true` in your configuration file
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugin before putting this into your config
	inoremap <silent><expr> <TAB>
		\ coc#pum#visible() ? coc#pum#next(1) :
		\ CheckBackspace() ? "\<Tab>" :
		\ coc#refresh()
	inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

	" Make <CR> to accept selected completion item or notify coc.nvim to format
	" <C-g>u breaks current undo, please make your own choice
	inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

	function! CheckBackspace() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" GoTo code navigation
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" Use K to show documentation in preview window
	nnoremap <silent> K :call ShowDocumentation()<CR>

	function! ShowDocumentation()
		if CocAction('hasProvider', 'hover')
		call CocActionAsync('doHover')
		else
		call feedkeys('K', 'in')
		endif
	endfunction

	" Symbol renaming
	nmap <leader>rn <Plug>(coc-rename)

	augroup mygroup
		autocmd!
		" Setup formatexpr specified filetype(s)
		autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
		" Update signature help on jump placeholder
		autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
	augroup end
endif

Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
Plug 'matze/vim-ini-fold'
Plug 'tpope/vim-unimpaired'
Plug 'vimwiki/vimwiki'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'christoomey/vim-tmux-navigator'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdcommenter'
Plug 'easymotion/vim-easymotion'
Plug 'mhinz/vim-grepper'
call plug#end()


" NERDTree Config            > View filestructure in tree view
" Define colors
hi Directory ctermfg=red guifg=red
" Mapping to open NERDTree
nnoremap <Leader>n :NERDTreeToggle<CR>
" Enable seeing hidden files (beginning with .)
let NERDTreeShowHidden=1
" Close the tab if NERDTree is the only window remaining in it.
" autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Fugitive                   > An implementation of git into vim
" --------
autocmd StdinReadPre * let s:std_in=1
augroup FugitiveAutocommand
	autocmd!
	autocmd VimEnter * if argc() == 0 | call timer_start(100, { -> execute('silent! 0Git') }) | endif
augroup END
nnoremap <Leader>gw :Gw<CR>

" Git gutter                 > Show git status of lines in left bar
" ----------
let g:gitgutter_preview_win_floating = 1
"nnoremap <Leader>g :set cursorline! cursorcolumn!<CR>:GitGutterLineHighlightsToggle<CR>
command! GGA GitGutterAll
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

" Fzf
let g:fzf_layout = {'down':'40%'}
nnoremap <C-p> :FZF<CR>
nnoremap <C-g> :Rg <C-r><C-w><CR>
nnoremap <C-f> :Rg 
" Map W to w as I keep typing that by mistake.
cabbr W w

" Vim tmux navigator
let g:tmux_navigator_no_mappings = 1

noremap <silent> <M-Left> :<C-U>TmuxNavigateLeft<cr>
noremap <silent> <M-Down> :<C-U>TmuxNavigateDown<cr>
noremap <silent> <M-Up> :<C-U>TmuxNavigateUp<cr>
noremap <silent> <M-Right> :<C-U>TmuxNavigateRight<cr>

" NERD Commenter
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
"let g:NERDCustomDelimiters = { 'dosini': { 'left': '#','right': '' }}
nnoremap <C-_> <Plug>NERDCommenterTogglej
vnoremap <C-_> <Plug>NERDCommenterToggle

" Easy motion
let g:EasyMotion_smartcase = 1
let g:EasyMotion_move_highlight = 0
nmap <Leader>s <Plug>(easymotion-prefix)
nnoremap ; <Plug>(easymotion-next)
nnoremap , <Plug>(easymotion-prev)

" Vim-grepper
let g:grepper = { 'tools': ['rg', 'git', 'grep', 'findstr'], 'next_tool': '<leader>g' }
nmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)
nnoremap <leader>g :Grepper -tool rg<CR>
nnoremap <leader>G :Grepper -tool rg -buffers<cr>
nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>
command! Todo :Grepper -tool git -query '\(TODO\|FIXME\)'<CR>
