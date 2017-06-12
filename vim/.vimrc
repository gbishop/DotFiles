" encoding
set encoding=utf-8
set fileencoding=utf-8

" unix line endings
set fileformat=unix
set fileformats=unix,dos

" syntax highlighting
syntax enable

" sync clipboard
set clipboard=unnamed

" set line numbers
set number
set relativenumber

" highlight the current line
set cursorline

" FINDING FILES:
" Search down into subfolders
" Provides tab-completion for all file-related tasks
set path+=**

" Display all matching files when we tab complete
set wildmenu

" NOW WE CAN:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy

" allow hidden buffers
set hidden

" minimum of 2 lines visible above/below cursor
set scrolloff=2

" adjust search behavior
set ignorecase
set smartcase " ignore case if all lowercase
set incsearch

" adjust indentation (sleuth should take care of this now)
"set expandtab 
"set shiftwidth=2 
"set softtabstop=2
set backspace=indent,eol,start

" Allow writing when sudo is needed
cmap W! w !sudo tee % >/dev/null

" Enable Ctrl-S in command and input mode
nnoremap <silent> <C-S> :wa<CR>
inoremap <c-s> <Esc>:wa<CR>

let mapleader = ";"

" Set up Solarized
let g:solarized_termtrans=1
colorscheme solarized
highlight CursorLine ctermbg=0
highlight LineNr ctermbg=0
highlight MatchParen cterm=bold ctermbg=8 ctermfg=7

" Make active windows more obvious
augroup BgHighlight
  autocmd!
  autocmd WinEnter * set cul
  autocmd WinLeave * set nocul
augroup END

" Vundle setup
set nocompatible              " be iMproved, required
filetype off                  " required

" Filetype settings
autocmd Filetype markdown setlocal wrap linebreak nolist
autocmd Filetype html setlocal wrap linebreak nolist
autocmd Filetype tpl setlocal wrap linebreak nolist
augroup filetypedetect
    au BufRead,BufNewFile *.tpl setfiletype tpl
augroup END

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'airblade/vim-gitgutter'
Plugin 'pangloss/vim-javascript'
Plugin 'tpope/vim-sleuth'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-unimpaired'
Plugin 'mihaifm/bufstop'
Plugin 'mileszs/ack.vim'
Plugin 'aperezdc/vim-template'
Plugin 'mattn/emmet-vim'
Plugin 'leafgarland/typescript-vim'
Plugin 'vim-syntastic/syntastic'
Plugin 'Quramy/tsuquyomi'
Plugin 'ianks/vim-tsx'
Plugin 'Valloric/YouCompleteMe'

" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList          - list configured plugins
" :PluginInstall(!)    - install (update) plugins
" :PluginSearch(!) foo - search (or refresh cache first) for foo
" :PluginClean(!)      - confirm (or auto-approve) removal of unused plugins
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
"
" disable auto insertion of templates
let g:templates_no_autocmd=1

" Configure syntastic
let g:tsuquyomi_disable_quickfix = 1
let g:syntastic_typescript_checkers = ['tsuquyomi', 'tslint']
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_typescript_tsline_exec="?path/bin/tslint"

" Configure completion
let g:ycm_python_binary_path = '/usr/bin/python3'
let g:ycm_autoclose_preview_window_after_insertion = 1

" Configure tsuquyomi
autocmd FileType typescript nmap <buffer> <Leader>t : <C-u>echo tsuquyomi#hint()<CR>
" bufstop configuration
map <leader>b :Bufstop<CR>             " get a visual on the buffers
map <leader>a :BufstopFast<CR>         " a command for quick switching
map <S-tab>   :BufstopBack<CR>
map <C-tab>   :BufstopForward<CR>
let g:BufstopAutoSpeedToggle = 1       " now I can press ;3;3;3 to cycle the last 3 buffers
"
" Terminal related configuration
"
" copy to attached terminal using the yank(1) script:
" https://github.com/sunaku/home/blob/master/bin/yank
" handle yy
onoremap <silent> y y:call system('yank > /dev/tty', @0)<Return>
" and y in visual mode
vnoremap <silent> y y:call system('yank > /dev/tty', @0)<Return>
" handle other cases with <leader>y to copy the yank buffer
map <leader>y :call system('yank > /dev/tty', @0)<Return>

" Code from:
" http://stackoverflow.com/questions/5585129/pasting-code-into-terminal-window-into-vim-on-mac-os-x
" then https://coderwall.com/p/if9mda
" and then https://github.com/aaronjensen/vimfiles/blob/59a7019b1f2d08c70c28a41ef4e2612470ea0549/plugin/terminaltweaks.vim
" to fix the escape time problem with insert mode.
"
" Docs on bracketed paste mode:
" http://www.xfree86.org/current/ctlseqs.html
" Docs on mapping fast escape codes in vim
" http://vim.wikia.com/wiki/Mapping_fast_keycodes_in_terminal_Vim

" not needed with new tmux
let g:bracketed_paste_tmux_wrap = 0

if !exists("g:bracketed_paste_tmux_wrap")
  let g:bracketed_paste_tmux_wrap = 1
endif

function! WrapForTmux(s)
  if !g:bracketed_paste_tmux_wrap || !exists('$TMUX')
    return a:s
  endif

  let tmux_start = "\<Esc>Ptmux;"
  let tmux_end = "\<Esc>\\"

  return tmux_start . substitute(a:s, "\<Esc>", "\<Esc>\<Esc>", 'g') . tmux_end
endfunction

let &t_SI .= WrapForTmux("\<Esc>[?2004h")
let &t_EI .= WrapForTmux("\<Esc>[?2004l")

function! XTermPasteBegin(ret)
  set pastetoggle=<f29>
  set paste
  return a:ret
endfunction

execute "set <f28>=\<Esc>[200~"
execute "set <f29>=\<Esc>[201~"
map <expr> <f28> XTermPasteBegin("i")
imap <expr> <f28> XTermPasteBegin("")
vmap <expr> <f28> XTermPasteBegin("c")
cmap <f28> <nop>
cmap <f29> <nop>

" open files in same folder as current file
map <leader>e :e <C-R>=expand("%:p:h") . "/" <CR>
map <leader>s :split <C-R>=expand("%:p:h") . "/" <CR>

" fzf integration
set rtp+=~/.fzf
map <leader>f :FZF<CR>
map <leader>F :FZF 

" fix slow close
set viminfo="NONE"

" I hate macros
nnoremap q <NOP>

" fix escape delay
set timeoutlen=1000 ttimeoutlen=10

" trigger my cheat sheet
nmap <leader>` :silent !cheatsheet vim.cheat<CR>:redraw!<CR>
