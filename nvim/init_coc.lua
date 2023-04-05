-- Install packer
local install_path = vim.fn.stdpath 'data' .. '/site/pack/packer/start/packer.nvim'
local is_bootstrap = false
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
  is_bootstrap = true
  vim.fn.system { 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path }
  vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
  -- Package manager
  use 'wbthomason/packer.nvim'

  use { -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    requires = {
      -- Automatically install LSPs to stdpath for neovim
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',

      -- Useful status updates for LSP
      'j-hui/fidget.nvim',

      -- Additional lua configuration, makes nvim stuff amazing
      'folke/neodev.nvim',
    },
  }

  use { -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    run = function()
      pcall(require('nvim-treesitter.install').update { with_sync = true })
    end,
  }

  use { -- Additional text objects via treesitter
    'nvim-treesitter/nvim-treesitter-textobjects',
    after = 'nvim-treesitter',
  }

  -- Git related plugins
  use 'tpope/vim-fugitive'
  use 'tpope/vim-rhubarb'
  use 'lewis6991/gitsigns.nvim'

  use 'navarasu/onedark.nvim' -- Theme inspired by Atom
  use 'nvim-lualine/lualine.nvim' -- Fancier statusline
  use 'lukas-reineke/indent-blankline.nvim' -- Add indentation guides even on blank lines
  use 'numToStr/Comment.nvim' -- "gc" to comment visual regions/lines
  use 'tpope/vim-sleuth' -- Detect tabstop and shiftwidth automatically

  -- Fuzzy Finder (files, lsp, etc)
  use { 'nvim-telescope/telescope.nvim', branch = '0.1.x', requires = { 'nvim-lua/plenary.nvim' } }

  -- Fuzzy Finder Algorithm which requires local dependencies to be built. Only load if `make` is available
  use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make', cond = vim.fn.executable 'make' == 1 }

  -- Neo tree for file explorer
  -- Unless you are still migrating, remove the deprecated commands from v1.x
  vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])
  use {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
    }
  }

  -- CoC for code completion
  use { 'neoclide/coc.nvim', branch = 'release' }
  -- Display GUI like buffer tabs
  use {'akinsho/bufferline.nvim', tag = "v3.*", requires = 'nvim-tree/nvim-web-devicons'}
  -- Close buffers without messing up the layout
  use 'famiu/bufdelete.nvim'
  -- Duplicate cursors and more
  use { 'mg979/vim-visual-multi', branch = 'master' }
  -- Move lines and blocks around
  use 'fedepujol/move.nvim'
  -- Terminal
  use { 'akinsho/toggleterm.nvim', tag = '*' }
  -- Inject lsp diagnostics, code actions and more. Also format code.
  use { 'jose-elias-alvarez/null-ls.nvim' }
  -- Automatically complete pair characters
  use 'windwp/nvim-autopairs'

  -- Add custom plugins to packer from ~/.config/nvim/lua/custom/plugins.lua
  local has_plugins, plugins = pcall(require, 'custom.plugins')
  if has_plugins then
    plugins(use)
  end

  if is_bootstrap then
    require('packer').sync()
  end
end)

-- When we are bootstrapping a configuration, it doesn't
-- make sense to execute the rest of the init.lua.
--
-- You'll need to restart nvim, and then it will work.
if is_bootstrap then
  print '=================================='
  print '    Plugins are being installed'
  print '    Wait until Packer completes,'
  print '       then restart nvim'
  print '=================================='
  return
end

-- Automatically source and re-compile packer whenever you save this init.lua
local packer_group = vim.api.nvim_create_augroup('Packer', { clear = true })
vim.api.nvim_create_autocmd('BufWritePost', {
  command = 'source <afile> | silent! LspStop | silent! LspStart | PackerCompile',
  group = packer_group,
  pattern = vim.fn.expand '$MYVIMRC',
})

