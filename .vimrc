""""""""""
"  VIMRC  "
""""""""""" 

" SETTINGS {{{

" Allow saving of files as sudo
command! W execute 'silent! w !sudo /usr/bin/tee % >/dev/null' <Bar> edit!

" Set path to current file
command! -bang -nargs=* Cd  cd %:p:h

" create dir for new file
function! s:MKDir(...)
  if !a:0 || isdirectory(a:1) || filereadable(a:1) || isdirectory(fnamemodify(a:1, ':p:h'))
    return
  endif
  return mkdir(fnamemodify(a:1, ':p:h'), 'p')
endfunction
command! -bang -bar -nargs=? -complete=file E :call s:MKDir(<f-args>) | e<bang> <args>

set synmaxcol=800
set number            " show
set showcmd           " display incomplete commands
set hidden
set wildmenu          " visual autocomplete for command menu
set completeopt=menuone,noinsert,noselect
set shortmess+=atIc
set lazyredraw        " redraw only when we need to"
set mouse=a
set diffopt+=hiddenoff,algorithm:histogram
set cursorline

" make it obvious where 120 characters is
set textwidth=120
set colorcolumn=+1
set formatoptions+=w " for wraping long lines without broken words
set wrapmargin=0
set nowrap            " don't wrap long lines
set showmatch         " highlight matching brackets
set matchtime=5
set list

set novisualbell
set noerrorbells
set display=lastline
set laststatus=2
set showtabline=2
set noshowmode

set notimeout
set ttimeout
set ttimeoutlen=100
set updatetime=100

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set encoding=utf-8
set smarttab
set autoindent        " indent
set linespace=0
set scrolloff=3
set sidescrolloff=5
set backspace=indent,eol,start
set formatoptions+=roj
set nrformats-=octal
set pastetoggle=<F2>  " switch paste mode
set dictionary+=/usr/share/dict/words-insane

set clipboard=unnamedplus " yank to and paste the selection without prepending "*
set history=10000       " sets how many lines of history VIM has to remember
set tabpagemax=50
set autoread          " when file was changed
set autowrite         " save file before switching a buffer
set ruler             " show the cursor position all the time
set nostartofline
set nohidden
set nojoinspaces
set sessionoptions-=options

set incsearch         " do incremental searching
set hlsearch          " highlight same words while searching with Shift + *
set ignorecase        " /the would find 'the' or 'The', add \C if you want 'the' only
set smartcase         " while /The would find only 'The' etc.

set foldenable
set foldmethod=marker
set foldnestmax=100

" augroup AutoRead
"     autocmd!
"     autocmd FocusGained,BufEnter,CursorHold,CursorHoldI ?* if getcmdwintype() == '' | checktime | endif
"     autocmd FileChangedShellPost * echohl WarningMsg | echo "File changed on disk. Buffer reloaded." | echohl None
" augroup END

augroup CustomFolding
    autocmd!
    autocmd BufWinEnter * let &foldlevel=max(add(map(range(1, line('$')), 'foldlevel(v:val)'), 10))  " with this, everything is unfolded at start
augroup End

