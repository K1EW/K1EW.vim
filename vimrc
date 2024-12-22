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
" Disable Vim's show mode
set noshowmode

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
Plug 'jpo/vim-railscasts-theme'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'itchyny/lightline.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'morhetz/gruvbox'
Plug 'github/copilot.vim'
Plug 'vimsence/vimsence'
Plug 'christoomey/vim-tmux-navigator'
call plug#end()

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                    PLUGINS (CONFIGURATION)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Color Scheme
set bg=dark
" colorscheme railscasts
colorscheme gruvbox
autocmd VimEnter * hi Normal ctermbg=NONE guibg=NONE
hi Normal ctermbg=NONE guibg=NONE
autocmd VimEnter * hi EndOfBuffer ctermbg=NONE guibg=NONE
hi EndOfBuffer ctermbg=NONE guibg=NONE

" NERDTree
nnoremap <Leader>e :NERDTreeToggle<CR>
let g:NERDTreeShowHidden=1
let g:NERDTreeShowLineNumbers=1

" FZF
nnoremap <Leader>ff :Files<CR>
let g:fzf_layout = { 'down': '40%' }

" Lightline
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ }

" Vimsence

" LSP
let g:lsp_semantic_enabled=1
let g:lsp_diagnostics_highlights_insert_mode_enabled=0
let g:lsp_diagnostics_signs_insert_mode_enabled=0
let g:lsp_diagnostics_virtual_text_insert_mode_enabled=0
let g:lsp_diagnostics_echo_delay=100
let g:lsp_diagnostics_highlights_delay=100
let g:lsp_diagnostics_signs_delay=100
let g:lsp_diagnostics_virtual_text_delay=100

if executable('clangd')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'clangd',
                \ 'cmd': ['clangd'],
                \ 'allowlist': ['c', 'cpp'],
                \ })
    autocmd User lsp_server_init highlight! link LspSemanticVariable Normal
endif

if executable('pylsp')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'pylsp',
                \ 'cmd': ['pylsp'],
                \ 'whitelist': ['python'],
                \ 'workspace_config': {
                \     'pylsp': {
                \         'plugins': {
                \             'pyflakes': {'enabled': v:false},
                \             'mccabe': {'enabled': v:false},
                \             'pycodestyle': {'enabled': v:false},
                \         }
                \     }
                \ }})
endif

if executable('ruff')
    autocmd User lsp_setup call lsp#register_server({
                \ 'name': 'ruff',
                \ 'cmd': ['ruff', 'server'],
                \ 'allowlist': ['python'],
                \ 'workspace_config': {}
                \ })
endif

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> <leader>gd <plug>(lsp-definition)
    nmap <buffer> <leader>gs <plug>(lsp-document-symbol-search)
    nmap <buffer> <leader>gS <plug>(lsp-workspace-symbol-search)
    nmap <buffer> <leader>gr <plug>(lsp-references)
    nmap <buffer> <leader>gi <plug>(lsp-implementation)
    nmap <buffer> <leader>gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    let l:capabilities = lsp#get_server_capabilities('ruff')
    if !empty(l:capabilities)
      let l:capabilities.hoverProvider = v:false
    endif
endfunction

augroup lsp_install
    au!
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Copilot
let g:copilot_no_tab_map = v:true
imap <silent><script><expr> <C-J> copilot#Accept("\<CR>")

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                         AUTO COMMANDS
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Set the current working directory to the current buffer's directory
autocmd BufEnter * silent! lcd %:p:h
