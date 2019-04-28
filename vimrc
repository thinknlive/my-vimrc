set nocompatible
set hidden
syntax on
"filetype off

filetype on
filetype plugin on
filetype indent on

set mouse=a
set backspace=indent,eol,start
set ruler
set showcmd
set incsearch
set hlsearch

set relativenumber
set number

"---------------------------
"Search down into subfolders
"Provides tab-completion for all file-related tasks
set path+=**

"Display all matching files when we tab complete
set wildmenu

"- Now we can...
"- Hit tab to :find by partial match
"- use * to make it fuzzy
"--------------------------

autocmd BufNewFile,BufReadPost *.tag set filetype=html
runtime macros/matchit.vim

" https://github.com/VundleVim/Vundle.vim
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'altercation/vim-colors-solarized'
Plugin 'itchyny/calendar.vim'
"Plugin 'mattn/calendar-vim'
Plugin 'vimwiki/vimwiki'
"Plugin 'vim-scripts/dbext.vim'
Plugin 'scrooloose/nerdtree'
"Plugin 'vim-syntastic/syntastic'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'mileszs/ack.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'ap/vim-buftabline'
Plugin 'dikiaap/minimalist'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-repeat'
Plugin 'moll/vim-node.git'

"https://drivy.engineering/setting-up-vim-for-react/
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
Plugin 'mattn/emmet-vim'
Plugin 'w0rp/ale'
Plugin 'skywind3000/asyncrun.vim'
Plugin 'Chiel92/vim-autoformat'

"Plugin 'tomtom/tcomment_vim'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-dadbod'

Plugin 'file:///home/llawrencellawrence/gits/fzf'
" Plugin 'file:///home/llawrencellawrence/gits/cua-mode.vim'


" All of your Plugins must be added before the following line
call vundle#end()            " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
:" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

let g:netrw_preview   = 1
let g:netrw_liststyle = 3
let g:netrw_winsize   = 30

"set statusline+=%#warningmsg#
"set statusline+=%{SyntasticStatuslineFlag()}
"set statusline+=%*

"let g:syntastic_always_populate_loc_list = 1
"let g:syntastic_auto_loc_list = 1
"let g:syntastic_check_on_open = 1
"let g:syntastic_check_on_wq = 0

" Mostly for react jsx
let g:syntastic_javascript_checkers = ['eslint']

" --- type ° to search the word in all files in the current dir
" nmap @ :Ag <c-r>=expand("<cword>")<cr><cr>
nnoremap <space>? :Ag 
nnoremap <space>/ :FZF<CR> 

nnoremap <F3> :e #1<CR>

"nnoremap <F5> :buffers<CR>:edit #
"nnoremap <S-F5> :browse old<CR>

nnoremap <F5> :ToggleBufExplorer<CR>
nnoremap <S-F5> :buffers<CR>:edit #

nnoremap <C-Left> :bprev<CR>
nnoremap <C-Right> :bnext<CR>

nnoremap <C-S> :w<CR>

"let g:vimwiki_use_calendar=1
let g:calendar_monday=1

function! FormatJSON()
:%!python -m json.tool
endfunction

" let g:cua_mode=0

command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>

set diffopt+=iwhite
set diffexpr=""

" Yank/Paste to clipboard
vnoremap <C-y> "+y<CR>
vnoremap <C-x> "+d<CR>
nnoremap <C-p> "+p<CR>

"http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
" Tell vim to remember certain things when we exit
"  '10  :  marks will be remembered for up to 10 previously edited files
"  "100 :  will save up to 100 lines for each register
"  :20  :  up to 20 lines of command-line history will be remembered
"  %    :  saves and restores the buffer list
"  n... :  where to save the viminfo files
set viminfo='40,\"500,:500,n~/.viminfo

function! ResCur()
  if line("'\"") <= line("$")
    normal! g`"
    return 1
  endif
endfunction

augroup resCur
  autocmd!
  autocmd BufWinEnter * call ResCur()
augroup END

"http://vim.wikia.com/wiki/Folding_with_Regular_Expression
"First search for a pattern, then fold everything else with \z
"Use zr to display more context, or zm to display less context.
nnoremap \z :setlocal foldexpr=(getline(v:lnum)=~@/)?0:(getline(v:lnum-1)=~@/)\\|\\|(getline(v:lnum+1)=~@/)?1:2 foldmethod=expr foldlevel=0 foldcolumn=2<CR>

" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let undo_dir = expand('$HOME/.vim/undo_dir')
    if !isdirectory(undo_dir)
        call mkdir(undo_dir, "", 0700)
    endif
    set undodir=$HOME/.vim/undo_dir
    set undofile
endif

"http://vim.wikia.com/wiki/Easy_edit_of_files_in_the_same_directory
cabbr %% <C-R>=expand('%:p:h')<CR>

"http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  echo a:cmdline
  let expanded_cmdline = a:cmdline
  for part in split(a:cmdline, ' ')
     if part[0] =~ '\v[%#<]'
        let expanded_part = fnameescape(expand(part))
        let expanded_cmdline = substitute(expanded_cmdline, part, expanded_part, '')
     endif
  endfor
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:    ' . a:cmdline)
  call setline(2, 'Expanded Form:  ' .expanded_cmdline)
  call setline(3,substitute(getline(2),'.','=','g'))
  execute '$read !'. expanded_cmdline
  setlocal nomodifiable
  1
endfunction

"let g:user_emmet_leader_key='<C-y>'
let g:user_emmet_leader_key='<C-y>'
let g:user_emmet_settings = {
  \  'javascript.jsx' : {
    \      'extends' : 'jsx',
    \  },
  \}

let g:ale_sign_error = '●' " Less aggressive than the default '>>'
let g:ale_sign_warning = '.'
let g:ale_lint_on_enter = 0 " Less distracting when opening a new file


"https://medium.com/@kadek/understanding-vims-jump-list-7e1bfc72cdf0
"Add j and k to the jump list using a mark
nnoremap <expr> k (v:count > 1 ? "m'" . v:count : '') . 'gk'
nnoremap <expr> j (v:count > 1 ? "m'" . v:count : '') . 'gj'

"http://vim.wikia.com/wiki/Search_for_visually_selected_text
vnoremap // y/\V<C-r>=escape(@",'/\')<CR><CR>

"https://github.com/itchyny/calendar.vim/issues/49
"Open vimwiki calendar from 'Calendar'
autocmd FileType calendar nmap <buffer> <CR> :<C-u>call vimwiki#diary#calendar_action(b:calendar.day().get_day(), b:calendar.day().get_month(), b:calendar.day().get_year(), b:calendar.day().week(), "V")<CR>

function! DiffWithFileFromDisk()
let filename=expand('%')
let diffname = filename.'.fileFromBuffer'
exec 'saveas! '.diffname
diffthis
vsplit
exec 'edit '.filename
diffthis
endfunction