-- [[ Setting options ]]
-- See `:help vim.o`

-- Set highlight on search
vim.o.hlsearch = false
-- Make line numbers default
vim.wo.number = true
-- Enable mouse mode
vim.o.mouse = 'a'
-- Enable break indent
vim.o.breakindent = true
-- Save undo history
vim.o.undofile = true
-- Case insensitive searching UNLESS /C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true
-- Decrease update time
vim.o.updatetime = 250
vim.wo.signcolumn = 'yes'
-- Set colorscheme
vim.o.termguicolors = true
vim.cmd [[colorscheme onedark]]
-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'
-- Set relative line numbering
vim.o.relativenumber = true
-- Set command line height to 0
vim.o.cmdheight = 0
-- Highlight current line
vim.o.cursorline = true

-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

-- Set lualine as statusline
-- See `:help lualine.txt`
require('lualine').setup {
  options = {
    icons_enabled = false,
    theme = 'onedark',
    component_separators = '|',
    section_separators = '',
  },
}

-- Enable Comment.nvim
require('Comment').setup()

-- Enable `lukas-reineke/indent-blankline.nvim`
-- See `:help indent_blankline.txt`
require('indent_blankline').setup {
  char = '┊',
  show_trailing_blankline_indent = false,
}

-- Gitsigns
-- See `:help gitsigns.txt`
require('gitsigns').setup {
  signs = {
    add = { text = '+' },
    change = { text = '~' },
    delete = { text = '_' },
    topdelete = { text = '‾' },
    changedelete = { text = '~' },
  },
}

-- [[ Configure Telescope ]]
-- See `:help telescope` and `:help telescope.setup()`
require('telescope').setup {
  defaults = {
    mappings = {
      i = {
        ['<C-u>'] = false,
        ['<C-d>'] = false,
      },
    },
  },
}

-- Enable telescope fzf native, if installed
pcall(require('telescope').load_extension, 'fzf')

-- See `:help telescope.builtin`
vim.keymap.set('n', '<leader>?', require('telescope.builtin').oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', require('telescope.builtin').buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>/', function()
  -- You can pass additional configuration to telescope to change theme, layout, etc.
  require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
    winblend = 10,
    previewer = false,
  })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<leader>sf', require('telescope.builtin').find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', require('telescope.builtin').help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', require('telescope.builtin').grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', require('telescope.builtin').live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', require('telescope.builtin').diagnostics, { desc = '[S]earch [D]iagnostics' })

-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
require('nvim-treesitter.configs').setup {
  -- Add languages to be installed here that you want installed for treesitter
  ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'rust', 'typescript', 'help', 'vim' },

  highlight = { enable = true },
  indent = { enable = false, disable = { 'python' } },
  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = '<c-space>',
      node_incremental = '<c-space>',
      scope_incremental = '<c-s>',
      node_decremental = '<c-backspace>',
    },
  },
  textobjects = {
    select = {
      enable = true,
      lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ['aa'] = '@parameter.outer',
        ['ia'] = '@parameter.inner',
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
        ['ac'] = '@class.outer',
        ['ic'] = '@class.inner',
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
      goto_next_start = {
        [']m'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      goto_next_end = {
        [']M'] = '@function.outer',
        [']['] = '@class.outer',
      },
      goto_previous_start = {
        ['[m'] = '@function.outer',
        ['[['] = '@class.outer',
      },
      goto_previous_end = {
        ['[M'] = '@function.outer',
        ['[]'] = '@class.outer',
      },
    },
    swap = {
      enable = true,
      swap_next = {
        ['<leader>a'] = '@parameter.inner',
      },
      swap_previous = {
        ['<leader>A'] = '@parameter.inner',
      },
    },
  },
}

-- Setup bufferline plugin (requires vim.opt.termguicolors = true)
vim.opt.mousemoveevent = true
require('bufferline').setup{
  options = {
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, _, _)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
    offsets = {
      {
        filetype = "neo-tree",
        text = "File Explorer",
        highlight = "Directory",
        separator = ' ', -- use a "true" to enable the default, or set your own character
      }
    },
    separator_style = "slant",
    numbers = function(opts)
      return string.format('%s', opts.raise(opts.ordinal))
    end,
  }
}

