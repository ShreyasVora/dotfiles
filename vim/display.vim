" ====================
" Vim display settings
" ====================

if filereadable('/home/svora/.vim/colorscheme.vim')
	source /home/svora/.vim/colorscheme.vim
endif

set cursorline cursorcolumn

" allow use of mouse
if has('mouse')
	set mouse=a
endif

" Lineno bar settings
set cmdheight=1            " command bar height
set showmatch              " show matching bracket
set showcmd                " show what keys are being hit in the bottom right
set shiftwidth=4 tabstop=4 " tab = 4 spaces

" t_ut represents terminal untranslated. It controls how vim interacts with
" the terminal when it is running inside a terminal multiplexer (eg tmux).
" By setting this to an empty value, vim will use its untranslated / raw
" control sequences when communicating with the terminal inside tmux, which
" can resolve display problems.
if &term =~ '256color'
	set t_ut=
endif

" ------------
" Autocommands
" ------------

augroup SetFileType
	autocmd!
	autocmd BufReadPre,BufNewFile,BufEnter .bash*,bash* set filetype=sh
	autocmd BufReadPre,BufNewFile,BufEnter procMan.*,*.ini set filetype=dosini
	autocmd BufReadPre,BufNewFile,BufEnter *.md set filetype=markdown
	autocmd BufReadPre,BufNewFile,BufEnter *.tmux set filetype=tmux
augroup END

augroup programming
  autocmd!
  autocmd FileType cpp,xdefaults,python,sh setlocal number relativenumber foldcolumn=1 cmdheight=2 foldmethod=indent
augroup END

" Automatically resize vim splits if vim is resized
autocmd VimResized * wincmd =

" ------------
" Misc
" ------------

" Toggle list mode on or off. This displays whitespace characters nicely
set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
nnoremap <Leader>l :set list! list?<CR>

" Toggle cursorline / column highlighting
nnoremap H :set cursorline! cursorcolumn!<CR>

" Use // to clear the highlighting of :set hlsearch.
nnoremap <silent> // :nohlsearch<C-R>=has('diff')?'<Bar>diffupdate':''<CR><CR>

" Write visual selection to a new file
command! -range -nargs=1 Vw call SaveVisualSelection(<q-args>)
function! SaveVisualSelection(filename)
	  silent! normal! gv"zy
	  call writefile(getreg('z', 1, 1), a:filename, 'a')
	  echon "Visual selection saved to " . a:filename
endfunction
