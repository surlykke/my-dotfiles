-- vim: ts=4 sts=4 sw=4 et
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

-- LSP
--
vim.filetype.add({
    pattern = {
        [".*%.gohtml"] = 'html',
    },
})

vim.diagnostic.config({
    virtual_lines = {
        only_current_line = true,
        highlight_whole_line = true,
    },
    virtual_text = false
})

-- Lsp
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end
})

vim.lsp.enable('gopls')
vim.lsp.config("gopls", {
    filetypes = {
        "go", "gomod", "gohtml"
    },
    settings = {
        gopls = {
            hints = {
                assignVariableTypes = true,
                compositeLiteralFields = true,
                compositeLiteralTypes = true,
                constantValues = true,
                functionTypeParameters = true,
                ignoredError = true,
                parameterNames = true,
                rangeVariableTypes = true,
            },
            symbolScope = "workspace",
        },
        templateExtensions = {
            "gohtml"
        },
    },
})

vim.lsp.enable('lua_ls')
vim.lsp.config('lua_ls', {
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' }, -- Recognize 'vim' as a global variable
            },
        },
    },
})
vim.lsp.enable('html')
vim.lsp.config('html', {
    filetypes = { "html", "gohtml" }
})
vim.lsp.enable('ts_ls')
vim.lsp.config('ts_ls', {
    init_options = {
        tsserver = { -- Assuming 'sudo npm install -g typescript-language-server typescript' has been done
            path = "/usr/local/lib/node_modules/vscode-langservers-extracted/node_modules/typescript/lib"
        }
    }
})

vim.lsp.enable('jsonls')


-- Plugins

vim.pack.add({
    { src = 'https://github.com/nvim-mini/mini.completion' },
    { src = 'https://github.com/nvim-mini/mini.statusline' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter' },
    { src = 'https://github.com/stevearc/oil.nvim' },
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/ThePrimeagen/harpoon',             version = 'harpoon2' },
    { src = 'https://github.com/folke/which-key.nvim' },
    { src = 'https://github.com/vague-theme/vague.nvim' },
    { src = 'https://github.com/sakshamgupta05/vim-todo-highlight' },
    { src = 'https://github.com/dk949/file_line.nvim' },
    { src = 'https://github.com/mfussenegger/nvim-dap' },
    { src = 'https://github.com/theHamsta/nvim-dap-virtual-text' },
    { src = 'https://github.com/leoluz/nvim-dap-go.git' },
    { src = 'https://github.com/igorlfs/nvim-dap-view',            version = vim.version.range('1.*') },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    { src = 'https://github.com/ibhagwan/fzf-lua' },
})


require('mini.completion').setup()
require('mini.statusline').setup()
require('nvim-treesitter').setup()
require('nvim-treesitter').install('go')
require "file_line".register()
require("nvim-dap-virtual-text").setup()
require('dap-go').setup()
require("harpoon").setup()
require('fzf-lua').setup({
  keymap = {
    builtin = {
      ["<C-space>"] = "toggle-preview",
      ["<C-f>"] = "toggle-fullscreen",
      ["<C-n>"] = "preview-page-down",
      ["<C-p>"] = "preview-page-up",
    },
  },
})
vim.cmd.colorscheme('vague')

require('oil').setup({
    default_file_explorer = true,
    keymaps = {
        ['<leader>v'] = { 'actions.preview', mode = 'n', desc = 'Preview' },
        ['<leader>.'] = { 'actions.toggle_hidden', mode = 'n', desc = 'Show hidden files' },
    },
    preview_win = {
        update_on_cursor_moved = true,
        preview_method = "fast_scratch",
        win_options = {},
    },
})
require('which-key').setup({
    spec = {
        { '<leader>f', group = 'Find' },
        { '<leader>w', group = 'Window' },
        { '<leader>d', group = 'Debug' },
    }
})



local tidyUp = function()
    vim.lsp.buf.format()
    vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' }, diagnostics = {}, async = false, }, apply = true, }
end

local toggleInlayHints = function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end

local toggleHarpoonList = function()
    require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())
end

-- Keymappings

-- Actions
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Remove highlight' })
vim.keymap.set('n', '<leader>b', '<C-o>', { desc = 'Go back' })
vim.keymap.set('n', '<leader><leader>', tidyUp, { desc = 'Organize imports and format' })
vim.keymap.set('n', '<leader>i', toggleInlayHints, { desc = 'toggle inlay hints' })
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, { desc = 'Hover documentation' })
vim.keymap.set('n', '<leader>o', '<CMD>Oil<CR>', { desc = 'Containing directory' })