-- Setup toggleterm
require('toggleterm').setup()

-- Setup null-ls
local null_ls = require('null-ls')
null_ls.setup({
  sources = { null_ls.builtins.formatting.clang_format }
})

-- Setup nvim-autoparis with coc
-- local npairs = require('nvim-autopairs')
-- npairs.setup({ map_cr = false })
-- _G.MUtils = {}
-- MUtils.completion_confirm=function()
--   if vim.fn["coc#pum#visible"]() ~= 0 then
--     return vim.fn["coc#pum#confirm"]()
--   else
--     return npairs.autopairs_cr()
--   end
-- end
-- vim.api.nvim_set_keymap('i', '<CR>', 'v:lua.MUtils.completion_confirm()', { expr = true, noremap = true })


-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

-- BufferLine keymaps
vim.keymap.set('n', 'H', ':BufferLineCyclePrev<cr>', { desc = 'Move to previous buffer' })
vim.keymap.set('n', 'L', ':BufferLineCycleNext<cr>', { desc = 'Move to next buffer' })
vim.keymap.set('n', '<A-1>', ':BufferLineGoToBuffer 1<cr>', { desc = 'Go to BufferLine tab 1' })
vim.keymap.set('n', '<A-2>', ':BufferLineGoToBuffer 2<cr>', { desc = 'Go to BufferLine tab 2' })
vim.keymap.set('n', '<A-3>', ':BufferLineGoToBuffer 3<cr>', { desc = 'Go to BufferLine tab 3' })
vim.keymap.set('n', '<A-4>', ':BufferLineGoToBuffer 4<cr>', { desc = 'Go to BufferLine tab 4' })
vim.keymap.set('n', '<A-5>', ':BufferLineGoToBuffer 5<cr>', { desc = 'Go to BufferLine tab 5' })
vim.keymap.set('n', '<A-6>', ':BufferLineGoToBuffer 6<cr>', { desc = 'Go to BufferLine tab 6' })
vim.keymap.set('n', '<A-7>', ':BufferLineGoToBuffer 7<cr>', { desc = 'Go to BufferLine tab 7' })
vim.keymap.set('n', '<A-8>', ':BufferLineGoToBuffer 8<cr>', { desc = 'Go to BufferLine tab 8' })
vim.keymap.set('n', '<A-9>', ':BufferLineGoToBuffer 9<cr>', { desc = 'Go to BufferLine tab 9' })

-- Buffer actions
vim.keymap.set('n', '<leader>c', ':Bwipeout<cr>', { desc = 'Close current buffer' })
vim.keymap.set('n', '<leader>cc', ':Bwipeout!<cr>', { desc = 'Forcefuly Close current buffer' })
vim.keymap.set('n', '<leader>w', ':w<cr>', { desc = 'Write changes to buffer' })
vim.keymap.set('n', '<leader>q', ':q<cr>', { desc = 'Quit' })
vim.keymap.set('n', '<leader>qq', ':qa<cr>', { desc = 'Quit all' })
vim.keymap.set('n', '<A-d>', ':t .<cr>', { desc = 'Duplicate line below' })
vim.keymap.set('v', '<A-d>', ':\'<,\'>t \'><cr>', { desc = 'Duplicate selection below' })
vim.keymap.set('n', '<Tab>', [[v>]], { desc = 'Indent line' })
vim.keymap.set('n', '<S-Tab>', [[v<]], { desc = 'Unindent line' })
vim.keymap.set('v', '<Tab>', [[>gv]], { desc = 'Indent block and select it again' })
vim.keymap.set('v', '<S-Tab>', [[<gv]], { desc = 'Indent block and select it again' })
vim.keymap.set('i', '<S-Tab>', [[<BS>]], { desc = 'Provide un-tab in insert mode' })

