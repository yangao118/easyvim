" Modeline and Notes {
" vim: set sw=4 ts=4 sts=4 et tw=78 foldmarker={,} foldlevel=0 foldmethod=marker:
"
"   Licensed under the Apache License, Version 2.0 (the "License");
"   you may not use this file except in compliance with the License.
"   You may obtain a copy of the License at
"
"      http://www.apache.org/licenses/LICENSE-2.0
"
"   Unless required by applicable law or agreed to in writing, software
"   distributed under the License is distributed on an "AS IS" BASIS,
"   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
"   See the License for the specific language governing permissions and
"   limitations under the License.
" }

" Environment {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line

        " The default leader is '\', but many people prefer ',' as it's in a standard
        " location. To override this behavior and set it back to '\' (or any other
        " character) modify the following:
        "
        " XXX: must put let mapleader statement right at the beginning,
        " otherwise it won't work!
        "
        let mapleader = ','
        "   let maplocalleader = ','

        if !WINDOWS()
            set shell=/bin/sh
        endif

        packadd! matchit
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }

    " Arrow Key Fix {
        " https://github.com/spf13/spf13-vim/issues/780
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }

" }

" General {

    " if !has('gui')
        "set term=$TERM          " Make arrow and other keys work
    " endif
    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; to prevent this behavior, add the following:
    let g:spf13_no_autochdir = 1
    if !exists('g:spf13_no_autochdir')
        autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
        " Always switch to the current file directory
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    "set spell                           " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " http://vim.wikia.com/wiki/Restore_cursor_to_file_position_in_previous_editing_session
    " Restore cursor to file position in previous editing session
    " To disable this, add the following:
    "   let g:spf13_no_restore_cursor = 1
    if !exists('g:spf13_no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                silent! normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " To disable views add the following:
        "   let g:spf13_no_views = 1
        if !exists('g:spf13_no_views')
            " Add exclusions to mkview and loadview
            " eg: *.*, svn-commit.tmp
            let g:skipview_files = [
                \ '\[example pattern\]'
                \ ]
        endif
    " }

" }

" Vim UI {

    color desert                    " Load a colorscheme

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2
        " lightline will take care of other settings.
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    " set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
        if !exists("g:spf13_no_big_font")
            if LINUX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
            elseif OSX() && has("gui_running")
                set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
            elseif WINDOWS() && has("gui_running")
                set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
            endif
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

" }

" Formatting {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    "set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F12>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks

    "autocmd FileType go autocmd BufWritePre <buffer> Fmt
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
    " preceding line best in a plugin but here for now.

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

" }

" Plugins {

    " Specify a directory for plugins
    " - For Neovim: stdpath('data') . '/plugged'
    " - Avoid using standard Vim directory names like 'plugin'
    call plug#begin('~/.vim/plugged')

    " Make sure you use single quotes

    Plug 'preservim/nerdtree', { 'on':  'NERDTreeToggle' }
    nmap <leader>n :NERDTreeToggle<CR>
    "The NERD tree allows you to explore your filesystem and to open
    "files and directories. It presents the filesystem to you in the
    "form of a tree which you manipulate with the keyboard and/or
    "mouse. It also allows you to perform simple filesystem
    "operations.
    "
    "Should use :edit . (built-in plugin netrw), see the following:
    "http://vimcasts.org/blog/2013/01/oil-and-vinegar-split-windows-and-project-drawer/

    Plug 'itchyny/lightline.vim'
    let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'FugitiveHead'
      \ },
      \ }

    Plug 'tpope/vim-fugitive'
    "I'm not going to lie to you; fugitive.vim may very well be the
    "best Git wrapper of all time.

    Plug 'tpope/vim-surround'
    "Surround.vim is all about "surroundings": parentheses, brackets,
    "quotes, XML tags, and more. The plugin provides mappings to
    "easily delete, change and add such surroundings in pairs.
    "e.g. use ds* to delete a word surrounded by *.

    Plug 'tpope/vim-commentary'
    "Comment stuff out. Use gcc to comment out a line (takes a count),
    "gc to comment out the target of a motion (for example, gcap to
    "comment out a paragraph), gc in visual mode to comment out the
    "selection, and gc in operator pending mode to target a comment.
    "You can also use it as a command, either with a range like
    ":7,17Commentary, or as part of a :global invocation like with
    ":g/TODO/Commentary. That's it.
    "
    "alternatives: preservim/nerdcommenter, not good for nested comments.

    Plug 'tpope/vim-repeat'
    "If you've ever tried using the . command after a plugin map, you
    "were likely disappointed to discover it only repeated the last
    "native command inside that map, rather than the map as a whole.
    "That disappointment ends today. Repeat.vim remaps . in a way that
    "plugins can tap into it.

    Plug 'mg979/vim-visual-multi'
    "It's called vim-visual-multi in analogy with visual-block,
    "but the plugin works mostly from normal mode.
    "
    "alternatives: 'terryma/vim-multiple-cursors': deprecated

    Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
    " An efficient fuzzy finder that helps to locate files, buffers, mrus,
    " gtags, etc. on the fly. ctrlp is out-of-date, fzf is hard to install.

    let g:Lf_ShortcutF = '<c-p>'
    " noremap <leader>tt :LeaderfFunction!<cr>
    let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }
    let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
    let g:Lf_WorkingDirectoryMode = 'Ac'
    let g:Lf_WindowHeight = 0.30
    let g:Lf_CacheDirectory = expand('~/.vim/cache')
    let g:Lf_ShowRelativePath = 0

    " gtags settings:
    "
    " use gutentags to auto generate gtags, but use Leaderf gtags to invoke
    " gtags instead of vim-scripts/gtags.vim, to do so, must also set
    " gutentags' cache directory: g:gutentags_cache_dir to LeaderF's default
    " gtags search path.

    let g:Lf_GtagsAutoGenerate = 0
    let g:Lf_GtagsGutentags = 1



    Plug 'majutsushi/tagbar'
    nmap <F8> :TagbarToggle<CR>
    nmap <leader>tt :TagbarToggle<CR>
    "Tagbar is a Vim plugin that provides an easy way to browse
    "the tags of the current file and get an overview of its
    "structure. It does this by creating a sidebar that displays
    "the ctags-generated tags of the current file, ordered by
    "their scope. This means that for example methods in C++ are
    "displayed under the class they are defined in.
    "
    "alternatives: vim-scripts/taglist.vim
    "
    "LeaderfFunction! could partially cover tagbar functionality, but not in
    "the perfect way, turn on tagbar by default. In some cases, where the
    "source code is huge, tagbar could cause a explicit lag, because tagbar
    "will use ctags to generate tags for the current buffer. If this causes a
    "problem, turn off tagbar by hand then.

    " if executable('ag')
    "     Plug 'mileszs/ack.vim'
    "     let g:ackprg = 'ag --nogroup --nocolor --column --smart-case'
    " elseif executable('ack-grep')
    "     let g:ackprg="ack-grep -H --nocolor --nogroup --column"
    "     Plug 'mileszs/ack.vim'
    " elseif executable('ack')
    "     Plug 'mileszs/ack.vim'
    " endif
    "
    " Leaderf rg rg-arguments: work altogether with rg(ripgrep), a much
    " better choice. Requires ripgrep installed.

    Plug 'ervandew/supertab'
    "Supertab is a vim plugin which allows you to use <Tab> for all
    "your insert completion needs (:help ins-completion).
    let g:SuperTabDefaultCompletionType = '<C-n>'
    " let g:SuperTabRetainCompletionType = 2

    Plug 'jiangmiao/auto-pairs'
    "Insert or delete brackets, parens, quotes in pair.

    Plug 'mbbill/undotree'
    "The ultimate undo history visualizer for VIM
    nnoremap <F5> :UndotreeToggle<cr>

    if has('nvim') || has('patch-8.0.902')
        Plug 'mhinz/vim-signify'
    else
        Plug 'mhinz/vim-signify', { 'branch': 'legacy' }
    endif
    "Signify (or just Sy) is a quite unobtrusive plugin. It uses signs
    "to indicate added, modified and removed lines based on data of an
    "underlying version control system.
    "
    "It's fast, easy to use and well documented.
    "
    "NOTE: If git is the only version control system you use, I
    "suggest having a look at vim-gitgutter.
    "
    " Plug 'airblade/vim-gitgutter'
    set updatetime=1000

    Plug 'haya14busa/is.vim'
    "is.vim improves search feature. is.vim is successor of incsearch.vim.

    Plug 'luochen1990/rainbow'
    "As everyone knows, the most complex codes were composed of a mass
    "of different kinds of parentheses(typically: lisp). This plugin
    "will help you read these codes by showing different levels of
    "parentheses in different colors. you can also find this plugin in
    "www.vim.org.
    let g:rainbow_active = 1
    "set to 0 if you want to enable it later via :RainbowToggle

    " Plug 'godlygeek/tabular'
    "Sometimes, it's useful to line up text. Naturally, it's nicer to
    "have the computer do this for you, since aligning things by hand
    "quickly becomes unpleasant.
    "
    "alternatives: junegunn/vim-easy-align

    Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }
    "This plugin adds Go language support for Vim, comment it if you don't
    "want golang support.

    Plug 'junegunn/vim-easy-align'
    "A simple, easy-to-use Vim alignment plugin.
    " Start interactive EasyAlign in visual mode (e.g. vipga)
    xmap ga <Plug>(EasyAlign)

    " Start interactive EasyAlign for a motion/text object (e.g. gaip)
    nmap ga <Plug>(EasyAlign)
    " usage:
    " 1.ga key in visual mode, or ga followed by a motion or a text object to start interactive mode
    " 2.(Optional) Enter keys to cycle between alignment mode (left, right, or center)
    " 3.(Optional) N-th delimiter (default: 1)
    "     1 Around the 1st occurrences of delimiters
    "     2 Around the 2nd occurrences of delimiters
    "     ...
    "     * Around all occurrences of delimiters
    "     ** Left-right alternating alignment around all delimiters
    "     - Around the last occurrences of delimiters (-1)
    "     -2 Around the second to last occurrences of delimiters
    "     ...
    " 4.Delimiter key (a single keystroke; <Space>, =, :, ., |, &, #, ,) or an arbitrary regular expression followed by <CTRL-X>

    Plug 'ludovicchabant/vim-gutentags'
    "Gutentags is a plugin that takes care of the much needed management
    "of tags files in Vim. It will (re)generate tag files as you work
    "while staying completely out of your way. It will even do its best
    "to keep those tag files out of your way too. It has no dependencies and just works.
    " set tags=./.tags;,.tags " gutentags will automatically set tags
    let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
    let g:gutentags_ctags_tagfile = '.tags'

    let g:gutentags_modules = []
    if executable('ctags')
        let g:gutentags_modules += ['ctags']
    endif
    " enable gtags if available
    if executable('gtags-cscope') && executable('gtags')
        let g:gutentags_modules += ['gtags_cscope']
    endif

    " to use Leaderf gtags:
    let g:gutentags_cache_dir = expand(g:Lf_CacheDirectory.'/.LfCache/gtags')
    let g:gutentags_auto_add_gtags_cscope = 0

    " for exuberant-ctags, remove --extra=+q
    let g:gutentags_ctags_extra_args = ['--fields=+lniazS', '--extra=+q']
    let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
    let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

    " for universal-ctags only
    let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

    Plug 'ycm-core/YouCompleteMe'
    "YouCompleteMe: a code-completion engine for Vim
    "install: python3 install.py --clangd-completer --go-completer

    "setup popup windows colorscheme
    highlight PMenu ctermfg=0 ctermbg=242 guifg=black guibg=darkgrey
    highlight PMenuSel ctermfg=242 ctermbg=0 guifg=darkgrey guibg=black

    " let g:ycm_show_diagnostics_ui = 0 "will also disable ale diagnostics
    " let g:ycm_enable_diagnostic_signs = 0
    " let g:ycm_enable_diagnostic_highlighting = 0
    let g:ycm_error_symbol = 'E'
    let g:ycm_warning_symbol = 'W'
    hi! clear SpellBad
    hi! clear SpellCap
    hi! clear SpellRare
    hi! SpellBad gui=undercurl guisp=red
    hi! SpellCap gui=undercurl guisp=blue
    hi! SpellRare gui=undercurl guisp=magenta

    let g:ycm_global_ycm_extra_conf = '~/.vim/plugged/YouCompleteMe/.ycm_extra_conf.py'
    let g:ycm_confirm_extra_conf = 0
    let g:ycm_auto_hover = ''

    let g:ycm_min_num_identifier_candidate_chars = 2
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_complete_in_strings = 1
    let g:ycm_complete_in_comments = 1
    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_key_list_select_completion = ['<c-n>', '<Down>']
    let g:ycm_key_list_previous_completion = ['<c-p>', '<Up>']
    let g:ycm_key_invoke_completion = '<c-z>'
    noremap <c-z> <NOP>
    let g:ycm_add_preview_to_completeopt = 0
    set completeopt=menu,menuone

    " diagnostics filter for linux kernel development
    let g:ycm_filter_diagnostics = {
                \ "c": {
                \   "regex": [
                \     "-mno-fp-ret-in-387",
                \     "-mpreferred-stack-boundary=3",
                \     "-mskip-rax-setup",
                \     "-mindirect-branch=thunk-extern",
                \     "-mindirect-branch-register",
                \     "-fno-allow-store-data-races",
                \     "-fplugin-arg-structleak_plugin-byref-all",
                \     "-fno-var-tracking-assignments",
                \     "-fconserve-stack",
                \     "-mrecord-mcount"
                \   ]
                \ }
                \}

    let g:ycm_semantic_triggers =  {
                \ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
                \ 'cs,lua,javascript': ['re!\w{2}'],
                \ }

    Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
    " This is a script which generates a list of compiler flags from a project with an arbitrary build system. It can be used to:

    " generate a .ycm_extra_conf.py file for use with YouCompleteMe
    " generate a .color_coded file for use with color_coded
    " It works by building the project with a fake toolchain, which simply and filters compiler flags to be stored in the resulting file.

    " It is reasonably fast, taking ~10 seconds to generate a configuration file for the Linux kernel.
    "
    " You can also invoke it from within Vim using the :YcmGenerateConfig or :CCGenerateConfig commands
    " to generate a config file for the current directory.
    "
    " alternatives: use "bear make" in project directory to generate
    " generate compile_commands.json, which ycm could use instead.

    Plug 'SirVer/ultisnips'
    " Track the engine.

    Plug 'honza/vim-snippets'
    " Snippets are separated from the engine. Add this if you want them:

    " Trigger configuration. You need to change this to something else than <tab>
    " if you use https://github.com/Valloric/YouCompleteMe.
    let g:UltiSnipsExpandTrigger="<c-j>"

    Plug 'Shougo/echodoc.vim'
    "Displays function signatures from completions in the command line
    set cmdheight=2
    let g:echodoc_enable_at_startup = 1

    Plug 'octol/vim-cpp-enhanced-highlight'
    "This file contains additional syntax highlighting that I use for C++11/14/17 development in Vim.

    Plug 'vivien/vim-linux-coding-style'
    "This plugin is meant to help you respecting the Linux kernel coding style,
    "described at: https://www.kernel.org/doc/Documentation/process/coding-style.rst
    let g:linuxsty_patterns = [ "/usr/src/", "/linux" ]

    Plug 'rhysd/vim-clang-format'
    "This plugin formats your code with specific coding style using clang-format.
    let g:clang_format#code_style = "google"
    let g:clang_format#style_options = {
                \ "AccessModifierOffset" : -1,
                \ "AllowShortIfStatementsOnASingleLine" : "true",
                \ "AlwaysBreakTemplateDeclarations" : "true",
                \ "IndentWidth" : 2 }

    Plug 'ntpeters/vim-better-whitespace'
    "This plugin causes all trailing whitespace characters to be highlighted.
    "Whitespace for the current line will not be highlighted while in insert mode.
    "It is possible to disable current line highlighting while in other modes as well.
    "A helper function :StripWhitespace is also provided to make whitespace cleaning painless.

    " Initialize plugin system
    call plug#end()
