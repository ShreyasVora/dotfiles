" =====================
" Plugins and plugin settings / maps
" =====================

call plug#begin()
" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'junegunn/gv.vim'
Plug 'whiteinge/diffconflicts'
" Themes / display
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'bling/vim-bufferline'
Plug 'RRethy/vim-illuminate'
Plug 'machakann/vim-highlightedyank'
" Programming
Plug 'preservim/nerdcommenter'
Plug 'mhinz/vim-grepper'
Plug 'dense-analysis/ale'
Plug 'ludovicchabant/vim-gutentags'
" Built-in upgrades
Plug 'matze/vim-ini-fold'
Plug 'tpope/vim-unimpaired'
Plug 'markonm/traces.vim'
Plug 'tpope/vim-obsession'
Plug 'christoomey/vim-tmux-navigator'
" Other
Plug 'vimwiki/vimwiki'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()

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
let g:airline#extensions#ale#enabled = 1

" Bufferline                 > Integrate bufferline into airline
" ----------
let g:airline#extensions#bufferline#enabled = 1

" Vim-illuminate
" --------------
let g:Illuminate_ftwhitelist = ['vim', 'sh', 'python', 'cpp', 'xdefaults']
let g:Illuminate_ftHighlightGroups = { 'python:blacklist': ['Statement', 'Constant', 'Comment'] }
let g:Illuminate_delay = 200

" highlighted yank
" ----------------
let g:highlightedyank_highlight_duration = 300
" Vim ini fold autocmd
autocmd BufRead,BufEnter *ini normal zR

" NERD Commenter
" --------------
let g:NERDCreateDefaultMappings = 0
let g:NERDSpaceDelims = 1
let g:NERDTrimTrailingWhitespace = 1
"let g:NERDCustomDelimiters = { 'dosini': { 'left': '#','right': '' }}
nnoremap <C-_> <Plug>NERDCommenterTogglej
vnoremap <C-_> <Plug>NERDCommenterToggle

" Vim-grepper
" -----------
let g:grepper = { 'tools': ['rg', 'git', 'grep', 'findstr'], 'next_tool': '<leader>g' }
nmap gs  <plug>(GrepperOperator)
xmap gs  <plug>(GrepperOperator)
nnoremap <leader>g :Grepper -tool rg<CR>
nnoremap <leader>G :Grepper -tool rg -buffers<cr>
nnoremap <leader>* :Grepper -tool rg -cword -noprompt<cr>
" command! Todo :Grepper -tool git -query '\(TODO\|FIXME\)'<CR>

" ALE
" ---
" Note, errors seen in pylint should be managed in .config/pylintrc, not
" within ALE. As a result, there's none of that here. Anything like this
" belongs in the tool, not in ALE.
let g:ale_linters = {'python': ['pylint']}
let g:ale_set_balloons = 1
let g:ale_sign_highlight_linenrs = 1
let g:ale_virtualtext_cursor = 'current'

" gutentags
" ---------
let g:gutentags_exclude_project_root = ['/srg/dev/release/prod-config/prod/arb','/srg/dev/release/prod-config/prod/comm','/srg/dev/release/prod-config/prod/de','/srg/dev/release/prod-config/prod/bas','/srg/dev/release/prod-config/prod/ita','/srg/dev/release/prod-config/prod/nord','/srg/dev/release/prod-config/prod/can','/srg/dev/release/prod-config/prod/brz','/srg/dev/release/prod-config/prod/kr-nhf','/srg/dev/release/prod-config/prod/syd','/srg/dev/release/prod-config/prod/chi','/srg/dev/release/prod-config/prod/aurora','/srg/pro/data/support','/srg/dev/release/tools','/srg/codebase/support/pgm']
" let g:gutentags_define_advanced_commands = 1

" Vim tmux navigator
" ------------------
let g:tmux_navigator_no_mappings = 1

noremap <silent> <M-Left> :<C-U>TmuxNavigateLeft<cr>
noremap <silent> <M-Down> :<C-U>TmuxNavigateDown<cr>
noremap <silent> <M-Up> :<C-U>TmuxNavigateUp<cr>
noremap <silent> <M-Right> :<C-U>TmuxNavigateRight<cr>
inoremap <silent> <M-Left> <esc>:<C-U>TmuxNavigateLeft<cr>
inoremap <silent> <M-Down> <esc>:<C-U>TmuxNavigateDown<cr>
inoremap <silent> <M-Up> <esc>:<C-U>TmuxNavigateUp<cr>
inoremap <silent> <M-Right> <esc>:<C-U>TmuxNavigateRight<cr>

" Vim wiki preferences
" --------------------
let g:vimwiki_list = [
		\{'path': '~/scripts/docs/', 'syntax': 'markdown', 'ext': '.md'},
		\{'path': '~/scripts/docs/bash/', 'syntax': 'markdown', 'ext': '.md'},
		\{'path': '~/scripts/docs/cpp/', 'syntax': 'markdown', 'ext': '.md'},
		\{'path': '~/scripts/docs/vim/', 'syntax': 'markdown', 'ext': '.md'},
		\{'path': '~/scripts/docs/fvwm/', 'syntax': 'markdown', 'ext': '.md'}]
let g:vimwiki_global_ext = 0

" Fzf
" ---
let g:fzf_layout = {'down':'40%'}
let g:fzf_action = {
			\ 'alt-q' : 'fill-quickfix',
			\ 'alt-x' : 'split',
			\ 'alt-v' : 'vsplit'}
nnoremap <C-p> :FZF<CR>
nnoremap <C-g> :Rg <C-r><C-w><CR>
nnoremap <C-f> :Rg 
" Map W to w as I keep typing that by mistake.
cabbr W w
