"------------------------------------ SETTINGS -------------------------------------------

" turn relative line numbers on
:set relativenumber
:set rnu

"------------------------------------ FUNCTIONS ------------------------------------------
" Create aliases for nvim commands
function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction

" Use init to open init config
call SetupCommandAbbrs('init', 'e ~/.config/nvim/init.vim')

" use <tab> for trigger completion and navigate to the next complete item
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

"------------------------------------ MAPPINGS ---------------------------------------------
" Use <tab> to for autocomplete
inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()

" Enter normal mode using escape in the terminal emulator
:tnoremap <Esc> <C-\><C-n>

" Assign :init command to open init.vim
call SetupCommandAbbrs("init","e .config/nvim/init.vim")

"------------------------------------ PLUGINS --------------------------------------------

" Install plugins with Plug
call plug#begin()

" haskell-vim. Associates .hs files
Plug 'https://github.com/neovimhaskell/haskell-vim.git'

" coc
" Use release branch (recommend)
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" conjure
" Support for Clojure, Racket, MIT Scheme, and more
Plug 'https://github.com/Olical/conjure.git'

" vim-hindent
" automatically formatts haskell files on save
Plug 'https://github.com/alx741/vim-hindent.git'

" nvim-web-devicons
Plug 'kyazdani42/nvim-web-devicons'

" nvim-tree - tree document map and file browser
Plug 'nvim-tree/nvim-tree.lua'

" vim language server
" Plug 'https://github.com/iamcco/vim-language-server'

" --------------- Themes ------------

"  Tokyo Night
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

call plug#end()

" haskell-vim settings
syntax on
filetype plugin indent on
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
let g:haskell_classic_highlighting = 0    " To enable traditional highlighting

" configure haskell-vim indents
let g:haskell_indent_disable = 1          " To diable automatic indentation
let g:haskell_indent_if = 3               " To determine indentation depth

"------------------------------------ COLOR SCEMES --------------------------------------------
" Tokyo Night
colorscheme tokyonight
" 	There are also colorschemes for the different styles
"	colorscheme tokyonight-night
"	colorscheme tokyonight-storm
"	colorscheme tokyonight-day
"	colorscheme tokyonight-moon
