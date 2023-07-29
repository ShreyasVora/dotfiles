" ==============
" Key mappings
" ==============

" Fundamental
" -----------
nnoremap <Leader><Leader> <C-w>
" Comment out lines matching previous search
nnoremap <Leader># :%g//s/^/#sv/gc<CR>
nnoremap <C-Up> {
nnoremap <C-Down> }
" Clear shell output and execute current script with no args
nnoremap <F9> :!clear && %:p<CR>
" Use Leader to move buffers / tabs. Map d to close buffer
nnoremap <Leader><Left> :bprev<CR>
nnoremap <Leader><Right> :bnext<CR>
noremap <Leader><Up> gT
noremap <Leader><Down> gt

" Define the mapping for <leader>d
nnoremap <silent> <leader>d :call CloseBuffer()<CR>

" Function to close buffer based on buffer count
function! CloseBuffer()
    if len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
        " Only one buffer, so close it
        execute "bd"
    else
        " More than one buffer, switch to the previous buffer and then close the current one
        execute "bp | bd #"
    endif
endfunction

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