-- Move between splits
vim.keymap.set('n', '<C-h>', ':wincmd h<cr>', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', ':wincmd j<cr>', { desc = 'Move to down split' })
vim.keymap.set('n', '<C-k>', ':wincmd k<cr>', { desc = 'Move to up split', noremap = true })
vim.keymap.set('n', '<C-l>', ':wincmd l<cr>', { desc = 'Move to right split' })
vim.keymap.set('n', '<C-q>', ':wincmd q<cr>', { desc = 'Close window' })

-- Toggle NeoTree
vim.keymap.set('n', '<leader>e', ':Neotree toggle<cr>', { desc = 'Toggle File [E]xplorer' })

-- Move.nvim actions
vim.keymap.set('n', '<A-j>', ':MoveLine(1)<cr>', { desc = 'Move line up' })
vim.keymap.set('n', '<A-k>', ':MoveLine(-1)<cr>', { desc = 'Move line down' })
vim.keymap.set('n', '<A-h>', ':MoveHChar(1)<cr>', { desc = 'Move character right' })
vim.keymap.set('n', '<A-h>', ':MoveHChar(-1)<cr>', { desc = 'Move character left' })
vim.keymap.set('v', '<A-j>', ':MoveBlock(1)<cr>', { desc = 'Move block up' })
vim.keymap.set('v', '<A-k>', ':MoveBlock(-1)<cr>', { desc = 'Move block down' })
vim.keymap.set('v', '<A-h>', ':MoveHBlock(1)<cr>', { desc = 'Move block right' })
vim.keymap.set('v', '<A-h>', ':MoveHBlock(1)<cr>', { desc = 'Move block right' })

-- ToggleTerm keymaps
vim.keymap.set('n', '<leader>tt', ':ToggleTerm direction=horizontal<cr>', { desc = 'Toggle bottom terminal' })
vim.keymap.set('n', '<leader>tf', ':ToggleTerm direction=float<cr>', { desc = 'Toggle floating terminal' })
vim.keymap.set('n', '<F7>', ':ToggleTerm<cr>', { desc = 'Toggle terminal' })
vim.keymap.set('t', '<F7>', [[<cmd>ToggleTerm<cr>]], { desc = 'Toggle terminal' })
vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], { desc = 'Escape from terminal mode' })
vim.keymap.set('t', '<C-h>', [[<esc><cmd>wincmd h<cr>]], { desc = 'Move to left split' })
vim.keymap.set('t', '<C-j>', [[<esc><cmd>wincmd j<cr>]], { desc = 'Move to down split' })
vim.keymap.set('t', '<C-k>', [[<esc><cmd>wincmd k<cr>]], { desc = 'Move to up split' })
vim.keymap.set('t', '<C-l>', [[<esc><cmd>wincmd l<cr>]], { desc = 'Move to right split' })

-- LSP settings.
--  This function gets run when an LSP connects to a particular buffer.
local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    vim.lsp.buf.format()
  end, { desc = 'Format current buffer with LSP' })
end

-- Enable the following language servers
--  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
--
--  Add any additional override configuration in the following tables. They will be passed to
--  the `settings` field of the server config. You must look up that documentation yourself.
local servers = {
  clangd = {},
  -- gopls = {},
  -- pyright = {},
  -- rust_analyzer = {},
  -- tsserver = {},

  sumneko_lua = {
    Lua = {
      workspace = { checkThirdParty = false },
      telemetry = { enable = false },
    },
  },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
  ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
  function(server_name)
    require('lspconfig')[server_name].setup {
      on_attach = on_attach,
      settings = servers[server_name],
    }
  end,
}

-- Turn on lsp status information
require('fidget').setup()

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