-- Windows
vim.keymap.set('n', '<leader>ws', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>wS', '<C-w>s', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>wh', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<leader>wl', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<leader>wj', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<leader>wk', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Find stuff
local fzf_lua = require('fzf-lua')
vim.keymap.set('n', '<leader>ff', function() fzf_lua.files({resume = true}) end, { desc = 'Find files' })
vim.keymap.set('n', '<leader>ft', function() fzf_lua.live_grep({resume = true}) end, { desc = 'Find Text' })

--vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Find current word' }) -- TODO:
vim.keymap.set('n', '<leader>fb', function() fzf_lua.buffers({resume = true}) end, { desc = 'Find buffers' })
vim.keymap.set('n', '<leader>fe', function() fzf_lua.diagnostics_document({resume = true}) end, { desc = 'Find Errors' })
vim.keymap.set('n', '<leader>fE', function() fzf_lua.diagnostics_workspace({resume = true}) end, { desc = 'Find Errors' })
vim.keymap.set('n', '<leader>fh', function() fzf_lua.helptags({resume = true}) end, { desc = 'Find Help' })
vim.keymap.set('n', '<leader>fk', function() fzf_lua.keymaps({resume = true}) end, { desc = 'Find Keymaps' })
vim.keymap.set('n', '<leader>fu', function() fzf_lua.lsp_references({resume = true}) end, { desc = 'Find usages' })
vim.keymap.set('n', '<leader>fi', function() fzf_lua.lsp_implementations({resume = true}) end, { desc = 'Find implementations' })
vim.keymap.set('n', '<leader>fs', function() fzf_lua.lsp_document_symbols({resume = true}) end, { desc = 'Find symbols in current file' })
vim.keymap.set('n', '<leader>fS', function() fzf_lua.lsp_live_workspace_symbols({resume = true}) end, { desc = 'Find symbols in workspace' })
vim.keymap.set('n', '<leader>fd', function() fzf_lua.lsp_definitions({resume = true}) end, { desc = 'Find definition' })
vim.keymap.set('n', '<leader>fD', function() fzf_lua.lsp_typedefs({resume = true}) end, { desc = 'Find type Definition' })
vim.keymap.set('n', '<leader>fa', function() fzf_lua.lsp_code_actions({resume = true}) end, { desc = 'Find actions' })

vim.keymap.set('n', '<leader>gc', function() fzf_lua.git_bcommits({resume = true}) end, { desc = 'File history' })
vim.keymap.set('v', '<leader>gc', function() fzf_lua.git_bcommits({resume = true}) end, { desc = 'Selection history' })


-- harpoon vim.keymap.set('n', '<leader>P', function() require('harpoon'):list():add() end, { desc = 'Pin file' })
vim.keymap.set('n', '<leader>p', toggleHarpoonList, { desc = 'Show pinned files' })
vim.keymap.set("n", "<leader>1", function() require('harpoon'):list():select(1) end, { desc = "Open first pinned file" })
vim.keymap.set("n", "<leader>2", function() require('harpoon'):list():select(2) end, { desc = "Open second pinned file" })
vim.keymap.set("n", "<leader>3", function() require('harpoon'):list():select(3) end, { desc = "Open third pinned file" })
vim.keymap.set("n", "<leader>4", function() require('harpoon'):list():select(4) end, { desc = "Open fourth pinned file" })
vim.keymap.set("n", "<leader>5", function() require('harpoon'):list():select(5) end, { desc = "Open fifth pinned file" })
vim.keymap.set("n", "<leader>6", function() require('harpoon'):list():select(6) end, { desc = "Open sixth pinned file" })

-- Dap
vim.keymap.set('n', '<leader>db', require('dap').toggle_breakpoint, { desc = 'Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dc', require('dap').continue, { desc = 'Dap continue' })
vim.keymap.set('n', '<leader>ds', require('dap').step_over, { desc = 'Step Over' })
vim.keymap.set('n', '<leader>di', require('dap').step_into, { desc = 'Step Into' })
vim.keymap.set('n', '<leader>do', require('dap').step_out, { desc = 'Step Out' })
vim.keymap.set('n', '<leader>dp', require('dap-view').toggle, { desc = 'Toggle debug panel' })
vim.keymap.set('n', '<leader>di', require('nvim-dap-virtual-text').toggle, { desc = 'Toggle virtual debug text' })

local doselect = function ()
    fzf_lua.fzf_exec("ls")
end

vim.keymap.set('n', '<leader>dt', doselect)

