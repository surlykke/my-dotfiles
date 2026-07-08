vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.o.timeoutlen = 300
vim.g.have_nerd_font = true
vim.o.number = true
vim.o.relativenumber = true
vim.o.mouse = 'a'
vim.o.showmode = false
vim.schedule(function() vim.o.clipboard = 'unnamedplus' end)
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.signcolumn = 'yes'
vim.o.updatetime = 250
vim.o.splitright = true
vim.o.splitbelow = true
vim.o.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.o.inccommand = 'split'
vim.o.cursorline = true
vim.o.scrolloff = 10
vim.o.ts = 4
vim.o.shiftwidth = 4
vim.o.smartindent = true
vim.o.title = true
vim.o.confirm = true

-- Plugins
vim.pack.add({'https://github.com/stevearc/oil.nvim' })
require('oil').setup()

vim.pack.add({'https://github.com/neovim/nvim-lspconfig' })
vim.lsp.enable('gopls')
vim.lsp.enable('lua_ls')
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        globals = {'vim'},  -- Recognize 'vim' as a global variable
      },
    },
  },
})
vim.diagnostic.config({
  virtual_lines = {
    only_current_line = true,
    highlight_whole_line = true,
  },
  virtual_text = false
})


vim.pack.add({'https://github.com/folke/which-key.nvim' })
require('which-key').setup({ spec = {
  {'<leader>s', group = 'Search'},
  {'<leader>w', group = 'Window'}
}})

vim.pack.add({'https://github.com/vague-theme/vague.nvim' })
vim.cmd.colorscheme('vague')

vim.pack.add({'https://github.com/nvim-lua/plenary.nvim'})

vim.pack.add({'https://github.com/nvim-telescope/telescope.nvim' })

vim.pack.add({'https://github.com/sakshamgupta05/vim-todo-highlight'})

vim.pack.add({{ src = "https://github.com/saghen/blink.cmp", version = vim.version.range("^1")}})
require('blink.cmp').setup({
  keymap = { preset = 'default' },
  appearance = { nerd_font_variant = 'mono' },
  completion = {
    list = { selection = { preselect = false, auto_insert = true } },
  },
  sources = {
    default = { 'lsp', 'path', 'snippets', 'buffer' },
  },
})

-- Configurations




-- Keys

local telescope = require('telescope.builtin')

local tidyUp = function()
  vim.lsp.buf.format()
  vim.lsp.buf.code_action {
    context = {
      only = { 'source.organizeImports' },
      diagnostics = {},
      async = false,
    },
    apply = true,
  }
end

-- Navigation/Actions
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Remove highlight' })
vim.keymap.set('n', '<leader>d', telescope.lsp_definitions, { desc = 'Definition' })
vim.keymap.set('n', '<leader>D', telescope.lsp_type_definitions, { desc = 'Type Definition' })
vim.keymap.set('n', '<leader>u', telescope.lsp_references, { desc = 'Usages' })
vim.keymap.set('n', '<leader>i', telescope.lsp_implementations, { desc = 'Implementations' })
vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, { desc = 'Actions' })
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<leader>o', '<CMD>Oil<CR>', { desc = 'Containing directory' })
vim.keymap.set('n', '<leader>q', vim.cmd.copen, { desc = 'Quickfix list' })
vim.keymap.set('n', '<leader>n', vim.cmd.cnext, { desc = 'Quickfix next' })
vim.keymap.set('n', '<leader>p', vim.cmd.cprev, { desc = 'Quickfix previous' })
vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, { desc = 'Hover documentation' })

-- Windows
vim.keymap.set('n', '<leader>ws', '<C-w>s', { desc = 'Split window horizontally'})
vim.keymap.set('n', '<leader>wS', '<C-w>v', { desc = 'Split window vertically'})
vim.keymap.set('n', '<leader>wh', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<leader>wl', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<leader>wj', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<leader>wk', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Search
vim.keymap.set('n', '<leader>st', telescope.live_grep, { desc = 'Search Text' })
vim.keymap.set('n', '<leader>sw', telescope.grep_string, { desc = 'Search current word' })
vim.keymap.set('n', '<leader>sb', telescope.buffers, { desc = 'Search buffers' })
vim.keymap.set('n', '<leader>se', telescope.diagnostics, { desc = 'Search_Errors' })
vim.keymap.set('n', '<leader>sf', telescope.find_files, { desc = 'Search Files' })
vim.keymap.set('n', '<leader>sh', telescope.help_tags, { desc = 'Search Help' })
vim.keymap.set('n', '<leader>sk', telescope.keymaps, { desc = 'Search Keymaps' })
vim.keymap.set('n', '<leader>sp', telescope.builtin, { desc = 'Search Pickers' })
vim.keymap.set('n', '<leader>sr', telescope.resume, { desc = 'Resume search' })

-- other
vim.keymap.set('n', '<leader><leader>', tidyUp, { desc = 'Organize imports and format' })


-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
