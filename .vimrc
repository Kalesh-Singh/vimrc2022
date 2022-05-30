" BASIC SETUP:
" disable vi compatibility (emulation of old bugs)
set nocompatible

" Enable 256 xterm colors
" Also set TERM=xterm-256color in bashrc
set t_Co=256

" Show filname
set title

" wrap lines at 120 chars. 80 is somewaht antiquated with modern displays
set textwidth=120

" enable syntax and plugins
syntax on


" turn absolute line numbers on
set number
set nu
" turn relative line numbers on
:set relativenumber
:set rnu

" highlight matching braces
set showmatch
" intelligent comments
set comments=sl:/*,mb:\ *,elx:\ */

" enable filetype detection:
filetype on
filetype plugin on
filetype indent on " file type based indentation


" use indentation of previous line
set autoindent
" use intelligent indentation for C
set smartindent

" ASSEMBLY AND MAKEFILES:
" in makefiles, don't expand tabs to spaces, since actual tab characters are
" needed, and have indentation at 8 chars to be sure that all indents are tabs
" (despite the mappings later):
autocmd FileType make set noexpandtab shiftwidth=8 softtabstop=0

" ensure normal tabs in assembly files
" and set to NASM syntax highlighting
autocmd FileType asm set noexpandtab shiftwidth=8 softtabstop=0 syntax=nasm

" Don't set column color unless we are doing C development
set cc=

" ==== Linux Kernel Development ======
" C development in linux kernel
autocmd BufNewFile,BufRead *.c set tabstop=8 softtabstop=8 shiftwidth=8 noexpandtab cindent cc=81
" ==== Linux Kernel Development - end ======

" FINDING FILES:
" search down into subfolders
" provides tab-completion for all file-related tasks
set path+=**
" display all matching files when we tab complete
set wildmenu
" NOW WE CAN:
" - Hit tab to :find by partial match
" - Use * to make it fuzzy
" THINGS TO CONDSIDER:
" - :ls shows all open buffers
" - :b lets you switch to any open buffer


" PLUGINS:
" For this we are using vimplug manager.
" Setup:
" curl -fLo ~/.vim/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
" Upon editing the below list of commands:
" run the command
" :PlugInstall
" To delete Plugins remove them from .vimrc and run :PlugClean

call plug#begin()
  " Some sensible setting everyone can agree on
  Plug 'tpope/vim-sensible'

  " LSP client for Vim
  Plug 'neoclide/coc.nvim', {'branch': 'release'}

  " Ccls specific addon LSP client for Vim
  Plug 'm-pilia/vim-ccls'

  " Detect indentation style
  Plug 'tpope/vim-sleuth'

  " Easy commenting out of lines
  " - Use gcc to comment out a line
  " - Use gc to comment out the target of a motion (e.g. gcap)
  Plug 'tpope/vim-commentary'

  " - Have syntax errors displayed when the file is saved.
  Plug 'vim-syntastic/syntastic'

  " Easily surrounding text:
  " Use cs'" to change ' to "
  " Use cst" to surround replace tags with "
  " Use ds" to delete in "
  " Use ys<motion><s-char> to surround motion with <s-char>
  " e.g ysiw<em> or ysiw"
  Plug 'tpope/vim-surround'

  " Use :Git <command> directly in vim
  " The most useful for me in :Git blame
  Plug 'tpope/vim-fugitive'

  " Nice Status Bar
  Plug 'vim-airline/vim-airline'

  " Highlight erroneous whitespaces
  Plug 'ntpeters/vim-better-whitespace'

call plug#end()

" ===== Vim Airline configs =====
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#whitespace#enabled = 0
let g:airline#extensions#branch#enabled=1
" ===== Vim Airline configs - end =====

" ========== NVIM.COC =================
" Set internal encoding of vim, not needed on neovim, since coc.nvim using some
" unicode characters in the file autoload/float.vim
set encoding=utf-8

" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("nvim-0.5.0") || has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion.
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

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

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Run the Code Lens action on the current line.
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> for scroll float windows/popups.
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"================== VIM CCLS ===================
let g:ccls_close_on_jump = v:true

let g:ccls_levels = 5

let g:ccls_log_file = expand('~/my_log_file.txt')


" Ccls Common Mappings
" CclsCallHierarchy: Get a hierarchy of functions calling the function under the cursor.
nnoremap <silent><nowait> g- :CclsCallHierarchy<CR>
" CclsCalleeHierahy: Get a hierarchy of functions called by the function under the cursor.
" we use '=' instead of '+' to avoid the shift but they are on the same key
nnoremap <silent><nowait> g= :CclsCalleeHierarchy<CR>

" ====== Unused configs ?
" FILE BROWSING:
" I use the built-in plugin netrw.
" Tweaks for browsing
let g:netrw_banner=0        " disable annoying banner
let g:netrw_browse_split=4  " open in prior window
let g:netrw_altv=1          " open splits to the right
let g:netrw_liststyle=3     " tree view
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_list_hide.=',\(^\|\s\s\)\zs\.\S\+'
" NOW WE CAN:
" - :edit <path> to open a file browser
" - <CR>/v/t to open in h-split/v-split/tab

" TABS AND SPLITS:
" Use :vs <path-to-file> to split veritcally
" Use :sp <path-to-file> to split horizontally
" Use :tabnew <path-to-file> to open in a new tab
" Use gt or :tabn to go to next tab
" Use gT or :tabp or :tabN) to go to previous tab
" Use #gt or :tabn # to go to #th tab
" Use :tabr to go to first tab
" Use :tabl to go to last tab
" Use :tabm to move the current tab to the last position
" Use :tabm # to move the current tab to the #th position

" SWITCHING BETWEEN SPLIST/WINDOWS
"  CTRL-W j (or CTRL-W <down> or CTRL-W CTRL-J)
"
" COPY PASTE SYSTEM CLIP BOARD:
" We can use the special + register which connects to
" the system clip board.
" This doesn't work in versions of vim aren't compiled
" with  this option.
" I use vim-gtk3 on ubuntu.
" NOW WE CAN:
" - Use "+y to copy to the system clipboard
" - Use "+p to paste from the system clipboard

" AVOIDING ESCAPE:
" I don't particularly like doing system-wide remaps
" of the ESC key -- the most popular being:
" ESC --> CAPS LOCK
" I'd rather avoid the use of escape all together.
" NOW WE CAN:
" 1. <Alt> + <key> - Most terminals will send <Esc> + <key>
" 2. <Ctrl> + c - Most terminals will send <Esc>
" 3. <Ctrl> + [ - Most terminals will send <Esc>

" AUTOCOMPLETE:
" This is a built-in feature
" NOW WE CAN:
" - Use <Ctrl> + n and <Ctrl> + p to go back and forth in the suggestion list.
" EXTRAS:
" - Use <Ctrl> + x + <Ctrl> + n for JUST this file.
" - Use <Ctrl> + x + <Ctrl> + f for JUST filenames.
" - Use <Ctrl> + x + <Ctrl> + ] for tags only.

" CHANGING AND DELETING TEXT QUICKLY:
" I use ci and di a lot.
" NOW WE CAN USE:
" ciw
" ci)
" ci}
" ci'
" ci"
" ct<char> - change until <char>
" cf<char> - change until and including <char>
" And similarly for the d operator and y operators.