function! NeatFoldText()
    let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
    let lines_count = v:foldend - v:foldstart + 1
    let lines_count_text = '┤ ' . printf("%10s", lines_count . ' lines') . ' ├'
    let foldchar = matchstr(&fillchars, 'fold:\zs.')
    let foldtextstart = strpart('+ ' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
    let foldtextend = lines_count_text . repeat(foldchar, 8)
    let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
    return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()

augroup SavePosition
    autocmd!
    autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute 'normal! g`"zvzz' | endif
augroup END

set wildmode=longest:full,full
set wildignorecase
set wildignore+=.ignore,.gitignore
set wildignore+=*/.git/,*/.hg/,*/.svn/
set wildignore+=*/.ccls-cache/,*/.clangd/
set wildignore+=*.o,*.so,*.class,*.exe,*.dll,*.com
set wildignore+=.tmux,.nvimrc,.vimrc,.exrc
set wildignore+=tags,.tags,*/.backup/,*/.vim-backup/,*/.swap/,*/.vim-swap/,*/.undo/,*/.vim-undo/,*/._pkg/
set wildignore+=*.cache,*.log,*~,*#,*.bak,*.BAK,*.old,*.OLD,*.off,*.OFF,*.dist,*.DIST,*.orig,*.ORIG,*.rej,*.REJ,.DS_Store*
set wildignore+=*.swp,*.swo,*.swn,*.swm,*.tmp
set wildignore+=*.pid,*.state
set wildignore+=*.dump,*.stackdump,*.zcompdump,*.zwc,*.pcap,*.cap,*.dmp
set wildignore+=*.err,*.error,*.stderr
set wildignore+=*history,*_history,*_hist
set wildignore+=*_rsa,*_rsa.*,*_dsa,*_dsa.*,*_keys,*.pem,*.key,*.gpg

" }}}

" PLUGINS {{{

" Setup directories and vim-plug
if !filereadable($HOME . '/.vim/autoload/plug.vim')
    silent !mkdir -p ~/.vim/autoload >/dev/null 2>&1
    silent !mkdir -p ~/.vim/plugged >/dev/null 2>&1
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
                \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
                \ >/dev/null 2>&1
    autocmd VimEnter * PlugInstall
endif

call plug#begin('~/.vim/plugged')

"" File Browsing
"" FZF
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'airblade/vim-rooter'

"" MRU
Plug 'yegappan/mru'

" General
Plug 'mhinz/vim-startify'
Plug 'mbbill/undotree'
Plug 'haya14busa/incsearch.vim'
" Plug 'terryma/vim-multiple-cursors'
" Plug 'jiangmiao/auto-pairs'
Plug 'Yggdroot/indentLine'
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'
"Plug 'wellle/targets.vim'
"Plug 'easymotion/vim-easymotion'
Plug 'airblade/vim-gitgutter'
" Plug 'tpope/vim-git'
Plug 'tpope/vim-fugitive'
" Plug 'tpope/vim-surround'
" Plug 'tpope/vim-sleuth'
Plug 'tpope/vim-commentary'
" Plug 'mhinz/vim-grepper'
Plug 'jceb/vim-orgmode'
Plug 'vim-utils/vim-man'
Plug 'justinmk/vim-sneak'
Plug 'matze/vim-move'

" Tmux
Plug 'benmills/vimux'
Plug 'christoomey/vim-tmux-navigator'
Plug 'wellle/tmux-complete.vim'
Plug 'tmux-plugins/vim-tmux-focus-events'

" Themes
" Plug 'morhetz/gruvbox'
Plug 'jasolisdev/gruvbox' " fork of 'morhetz/gruvbox'
" Plug 'alfunx/gruvbox'  " fork of 'morhetz/gruvbox'
" Plug 'chriskempson/base16-vim'
" Need to be last in Plugs
Plug 'ryanoasis/vim-devicons'

" Completion
Plug 'Shougo/echodoc.vim'
Plug 'neoclide/coc.nvim', {'branch': 'release'}

"" Language Specific
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }
Plug 'mattn/emmet-vim'
Plug 'alvan/vim-closetag'
Plug 'rhysd/vim-clang-format'
Plug 'pangloss/vim-javascript'
" Plug 'prettier/vim-prettier', {
   " \ 'do': 'yarn install',
   " \ 'for': ['javascript', 'typescript', 'css', 'less', 'scss', 'json', 'graphql', 'markdown', 'vue', 'yaml', 'html'] }
Plug 'maksimr/vim-jsbeautify'
Plug 'ap/vim-css-color'
Plug 'moll/vim-node'
Plug 'jmcantrell/vim-virtualenv'
Plug 'puremourning/vimspector'

" Don't load in console
if &term !=? 'linux' || has('gui_running')
    Plug 'vim-airline/vim-airline'
endif

call plug#end()

" }}}

" THEME {{{

" Theme and colors
set termguicolors
set background=dark
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
let g:gruvbox_bold=1
let g:gruvbox_italic=1
let g:gruvbox_underline=1
let g:gruvbox_undercurl=1
colorscheme gruvbox

highlight SignColumn guibg=bg

"" Use environment variable
" if !empty($VIM_COLOR)
"     silent! colorscheme $VIM_COLOR
" else
"     silent! colorscheme gruvbox
" endif