" }

" Functions {

    " Initialize directories {
    function! InitializeDirectories()
        let parent = $HOME
        let prefix = 'vim'
        let dir_list = {
                    \ 'backup': 'backupdir',
                    \ 'views': 'viewdir',
                    \ 'swap': 'directory' }

        if has('persistent_undo')
            let dir_list['undo'] = 'undodir'
        endif

        " To specify a different directory in which to place the vimbackup,
        " vimviews, vimundo, and vimswap files/directories, add the following:
        "   let g:spf13_consolidated_directory = <full path to desired directory>
        "   eg: let g:spf13_consolidated_directory = $HOME . '/.vim/'
        if exists('g:spf13_consolidated_directory')
            let common_dir = g:spf13_consolidated_directory . prefix
        else
            let common_dir = parent . '/.' . prefix
        endif

        for [dirname, settingname] in items(dir_list)
            let directory = common_dir . dirname . '/'
            if exists("*mkdir")
                if !isdirectory(directory)
                    call mkdir(directory)
                endif
            endif
            if !isdirectory(directory)
                echo "Warning: Unable to create backup directory: " . directory
                echo "Try: mkdir -p " . directory
            else
                let directory = substitute(directory, " ", "\\\\ ", "g")
                exec "set " . settingname . "=" . directory
            endif
        endfor
    endfunction
    call InitializeDirectories()
    " }

    " Shell command {
    function! s:RunShellCommand(cmdline)
        botright new

        setlocal buftype=nofile
        setlocal bufhidden=delete
        setlocal nobuflisted
        setlocal noswapfile
        setlocal nowrap
        setlocal filetype=shell
        setlocal syntax=shell

        call setline(1, a:cmdline)
        call setline(2, substitute(a:cmdline, '.', '=', 'g'))
        execute 'silent $read !' . escape(a:cmdline, '%#')
        setlocal nomodifiable
        1
    endfunction

    command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }

