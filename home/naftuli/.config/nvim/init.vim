set showmatch
set number

filetype plugin on
filetype indent plugin on

au! BufNewFile,BufRead,BufWrite *.nvim setfiletype vim

let mapleader="\<SPACE>"
tnoremap <Esc> <C-\><C-n>

set ignorecase
set smartcase
set gdefault

set splitbelow
set splitright

set nobackup
set noswapfile

set expandtab
set tabstop=2
set shiftwidth=2

set listchars=eol:↵,nbsp:◦,tab:―→,trail:⮿,extends:⮚,precedes:⮘
set list " Show problematic characters.

" Also highlight all tabs and trailing whitespace characters.
highlight ExtraWhitespace ctermbg=red guibg=red
match ExtraWhitespace /\s\+$/
