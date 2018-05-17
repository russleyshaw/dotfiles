set nocompatible " Don't try to be vi compatible
filetype off " Helps loading of plugins

if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin()
Plug 'scrooloose/nerdtree'
Plug 'tpope/vim-sensible'
Plug 'leafgarland/typescript-vim'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'Shougo/vimproc.vim', {'do' : 'make'}
Plug 'airblade/vim-gitgutter'
Plug 'Quramy/tsuquyomi'
Plug 'scrooloose/syntastic'
Plug 'prettier/vim-prettier'
call plug#end()

filetype indent plugin on " Attempt auto-indent based on file
syntax on " Enable syntax highlighting

" Use case insensitive search, except when using capital letters
set ignorecase
set smartcase

" APPEARANCE
set encoding=utf8

set hlsearch " Highlight search results
set incsearch " Make search act like modern

" Allow backspacing over autoindent, line breaks, and start of insert action
set backspace=indent,eol,start
set autoindent " Auto indent based on same line
set copyindent " Copy previous indentation on autoindenting

set nostartofline
set ruler " Show file stats
set confirm " Prompt for save on unsaved changes
set mouse=a " Enable use of mouse for all modes

" Smart Home http://vim.wikia.com/wiki/Smart_home
noremap <expr> <silent> <Home> col('.') == match(getline('.'),'\S')+1 ? '0' : '^'
imap <silent> <Home> <C-O><Home>

set cursorline " Highlight current line

" INDENTATION
set softtabstop=4 " How many spaces in a tab when editing
set shiftwidth=4 " Shift 4 spaces
set expandtab " Use spaces instead of tabs
set smarttab " Insert tabs on start of line according to shiftwidth

set number " Enable line numbers
set nowrap " Don't wrap lines

set title

" No annoying sounds on errors
set visualbell
set noerrorbells
set t_vb=
set tm=500

set lazyredraw " Don't redraw while executing macros
set ttyfast

set nobackup
set noswapfile
set history=1000
set undolevels=1000

" ==== FOLDING ====
set foldenable " Enable folding
set foldlevelstart=10 " Open most folds by default
set foldnestmax=10 " Next 10 folds max
" Space toggles folds
nnoremap <space> za
set foldmethod=indent " Fold based on indent level

" Use ; for ;
nnoremap ; :

set wildmenu " Better command-line completion
set showcmd " show partial commands in last line

" Airline / Powerline
let g:airline_powerline_fonts=1
let g:airline_theme='simple'
let g:airline#extensions#tabline#enabled = 1

" BUFFERS/TABS
" Move left/right with Ctrl + Space + Left/Right
set hidden
nnoremap <C-S-Right> :bnext<CR>
nnoremap <C-S-Left> :bprevious<CR>

" SYNTASTIC
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi'] " You shouldn't use 'tsc' checker.

autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>

" NERDTree
autocmd vimenter * NERDTree " Automatically open NERDTree
map <C-n> :NERDTreeToggle<CR> " Open with CTRL+n
let g:NERDTreeDirArrowExpandable = '▸'
let g:NERDTreeDirArrowCollapsible = '▾'
let g:NERDTreeShowHidden=1