"" Switch cursor according to mode
if &term !=? 'linux' || has('gui_running')
    let &t_SI="\<Esc>[6 q"
    let &t_SR="\<Esc>[4 q"
    let &t_EI="\<Esc>[2 q"

    " let &t_ue="\<Esc>[4:0m"
    " let &t_us="\<Esc>[4:1m"
    " let &t_Ce="\<Esc>[4:0m"
    " let &t_Cs="\<Esc>[4:3m"
endif

"" Startify
" highlight StartifyBracket guifg=#ebdbb2 ctermfg=15 
" highlight StartifyFooter  guifg=#ebdbb2 ctermfg=15 
highlight StartifyHeader  guifg=#7b8748 ctermfg=10 
" highlight StartifyNumber  guifg=#ebdbb2 ctermfg=15 
" highlight StartifyPath ctermfg=4 
" highlight StartifyPath ctermfg=4 
" highlight StartifySlash   guifg=#a89984 ctermfg=7 
" highlight StartifySpecial guifg=#a89984 ctermfg=7 
let g:startify_session_dir = '~/.config/nvim/session'
let g:startify_lists = [
          \ { 'type': 'files',     'header': ['   Files']            },
          \ { 'type': 'dir',       'header': ['   Current Directory '. getcwd()] },
          \ { 'type': 'sessions',  'header': ['   Sessions']       },
          \ { 'type': 'bookmarks', 'header': ['   Bookmarks']      },
          \ ]
let g:startify_bookmarks = [
            \ { 'c': '~/.config/i3/config' },
            \ { 'i': '~/.config/nvim/init.vim' },
            \ { 'z': '~/.zshrc' },
            \ '~/dev',
            \ ]

if &term !=? 'linux' || has('gui_running')
    set listchars=tab:›\ ,extends:>,precedes:<,nbsp:˷,eol:⤶,trail:~
    set fillchars=vert:│,fold:─,diff:-
    augroup TrailingSpaces
        autocmd!
        autocmd InsertEnter * set listchars-=eol:⤶,trail:~
        autocmd InsertLeave * set listchars+=eol:⤶,trail:~
    augroup END
else
    set listchars=tab:>\ ,extends:>,precedes:<,nbsp:+,eol:$,trail:~
    set fillchars=vert:\|,fold:-,diff:-
    augroup TrailingSpaces
        autocmd!
        autocmd InsertEnter * set listchars-=eol:$,trail:~
        autocmd InsertLeave * set listchars+=eol:$,trail:~
    augroup END
endif

" }}}

"  MAPPINGS {{{
"
" Leader key
nnoremap <Space> <Nop>
nnoremap <CR> <Nop>
let mapleader=' '
let maplocalleader=' '

" Split navigation
if exists(':TmuxNavigate')
  let g:tmux_navigator_no_mappings = 1
    nnoremap <silent> <C-h>  :<C-u>TmuxNavigateLeft<CR>
    nnoremap <silent> <C-j>  :<C-u>TmuxNavigateDown<CR>
    nnoremap <silent> <C-k>  :<C-u>TmuxNavigateUp<CR>
    nnoremap <silent> <C-l>  :<C-u>TmuxNavigateRight<CR>
    nnoremap <silent> <C-BS> :<C-u>TmuxNavigatePrevious<CR>
else
    nnoremap <silent> <C-h> <C-w><C-h>
    nnoremap <silent> <C-j> <C-w><C-j>
    nnoremap <silent> <C-k> <C-w><C-k>
    nnoremap <silent> <C-l> <C-w><C-l>
endif

"" Split resize
nnoremap <silent> <C-w>h 5<C-w><
nnoremap <silent> <C-w>j 5<C-w>-
nnoremap <silent> <C-w>k 5<C-w>+
nnoremap <silent> <C-w>l 5<C-w>>

"nnoremap <silent> <Home> <C-w><
"nnoremap <silent> <PageDown> <C-w>-
"nnoremap <silent> <PageUp> <C-w>+
"nnoremap <silent> <End> <C-w>>

"" New tab
nnoremap <silent> <C-w>t :tabnew<CR>
nnoremap <silent> <C-w><C-t> :tabnew<CR>

"" Tab navigation
nnoremap <silent> <C-w><C-h> gT
nnoremap <silent> <C-w><C-l> gt

nnoremap <C-Left> :tabprevious<CR>
nnoremap <C-Right> :tabnext<CR>
nnoremap <silent> <A-Left> :execute 'silent! tabmove ' . (tabpagenr()-2)<CR>
nnoremap <silent> <A-Right> :execute 'silent! tabmove ' . (tabpagenr()+1)<CR>

" Go to tab
" execute "set <M-1>=\<Esc>1"
" execute "set <M-2>=\<Esc>2"
" execute "set <M-3>=\<Esc>3"
" execute "set <M-4>=\<Esc>4"
" execute "set <M-5>=\<Esc>5"
" execute "set <M-6>=\<Esc>6"
" execute "set <M-7>=\<Esc>7"
" execute "set <M-8>=\<Esc>8"
" execute "set <M-9>=\<Esc>9"
nnoremap <silent> <M-1> 1gt
nnoremap <silent> <M-2> 2gt
nnoremap <silent> <M-3> 3gt
nnoremap <silent> <M-4> 4gt
nnoremap <silent> <M-5> 5gt
nnoremap <silent> <M-6> 6gt
nnoremap <silent> <M-7> 7gt
nnoremap <silent> <M-8> 8gt
nnoremap <silent> <M-9> 9gt
nnoremap <silent> <M-0> :tablast<CR>

"" Buffer navigation
"" TAB in normal mode will switch between open buffers.
nnoremap <TAB> :bnext<CR>
" SHIFT-TAB will go back
nnoremap <S-TAB> :bprevious<CR>

" Make Y behave like other commands
nnoremap <silent> Y y$

" Copy to system clipboard
nnoremap <silent> gy "+y
nnoremap <silent> gY "+Y
nnoremap <silent> gp "+p
nnoremap <silent> gP "+P
xnoremap <silent> gy "+y
xnoremap <silent> gY "+Y
xnoremap <silent> gp "+p
xnoremap <silent> gP "+P

" Remove trailing whitespaces
nnoremap <silent> <F3> mz:keepp %s/\\\@1<!\s\+$//e<CR>`z

" Select last inserted text
nnoremap gV `[v`]

"" Quickfix & Loclist
nnoremap <silent> <leader>q :copen<CR>
nnoremap <silent> <leader>l :lopen<CR>

" Scroll
map <silent> <ScrollWheelUp> <C-y>
map <silent> <ScrollWheelDown> <C-e>

"" Split navigation (vim-tmux-navigator)
let g:tmux_navigator_no_mappings=1
nnoremap <silent> <C-h> :TmuxNavigateLeft<CR>
nnoremap <silent> <C-j> :TmuxNavigateDown<CR>
nnoremap <silent> <C-k> :TmuxNavigateUp<CR>
nnoremap <silent> <C-BS> :TmuxNavigatePrevious<CR>

" Use CTRL-S for saving, also in Insert mode
nnoremap <silent> <C-s> :write<CR>
xnoremap <silent> <C-s> <Esc>:write<CR>
inoremap <silent> <C-s> <C-o>:write<CR><Esc>

" No highlight
" execute "set <M-g>=\<Esc>b"
nnoremap <silent> <M-b> :<C-u>nohlsearch<CR>

"  }}} 

" PLUGIN SETTINGS  {{{

" vimspector
let g:vimspector_enable_mappings = 'HUMAN'
nmap <leader>dd :call vimspector#Launch()<CR>
nmap <leader>dx :VimspectorReset<CR>
nmap <leader>de :VimspectorEval 
nmap <leader>dw :VimspectorWatch 
nmap <leader>do :VimspectorShowOutput 

"" vim-move
let g:move_key_modifier = 'C'

" vim-jsbeautify
map <C-b> :call JsBeautify()<cr>
" or
autocmd FileType javascript noremap <buffer>  <C-b> :call JsBeautify()<cr>
" for json
autocmd FileType json noremap <buffer> <C-b> :call JsonBeautify()<cr>
" for jsx
autocmd FileType jsx noremap <buffer> <C-b> :call JsxBeautify()<cr>
" for html
autocmd FileType html noremap <buffer> <C-b> :call HtmlBeautify()<cr>
" for css or scss
autocmd FileType css noremap <buffer> <C-b> :call CSSBeautify()<cr>

" FZF
" This is the default extra key bindings
let g:fzf_action = {
  \ 'ctrl-t': 'tab split',
  \ 'ctrl-x': 'split',
  \ 'ctrl-v': 'vsplit' }

" Enable per-command history.
" CTRL-N and CTRL-P will be automatically bound to next-history and
" previous-history instead of down and up. If you don't like the change,
" explicitly bind the keys to down and up in your $FZF_DEFAULT_OPTS.
let g:fzf_history_dir = '~/.local/share/fzf-history'

map <C-f> :Files<CR>
map <leader>b :Buffers<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>t :Tags<CR>
nnoremap <leader>m :Marks<CR>


let g:fzf_tags_command = 'ctags -R'
" Border color
let g:fzf_layout = {'up':'~90%', 'window': { 'width': 0.8, 'height': 0.8,'yoffset':0.5,'xoffset': 0.5, 'highlight': 'Todo', 'border': 'sharp' } }

let $FZF_DEFAULT_OPTS = '--layout=reverse --info=inline'
let $FZF_DEFAULT_COMMAND="rg --files --hidden"

" Customize fzf colors to match your color scheme
let g:fzf_colors =
\ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'border':  ['fg', 'Ignore'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

"Get Files
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, fzf#vim#with_preview({'options': ['--layout=reverse', '--info=inline']}), <bang>0) " Get text in files with Rg
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case '.shellescape(<q-args>), 1,
  \   fzf#vim#with_preview(), <bang>0)

" Ripgrep advanced
function! RipgrepFzf(query, fullscreen)
  let command_fmt = 'rg --column --line-number --no-heading --color=always --smart-case %s || true'
  let initial_command = printf(command_fmt, shellescape(a:query))
  let reload_command = printf(command_fmt, '{q}')
  let spec = {'options': ['--phony', '--query', a:query, '--bind', 'change:reload:'.reload_command]}
  call fzf#vim#grep(initial_command, 1, fzf#vim#with_preview(spec), a:fullscreen)
endfunction

command! -nargs=* -bang RG call RipgrepFzf(<q-args>, <bang>0)

" Git grep
command! -bang -nargs=* GGrep
  \ call fzf#vim#grep(
  \   'git grep --line-number '.shellescape(<q-args>), 0,
  \   fzf#vim#with_preview({'dir': systemlist('git rev-parse --show-toplevel')[0]}), <bang>0)

"" UltiSnips
" let g:UltiSnipsExpandTrigger='<Tab>'
" let g:UltiSnipsJumpForwardTrigger='<C-k>'
" let g:UltiSnipsJumpBackwardTrigger='<C-j>'
" let g:UltiSnipsEditSplit="vertical"

" " Change the path to custom snippets.
" let g:UltiSnipsSnippetDirectories = ['~/.vim/UltiSnips', 'UltiSnips']

" coc 
let g:coc_global_extensions = [
  \ 'coc-pairs',
  \ 'coc-prettier',
  \ 'coc-snippets',
  \ 'coc-spell-checker',
  \ 'coc-tsserver',
  \ 'coc-eslint', 
  \ 'coc-yank',
  \ 'coc-explorer',
  \ 'coc-highlight', 
  \ 'coc-git', 
  \ 'coc-emmet', 
  \ 'coc-json', 
  \ 'coc-cssmodules',
  \ 'coc-svg', 
  \ 'coc-python', 
  \ 'coc-omnisharp', 
  \ 'coc-java', 
  \ 'coc-html',
  \ 'coc-flutter',
  \ 'coc-css',
  \ 'coc-cmake', 
  \ 'coc-clangd',
  \ ]

" Some servers have issues with backup files, see #649.
" set nobackup
" set nowritebackup

" Give more space for displaying messages.
set cmdheight=1

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
inoremap <silent><expr> <c-space> coc#refresh()

" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
" position. Coc only does snippet and additional edit on confirm.
if has('patch8.1.1068')
  " Use `complete_info` if your (Neo)Vim version supports it.
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

" Use `[g` and `]g` to navigate diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
" xmap <leader>f  <Plug>(coc-format-selected)
" nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current line.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Introduce function text object
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap if <Plug>(coc-funcobj-i)
omap af <Plug>(coc-funcobj-a)

" Use <TAB> for selections ranges.
" NOTE: Requires 'textDocument/selectionRange' support from the language server.
" coc-tsserver, coc-python are the examples of servers that support it.
" nmap <silent> <TAB> <Plug>(coc-range-select)
" xmap <silent> <TAB> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings using CoCList:
" Show all diagnostics.
nnoremap <silent> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent> <space>p  :<C-u>CocListResume<CR>

" coc-explorer
nmap <space>e :CocCommand explorer<CR>
nmap <space>f :CocCommand explorer --preset floating<CR>
autocmd BufEnter * if (winnr("$") == 1 && &filetype == 'coc-explorer') | q | endif

let g:coc_explorer_global_presets = {
\   '.vim': {
\      'root-uri': '~/.vim',
\   },
\   'floating': {
\      'position': 'floating',
\   },
\   'floatingLeftside': {
\      'position': 'floating',
\      'floating-position': 'left-center',
\      'floating-width': 50,
\   },
\   'floatingRightside': {
\      'position': 'floating',
\      'floating-position': 'left-center',
\      'floating-width': 50,
\   },
\   'simplify': {
\     'file.child.template': '[selection | clip | 1] [indent][icon | 1] [filename omitCenter 1]'
\   }
\ }

"" echodoc.vim
let g:echodoc#enable_at_startup=1
let g:echodoc#type = 'echo' 

"" Undotree
nnoremap <silent> <leader>u :UndotreeToggle<CR>

" Incsearch
map / <Plug>(incsearch-forward)
map ? <Plug>(incsearch-backward)
map g/ <Plug>(incsearch-stay)

let g:incsearch#magic='\v'
let g:incsearch#smart_backward_word=1
let g:incsearch#consistent_n_direction=1
let g:incsearch#auto_nohlsearch=0
let g:incsearch#no_inc_hlsearch=1
let g:incsearch#separate_highlight=1
let g:incsearch#no_inc_hlsearch=1

" Indentlines
let g:indentLine_setConceal = 2
" default ''.
" n for Normal mode
" v for Visual mode
" i for Insert mode
" c for Command line editing, for 'incsearch'
let g:indentLine_concealcursor = "is"

"" AutoPairs
" execute "set <M-p>=\<Esc>p"
" execute "set <M-z>=\<Esc>z"
" let g:AutoPairsShortcutBackInsert='<M-z>' "let g:AutoPairs={'(':')', '[':']', '{':'}',"'":"'",'"':'"', '`':'`', '<':'>'}

"" Multiple-Cursors
" let g:multi_cursor_use_default_mapping=0
" let g:multi_cursor_start_key='<C-n>'
" let g:multi_cursor_select_all_key='<A-n>'
" let g:multi_cursor_start_word_key='g<C-n>'
" let g:multi_cursor_select_all_word_key='g<A-n>'
" let g:multi_cursor_next_key='<C-n>'
" let g:multi_cursor_prev_key='<C-p>'
" let g:multi_cursor_skip_key='<C-x>'
" let g:multi_cursor_quit_key='<Esc>'
" let g:multi_cursor_exit_from_visual_mode=0
" let g:multi_cursor_exit_from_insert_mode=0

" MRU
if !isdirectory($HOME . '/.config/nvim/mru')
    silent !mkdir -p ~/.config/nvim/mru >/dev/null 2>&1
endif
let MRU_File = '~/.config/nvim/mru/.vim_mru_files'

"" Goyo + Limelight
let g:goyo_width=90
let g:goyo_height=90

function! s:goyo_enter()
    silent !tmux set status off
    silent !tmux list-panes -F '\#F' | grep -q Z || tmux resize-pane -Z
    set nolist
    set noshowmode
    set noshowcmd
    set scrolloff=999
    set sidescrolloff=0
    IndentLinesToggle
    "Limelight
endfunction

function! s:goyo_leave()
    silent !tmux set status on
    silent !tmux list-panes -F '\#F' | grep -q Z && tmux resize-pane -Z
    set list
    set noshowmode
    set showcmd
    set scrolloff=3
    set sidescrolloff=5
    IndentLinesToggle
    "Limelight!
endfunction

augroup Goyo
    autocmd!
    autocmd User GoyoEnter nested call <SID>goyo_enter()
    autocmd User GoyoLeave nested call <SID>goyo_leave()
augroup END

"" Vimux
let g:VimuxUseNearest=1

function! VimuxSlime()
    call VimuxOpenRunner()
    call VimuxSendText(@v)
endfunction

function! SendToTmuxSplit(type, ...)
    let sel_save = &selection
    let &selection = "inclusive"
    let reg_save = @@

    if a:0  " Invoked from Visual mode, use gv command.
        silent exe "normal! gv\"vy"
    elseif a:type == 'line'
        silent exe "normal! '[V']\"vy"
    else
        silent exe "normal! `[v`]\"vy"
    endif

    call VimuxSlime()
    silent exe "normal! `v"

    let &selection = sel_save
    let @@ = reg_save
endfunction

nnoremap <silent> _ mv:set opfunc=SendToTmuxSplit<CR>g@
xnoremap <silent> _ mv:<C-U>call SendToTmuxSplit(visualmode(), 1)<CR>

"" Airline
if !exists('g:airline_symbols')
    let g:airline_symbols={}
endif

""" Unicode symbols
let g:airline_left_alt_sep='»'
let g:airline_left_sep='▶'
let g:airline_right_alt_sep='«'
let g:airline_right_sep='◀'
let g:airline_symbols.crypt='🔒'
let g:airline_symbols.linenr='☰'
let g:airline_symbols.linenr='␊'
let g:airline_symbols.linenr='␤'
let g:airline_symbols.linenr='¶'
let g:airline_symbols.maxlinenr='␤'
let g:airline_symbols.branch='⎇'
let g:airline_symbols.paste='ρ'
let g:airline_symbols.paste='Þ'
let g:airline_symbols.paste='∥'
let g:airline_symbols.spell='Ꞩ'
let g:airline_symbols.notexists='∄'
let g:airline_symbols.whitespace='Ξ'

" Powerline    
let g:airline_left_sep=''
let g:airline_left_alt_sep='>'
let g:airline_right_sep=''
let g:airline_right_alt_sep=''

" Straight ▌ │ ▐ │ or ▌ ▏ ▐ ▕
" let g:airline_left_sep='▌'
" let g:airline_left_alt_sep='│'
" let g:airline_right_sep='▐'
" let g:airline_right_alt_sep='│'

""" Powerline symbols
let g:airline_symbols.branch=''
let g:airline_symbols.readonly=''
let g:airline_symbols.linenr='☰'
let g:airline_symbols.maxlinenr=''

""" Airline settings
let g:airline_theme='gruvbox'
let g:airline#extensions#whitespace#mixed_indent_algo=1
let g:airline_powerline_fonts=1
let g:airline_skip_empty_sections=0
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#buffer_idx_mode=1
let g:airline#extensions#tabline#tab_nr_type=1
let g:airline#extensions#tabline#show_tab_nr=0
let g:airline#extensions#tabline#show_close_button=0
let g:airline#extensions#tabline#exclude_preview=1
let g:airline#extensions#tabline#fnamecollapse=1
let g:airline#extensions#tabline#fnamemod=':~:.'
let g:airline#extensions#tabline#buffers_label='buffers'
let g:airline#extensions#tabline#tabs_label='tabs'
let g:airline#extensions#tabline#overflow_marker='…'
let g:airline#extensions#tabline#formatter = 'unique_tail'
let g:airline_section_z='%3p%% %3l:%-2v'

"" Airline extensions
let g:airline#extensions#ale#error_symbol=''
let g:airline#extensions#ale#warning_symbol=''
let g:airline#extensions#ale#show_line_numbers=0
let g:airline#extensions#whitespace#show_message=1
let g:airline#extensions#hunks#enabled=0

""" GitGutter
let g:gitgutter_map_keys=0
" nmap <leader>hp <Plug>GitGutterPrevHunk
" nmap <leader>ha <Plug>GitGutterStageHunk
" nmap <leader>hu <Plug>GitGutterUndoHunk
" nmap ]c <Plug>GitGutterNextHunk
" nmap [c <Plug>GitGutterPrevHunk

let g:gitgutter_async=0
" let g:gitgutter_sign_added='┃'
" let g:gitgutter_sign_modified='┃'
" let g:gitgutter_sign_removed='◢'
" let g:gitgutter_sign_removed_first_line='◥'
" let g:gitgutter_sign_modified_removed='◢'

highlight GitGutterDelete guifg=#d3869b
highlight GitGutterAdd    guifg=#8ec07c
highlight GitGutterChange guifg=#83a598

" autocmd BufWritePost * GitGutter

" set signcolumn=no

" }}}

"  BACKUP / SWAP / UNDO  {{{

if !isdirectory($HOME . '/.vim/.backup')
    silent !mkdir -p ~/.vim/.backup >/dev/null 2>&1
endif
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/.backup/
set backupdir^=./.vim-backup/
set backup

if !isdirectory($HOME . '/.vim/.swap')
    silent !mkdir -p ~/.vim/.swap >/dev/null 2>&1
endif
set directory=./.vim-swap//
set directory+=~/.vim/.swap//
set directory+=~/.tmp//
set directory+=.

if exists('+undofile')
    if !isdirectory($HOME . '/.vim/.undo')
        silent !mkdir -p ~/.vim/.undo >/dev/null 2>&1
    endif
    set undodir=./.vim-undo//
    set undodir+=~/.vim/.undo//
    set undofile
endif

"  }}}
