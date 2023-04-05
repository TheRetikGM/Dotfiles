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
vim.keymap.set('n', '<leader>sk', require('telescope.builtin').keymaps, { desc = '[S]earch [K]eymaps' })

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
vim.keymap.set('n', '<A-S-h>', ':BufferLineMovePrev<cr>', { desc = 'Move buffer to the left' })
vim.keymap.set('n', '<A-S-l>', ':BufferLineMoveNext<cr>', { desc = 'Move buffer to the right' })

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
vim.keymap.set('n', '<leader>st', ':set filetype=', { desc = '[S]et buffer File[T]ype'})

-- Move between splits
vim.keymap.set('n', '<C-h>', ':wincmd h<cr>', { desc = 'Move to left split' })
vim.keymap.set('n', '<C-j>', ':wincmd j<cr>', { desc = 'Move to down split' })
vim.keymap.set('n', '<C-k>', ':wincmd k<cr>', { desc = 'Move to up split' })
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

-- Session management
vim.keymap.set('n', '<leader>ss', ':SearchSession<cr>', { desc = '[S]earch [S]ession' })
vim.keymap.set('n', '<leader>rs', ':RestoreSession<cr>', { desc = '[R]estore [S]ession' })

-- Useful workflow keybindings
vim.keymap.set('n', '<F29>', ':wa<cr>:ToggleTerm<cr><C-u>cargo run<cr>', { remap = true, desc = "Rust cargo run" })
vim.keymap.set('i', '<F29>', '<ESC>:wa<cr>:ToggleTerm<cr><C-u>cargo run<cr>', { desc = "Rust cargo run" })
