" ==============
" Key mappings
" ==============

" Motion
" -----------
nnoremap <Up> <Nop>
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap Q <Nop>
nnoremap <expr> j v:count ? 'jzz' : 'gjzz'
nnoremap <expr> k v:count ? 'kzz' : 'gkzz'
set scrolloff=9

nnoremap } }zz
nnoremap { {zz
nnoremap N Nzz
nnoremap n nzz
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
nnoremap G Gzz

" Use Leader to move buffers / tabs. Map d to close buffer
nnoremap <Leader><Left> :bprev<CR>
nnoremap <Leader><Right> :bnext<CR>
noremap <Leader><Up> gT
noremap <Leader><Down> gt
nnoremap <leader>d :bd<CR>
map <s-Right> :vertical resize +5<CR>
map <s-Left> :vertical resize -5<CR>
map <s-Up> :resize +5<CR>
map <s-Down> :resize -5<CR>

" Vim folds
" -----------
" zf creates a fold
" zE deletes all folds in file
" zo opens fold, zc closes. za toggles open/closed
" zR opens all folds in file, zM closes them, zA toggles all in current line
nnoremap z<Up> zk
nnoremap z<Down> zj
" Binds to clear up the left column in my vim to allow easier copy/pasting
nnoremap <Leader>cp :set foldcolumn=0 nonumber norelativenumber<CR>
nnoremap <Leader>cP :set foldcolumn=1 number relativenumber<CR>

" Other
" -----------

" Yank to / paste from system clipboard
nnoremap <Leader>y :let @+ = getline('.')<Bar>call setreg('+', substitute(@+, '\n', '', 'g'))<CR>
vnoremap <Leader>y "+y
nnoremap <Leader>p "+p
nnoremap <Leader>P "+P

" Make backspace erase in normal mode
nnoremap <C-H> hx

" Clear shell output and execute current script with no args
nnoremap <F9> :!clear && %:p<CR>

" nnoremap gf :call CreateAndOpenNewFile()<CR>

" function! CreateAndOpenNewFile()
		" let filename = expand('<cWORD>')
		" let vim_path = &path

		" if empty(filename)
				" echo "No filename under cursor."
				" return
		" endif

		" if !empty(globpath(vim_path, filename))
				" execute "find " . filename
		" else
				" let user_choice = input("Create new file '" . filename . "'? (y/n): ")
				" if user_choice =~? '^y$'
					" execute "edit " . filename
				" endif
		" endif
" endfunction