" }

" Key (re)Mappings {

    " Easier moving in tabs and windows
    " The lines conflict with the default digraph mapping of <C-K>
    " If you prefer that functionality, add the following:
    "   let g:spf13_no_easyWindows = 1
    if !exists('g:spf13_no_easyWindows')
        map <C-J> <C-W>j
        map <C-K> <C-W>k
        map <C-L> <C-W>l
        map <C-H> <C-W>h
    endif

    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " End/Start of line motion keys act relative to row/wrap width in the
    " presence of `:set wrap`, and relative to line for `:set nowrap`.
    " Default vim behaviour is to act relative to text line in both cases
    " If you prefer the default behaviour, add the following:
    let g:spf13_no_wrapRelMotion = 1
    if !exists('g:spf13_no_wrapRelMotion')
        " Same for 0, home, end, etc
        function! WrapRelativeMotion(key, ...)
            let vis_sel=""
            if a:0
                let vis_sel="gv"
            endif
            if &wrap
                execute "normal!" vis_sel . "g" . a:key
            else
                execute "normal!" vis_sel . a:key
            endif
        endfunction

        " Map g* keys in Normal, Operator-pending, and Visual+select
        noremap $ :call WrapRelativeMotion("$")<CR>
        noremap <End> :call WrapRelativeMotion("$")<CR>
        noremap 0 :call WrapRelativeMotion("0")<CR>
        noremap <Home> :call WrapRelativeMotion("0")<CR>
        noremap ^ :call WrapRelativeMotion("^")<CR>
        " Overwrite the operator pending $/<End> mappings from above
        " to force inclusive motion with :execute normal!
        onoremap $ v:call WrapRelativeMotion("$")<CR>
        onoremap <End> v:call WrapRelativeMotion("$")<CR>
        " Overwrite the Visual+select mode mappings from above
        " to ensure the correct vis_sel flag is passed to function
        vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
    endif

    " Stupid shift key fixes
    if !exists('g:spf13_no_keyfixes')
        if has("user_commands")
            command! -bang -nargs=* -complete=file E e<bang> <args>
            command! -bang -nargs=* -complete=file W w<bang> <args>
            command! -bang -nargs=* -complete=file Wq wq<bang> <args>
            command! -bang -nargs=* -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang QA qa<bang>
            command! -bang Qa qa<bang>
        endif

        cmap Tabe tabe
    endif

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Most prefer to toggle search highlighting rather than clear the current
    " search results. To clear search highlighting rather than toggle it on
    " and off, add the following:
    "   let g:spf13_clear_search_highlight = 1
    if exists('g:spf13_clear_search_highlight')
        nmap <silent> <leader>/ :nohlsearch<CR>
    else
        nmap <silent> <leader>/ :set invhlsearch<CR>
    endif


    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Easier formatting
    nnoremap <silent> <leader>q gwip

    " FIXME: Revert this f70be548
    " fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
    map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

" }
