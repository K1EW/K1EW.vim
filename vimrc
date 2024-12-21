"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                            OPTIONS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use the  system clipboard
set clipboard=unnamedplus
" Enable line numbers and relative line numbers
set number
set relativenumber
" Always split new buffer below and to the right
set splitbelow
set splitright
" Disable line wrapping
set nowrap
" Use spaces instead of tabs
set expandtab
set tabstop=4           " Number of spaces a tab counts for
set shiftwidth=4        " Number of spaces to use for auto-indentation
" Keep 10 lines visible when scrolling
set scrolloff=10
" Allow virtual editing in block mode
set virtualedit=block
" Ignore case when searching
set ignorecase
" Enable true color support
set termguicolors
" Disable highlighting of search results
set nohlsearch
" Always show status line
set laststatus=2

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                            KEYMAPS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Set leader key to space
let mapleader=" "
" Better way to exit insert mode than using <ESC>
inoremap jk <ESC>
" Window navigation
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
" Window resizing
nnoremap <Esc>h <C-w>5<
nnoremap <Esc>l <C-w>5>
nnoremap <Esc>j <C-w>-
nnoremap <Esc>k <C-w>+
" Close current buffer
nnoremap <leader>bd :bdelete<CR>
" Source current buffer
nnoremap <leader>xx :source %<CR>
" Move text up and down
vnoremap <Esc>j :move '>+1<CR>gv-gv
vnoremap <Esc>k :move '<-2<CR>gv-gv
" Keep centered when going half page up/down
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
" Preserve register after pasting
vnoremap p "_dP
" Preserve register after delete
nnoremap d "_d
vnoremap d "_d
" Preserve register after change
nnoremap ci "_ci
nnoremap ca "_ca
vnoremap c "_c
" Delete and save to register (cut)
nnoremap <Leader>d d
vnoremap <Leader>d d
" Indentation
vnoremap < <gv
vnoremap > >gv
" Open terminal
nnoremap <Leader>t :terminal<CR>
" Remove ^M when pasted from Windows clipboard
nnoremap <Leader>^M :keeppatterns %s/\\s\\+$\\|\\r$//e<CR>:call winrestview(winsaveview())<CR>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                      PLUGINS (INSTALLATION)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()
Plug 'preservim/nerdtree'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                    PLUGINS (CONFIGURATION)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Color Scheme
set bg=dark
colorscheme desert
autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE
hi Normal ctermbg=NONE guibg=NONE

" NERDTree
nnoremap <Leader>e :NERDTreeToggle<CR>
let g:NERDTreeShowHidden=1
let g:NERDTreeShowLineNumbers=1

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                         AUTO COMMANDS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set the current working directory to the current buffer's directory
autocmd BufEnter * silent! lcd %:p:h
