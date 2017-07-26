" Support pasting from clipboard with Ctrl-V
" !NOTE: Per http://stackoverflow.com/a/14786750
set pastetoggle=<F10>
inoremap <C-v> <F10><C-r>+<F10>

" Support yanking visual selection into clipboard with Ctrl-C
" !NOTE: Per http://stackoverflow.com/a/14786750
vnoremap <C-c> "+y

" Support Ctl-C in other programs and put in Vim with "p", support yank in Vim with "y" and Ctrl-V in other programs, and use Linux's "selection" clipboard
set clipboard^=unnamed,unnamedplus

" Show the current mode at all times
set showmode

" Enforce UTF-8
set encoding=utf-8 fileencoding=utf-8

" Show line numbers
set number