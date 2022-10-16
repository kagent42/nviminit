------------------------------------ Initialization ---------------------------------------
local set = vim.opt
local INITPATH = vim.cmd [[call stdpath('config')]] .. [[/nvim]]
-------------------------------------- SETTINGS -------------------------------------------

-- turn relative line numbers on
vim.opt.relativenumber  = true
vim.opt.nu 		= true

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

-- TODO: Rewrite functions into LUA
-------------------------------------- FUNCTIONS ------------------------------------------
-- Create aliases for nvim commands
vim.cmd [[function! SetupCommandAbbrs(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() ==# ":" && getcmdline() ==# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfunction]]


-- use <tab> for trigger completion and navigate to the next complete item
vim.cmd [[function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction]]

-- TODO: Rewrite mappings into lua
-------------------------------------- MAPPINGS ---------------------------------------------
-- Use <tab> to for autocomplete
vim.cmd [[inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()]]

-- Enter normal mode using escape in the terminal emulator
vim.cmd [[:tnoremap <Esc> <C-\><C-n>]]

-- Use init to open init config
vim.cmd [[call SetupCommandAbbrs("init","e ~/.config/nvim/init.lua")]]

-- Use "T" to open nvim-tree
vim.cmd [[call SetupCommandAbbrs("T", "NvimTreeToggle")]]
-------------------------------------- PLUGINS --------------------------------------------



-- Install plugins with Plug
vim.cmd [[call plug#begin()

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

"  vim language server
" Plug 'https://github.com/iamcco/vim-language-server'

"" --------------- Themes ------------

""  Tokyo Night
Plug 'folke/tokyonight.nvim', { 'branch': 'main' }

call plug#end()]]

-- haskell-vim settings
vim.cmd [[syntax on]]
vim.cmd [[filetype plugin indent on]]
vim.g.haskell_enable_quantification 	= 1 	-- to enable highlighting of `forall`
vim.g.haskell_enable_recursivedo 	= 1 	-- to enable highlighting of `mdo` and `rec`
vim.g.haskell_enable_arrowsyntax 	= 1 	-- to enable highlighting of `proc`
vim.g.haskell_enable_pattern_synonyms 	= 1 	-- to enable highlighting of `pattern`
vim.g.haskell_enable_typeroles 		= 1 	-- to enable highlighting of type roles
vim.g.haskell_enable_static_pointers 	= 1 	-- to enable highlighting of `static`
vim.g.haskell_backpack 			= 1 	-- to enable highlighting of backpack keywords
vim.g.haskell_classic_highlighting 	= 0	-- To enable traditional highlighting

-- configure haskell-vim indents
vim.g.haskell_indent_disable 	= 1 	-- To diable automatic indentation
vim.g.haskell_indent_if 	= 3 	-- To determine indentation depth

------------- nvim-tree ------------
-- setup nvim-tree
require("nvim-tree").setup()

-------------------------------------- COLOR SCEMES --------------------------------------------
-- Tokyo Night
vim.cmd [[colorscheme tokyonight]]
-- 	There are also colorschemes for the different styles
--	vim.cmd [[colorscheme tokyonight-night]]
--	vim.cmd [[colorscheme tokyonight-storm]]
--	vim.cmd [[colorscheme tokyonight-day]]
--	vim.cmd [[colorscheme tokyonight-moon]]
