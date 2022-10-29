------------------------------------ Initialization ---------------------------------------
local set = vim.opt
--local INITPATH = vim.cmd([[call stdpath("config")]]) .. '/nviminit'
-------------------------------------- SETTINGS -------------------------------------------
-- mixed line numbers
set.number              = true
set.relativenumber      = true

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded                = 1
vim.g.loaded_netrwPlugin    = 1

-- tabs --
set.tabstop     		= 4
set.shiftwidth          = 4
set.expandtab           = true
set.smartindent         = true

-------------------------------------- FUNCTIONS ------------------------------------------
--TODO: Rewrite functions into lua
----use this custom function for cabbrevations. This makes sure that they only
--apply in the beginning of a command. Else we might end up with stuff like
--  :%s/\vfoo/\v/\vbar/
--if we happen to move backwards in the pattern.
--For example:
--call Cabbrev('W', 'w')	
vim.cmd([[fu! Single_quote(str)
  return "'" . substitute(copy(a:str), "'", "''", 'g') . "'"
endfu
fu! Cabbrev(key, value)
  exe printf('cabbrev <expr> %s (getcmdtype() == ":" && getcmdpos() <= %d) ? %s : %s',
    \ a:key, 1+len(a:key), Single_quote(a:value), Single_quote(a:key))
endfu
]])
-- Helper function to call Cabbrev from lua
function cabbrev(from,to)
	local arg = string.format([[call Cabbrev('%s', '%s')]],from,to)
    vim.cmd(arg)
end

-- use <tab> for trigger completion and navigate to the next complete item
vim.cmd [[function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction]]
-------------------------------------- MAPPINGS ---------------------------------------------

-- Use <tab> to for autocomplete
vim.cmd [[inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()]]

-- Enter normal mode using escape in the terminal emulator
vim.cmd [[:tnoremap <Esc> <C-\><C-n>]]

-- Remove highlighting when using <CR>. Useful to press after a search.
vim.keymap.set('n', '<CR>', ':noh<CR><CR>')

-- Command shortcuts
cabbrev('init','e .config/nvim/nviminit/kath.lua')
cabbrev('T', 'NvimTreeToggle')

-- Telescope mappings
if pcall(require,'telescope.builtin') then
        print('Telescope loaded successfully!')
	    local builtin = require('telescope.builtin')
        vim.keymap.set('n', 'ff', builtin.find_files, {})
        vim.keymap.set('n', 'fg', builtin.live_grep, {})
        vim.keymap.set('n', 'fb', builtin.buffers, {})
        vim.keymap.set('n', 'fh', builtin.help_tags, {})
    else
        print('Telescope did not load properly! Execute PackerSync to ensure the files are downloaded properly')
    end

-------------------------------------- PLUGINS --------------------------------------------

-- setup packer and get plugins
vim.cmd [[packadd packer.nvim]] 
require('packer').startup(function(use)
        use 'wbthomason/packer.nvim'
		use 'folke/tokyonight.nvim'
		use 'nvim-tree/nvim-tree.lua'
		use 'nvim-tree/nvim-web-devicons'
		use 'nvim-treesitter/nvim-treesitter'
		use 'nvim-treesitter/nvim-treesitter-context'
        use { 'nvim-telescope/telescope.nvim', 
            tag = '0.1.0',
            requires = 'nvim-lua/plenary.nvim'
            }
        use { 
            'neoclide/coc.nvim',
            branch = 'release',
            ft = {'vim', 'lua', 'racket', 'scm', 'hs', 'rs'}
            }
		
		use 'neovimhaskell/haskell-vim'
		use 'alx741/vim-hindent'
        
        use 'Olical/conjure'
		

end)

-- haskell-vim settings
vim.cmd [[syntax on]]
vim.cmd [[filetype plugin indent on]]
vim.g.haskell_enable_quantification     = 1     -- to enable highlighting of `forall`
vim.g.haskell_enable_recursivedo        = 1     -- to enable highlighting of `mdo` and `rec`
vim.g.haskell_enable_arrowsyntax        = 1     -- to enable highlighting of `proc`
vim.g.haskell_enable_pattern_synonyms 	= 1 	-- to enable highlighting of `pattern`
vim.g.haskell_enable_typeroles          = 1     -- to enable highlighting of type roles
vim.g.haskell_enable_static_pointers    = 1     -- to enable highlighting of `static`
vim.g.haskell_backpack                  = 1 	-- to enable highlighting of backpack keywords
vim.g.haskell_classic_highlighting      = 0     -- To enable traditional highlighting

-- configure haskell-vim indents
vim.g.haskell_indent_disable    = 1     -- To diable automatic indentation
vim.g.haskell_indent_if         = 3     -- To determine indentation depth

-- setup nvim-tree
if pcall(require,'nvim-tree') then
    require('nvim-tree').setup()
    print('nvim-tree loaded successfully!')
else
    print('nvim-tree did not load properly! Execute PackerSync to ensure the files are downloaded properly')
end


-- setup tree-sitter
if pcall(require,'treesitter-context') then
    require('treesitter-context').setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
            -- For all filetypes
            -- Note that setting an entry here replaces all other patterns for this entry.
            -- By setting the 'default' entry below, you can control which nodes you want to
            -- appear in the context window.
            default = {
                'class',
                'function',
                'method',
                'for',
                'while',
                'if',
                'switch',
                'case',
            },
            -- Patterns for specific filetypes
            -- If a pattern is missing, *open a PR* so everyone can benefit.
            tex = {
                'chapter',
                'section',
                'subsection',
                'subsubsection',
            },
            rust = {
                'impl_item',
                'struct',
                'enum',
            },
            scala = {
                'object_definition',
            },
            vhdl = {
                'process_statement',
                'architecture_body',
                'entity_declaration',
            },
            markdown = {
                'section',
            },
            elixir = {
                'anonymous_function',
                'arguments',
                'block',
                'do_block',
                'list',
                'map',
                'tuple',
                'quoted_content',
            },
            json = {
                'pair',
            },
            yaml = {
                'block_mapping_pair',
            },
        },
        exact_patterns = {
            -- Example for a specific filetype with Lua patterns
            -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
            -- exactly match "impl_item" only)
            -- rust = true,
        },

        -- [!] The options below are exposed but shouldn't require your attention,
        --     you can safely ignore them.

        zindex = 20, -- The Z-index of the context window
        mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        }
        print('treesitter.context loaded successfully!')
    else
        print('treesitter-context did not load properly! Execute PackerSync to ensure the files are downloaded properly')
end
-------------------------------------- COLOR SCEMES --------------------------------------------
-- Tokyo Night
-- 	vim.cmd [[colorscheme tokyonight]]
-- 	There are also colorschemes for the different styles
--	vim.cmd [[colorscheme tokyonight-night]]
--	vim.cmd [[colorscheme tokyonight-storm]]
--	vim.cmd [[colorscheme tokyonight-day]]
	vim.cmd [[colorscheme tokyonight-moon]]
