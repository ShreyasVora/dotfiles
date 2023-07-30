" ==============
" Key mappings
" ==============

" Motion
" -----------
" Use Leader to move buffers / tabs. Map d to close buffer
nnoremap <Leader><Left> :bprev<CR>
nnoremap <Leader><Right> :bnext<CR>
noremap <Leader><Up> gT
noremap <Leader><Down> gt
nnoremap <silent> <leader>d :call CloseBuffer()<CR>
function! CloseBuffer()
  if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    " Only one buffer, so close it
    execute "bd"
  else
    " More than one buffer, switch to the previous buffer and then close the current one
    execute "b# | bd #"
  endif
endfunction
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

" Change leader key
let mapleader="\<Space>"

" Yank to system clipboard
vmap Y "*y
nmap Y "*yy

" Make backspace erase in normal mode
nnoremap <C-?> hx

" Comment out lines matching previous search
nnoremap <Leader># :%g//s/^/#sv/gc<CR>

" Clear shell output and execute current script with no args
nnoremap <F9> :!clear && %:p<CR>
