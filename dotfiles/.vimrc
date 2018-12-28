set nocompatible              " be iMproved, required
filetype off                  " required

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'tpope/vim-sensible'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/syntastic'
Plugin 'scrooloose/nerdtree'
Plugin 'kien/ctrlp.vim'
Plugin 'mileszs/ack.vim'
Plugin 'Gundo'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'edkolev/tmuxline.vim'
Plugin 'edkolev/promptline.vim'
Plugin 'chrisbra/SudoEdit.vim'
Plugin 'Lokaltog/vim-easymotion'
Plugin 'airblade/vim-gitgutter'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'tomtom/tcomment_vim'
Plugin 'elzr/vim-json'
Plugin 'terryma/vim-expand-region'
Plugin 'tpope/vim-sleuth'
Plugin 'Chiel92/vim-autoformat'
Plugin 'digitaltoad/vim-jade'
Plugin 'regedarek/ZoomWin'
Plugin 'leafgarland/typescript-vim'
Plugin 'Quramy/tsuquyomi'
Plugin 'Shougo/vimproc.vim'
" Plugin 'blindFS/vim-taskwarrior'
" Plugin 'Valloric/YouCompleteMe'
Plugin 'othree/html5.vim'
Plugin 'pangloss/vim-javascript'
Plugin 'crusoexia/vim-javascript-lib'
Plugin 'morhetz/gruvbox'
Plugin 'justinmk/vim-sneak'
Plugin 'terryma/vim-smooth-scroll'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin on    " required
filetype plugin indent on    " required

let mapleader="\<Space>"

" for airline
let g:airline_theme='wombat'
" let g:airline_theme='gruvbox'
let g:airline_powerline_fonts=1
set guifont=Inconsolata\ for\ Powerline

syntax on
set background=dark
colorscheme gruvbox
"colorscheme wombat
" let g:gruvbox_contrast_dark = "soft"
let g:javascript_plugin_jsdoc = 1
let g:javascript_conceal_function       = "ƒ"
let g:javascript_conceal_null           = "ø"
let g:javascript_conceal_this           = "@"
let g:javascript_conceal_return         = "⇚"
let g:javascript_conceal_undefined      = "¿"
let g:javascript_conceal_NaN            = "ℕ"
let g:javascript_conceal_prototype      = "¶"
let g:javascript_conceal_static         = "•"
let g:javascript_conceal_super          = "Ω"
let g:javascript_conceal_arrow_function = "⇒"

set smartindent
set expandtab
set modelines=0
set shiftwidth=2
set clipboard=unnamed
set synmaxcol=500
" set ttyscroll=10
set encoding=utf-8
set tabstop=2
set nowrap
set number
set expandtab
set nowritebackup
set noswapfile
set nobackup
set hlsearch
set ignorecase
set smartcase
set mouse=a
set wildmenu
set colorcolumn=100

" undo config
set undodir=~/gundo
set undofile
set undolevels=10000
set undoreload=10000

" au BufNewFile * set noeol

" No show command
autocmd VimEnter * set nosc

" Jump to the next row on long lines
map <Down> gj
map <Up>   gk
nnoremap j gj
nnoremap k gk

nnoremap <Leader>w :w<CR>
nnoremap <Leader>d yy p<CR>

" format the entire file
nmap <leader>fef :Autoformat<CR>

function! JscsFix()
    "Save current cursor position"
    let l:winview = winsaveview()
    "Pipe the current buffer (%) through the jscs -x command"
    % ! jscs -x
    "Restore cursor position - this is needed as piping the file"
    "through jscs jumps the cursor to the top"
    call winrestview(l:winview)
endfunction
command! JscsFix :call JscsFix()

"Run the JscsFix command just before the buffer is written for *.js files"
" autocmd BufWritePre *.js JscsFix

" Resize buffers
if bufwinnr(1)
  nmap Ä <C-W><<C-W><
  nmap Ö <C-W>><C-W>>
  nmap ö <C-W>-<C-W>-
  nmap ä <C-W>+<C-W>+
endif

" launch gundo
map <F2> :GundoToggle<CR>

" NERDTree
nmap <leader>n :NERDTreeToggle<CR> :NERDTreeMirror<CR><CR>
nmap <leader>m :NERDTreeFind<CR>
let NERDTreeHighlightCursorline=1
let NERDTreeIgnore = ['tmp', '.yardoc', 'pkg']
let NERDTreeShowHidden=1

nmap <leader>k :let NERDTreeIgnore=['tmp', '.yardoc', 'pkg', 'js.map']<CR>

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_error_symbol = "✗"
let g:syntastic_warning_symbol = "⚠"
let g:syntastic_html_tidy_exec = 'tidy5'
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }

let g:syntastic_javascript_checkers = ['jscs']
autocmd FileType javascript let b:syntastic_checkers = ['jscs']

" CtrlP
nnoremap <silent> t :CtrlP<cr>
let g:ctrlp_working_path_mode = 'ra'
let g:ctrlp_by_filename = 1
let g:ctrlp_max_files = 900
let g:ctrlp_max_depth = 9
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\v[\/]\.(git|hg|svn)|dist|build|bower_components|node_modules$',
      \ 'file': '\.pyc$\|\.pyo$\|\.rbc$|\.rbo$\|\.class$\|\.o$\|\~$\',
      \ }
if exists("g:ctrl_user_command")
  unlet g:ctrlp_user_command
endif
set wildignore=node_modules

" Toggle paste mode
nmap <silent> <F4> :set invpaste<CR>:set paste?<CR>
imap <silent> <F4> <ESC>:set invpaste<CR>:set paste?<CR>

"Ack
map <leader>f :Ack<space>

"Special mac os x
set mouse+=a
if has("mouse_sgr")
  set ttymouse=sgr
else
  set ttymouse=xterm2
end

"JSHint
let g:JSHintHighlightErrorLine = 1
map <leader>zw :ZoomWin<CR>

set clipboard+=unnamed

let g:gitgutter_max_signs = 1000

"Vim expanding
vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Force javascript type
nmap <leader>j :set syntax=javascript<CR>

let g:promptline_preset = {
        \'a' : [ promptline#slices#host() ],
        \'b' : [ promptline#slices#user() ],
        \'c' : [ promptline#slices#cwd() ],
        \'x' : [ promptline#slices#git_status() ],
        \'y' : [ promptline#slices#vcs_branch() ],
        \'warn' : [ promptline#slices#last_exit_code() ]}

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 0, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 0, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 0, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 0, 4)<CR>
