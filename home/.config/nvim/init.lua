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

vim.o.autocomplete = true
vim.opt.completeopt = { 'menuone', 'noselect' }
vim.o.pumborder = 'rounded'
vim.o.pumheight = 5


vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Remove highlight' })

-- Windows
vim.keymap.set('n', '<leader>ws', '<C-w>v', { desc = 'Split window vertically' })
vim.keymap.set('n', '<leader>wS', '<C-w>s', { desc = 'Split window horizontally' })
vim.keymap.set('n', '<leader>wh', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<leader>wl', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<leader>wj', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<leader>wk', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Lsp
vim.pack.add({ 'https://github.com/neovim/nvim-lspconfig' })
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
        local client = vim.lsp.get_client_by_id(ev.data.client_id)
        if client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
        end
    end
})

vim.keymap.set('n', '<leader><leader>', function()
    vim.lsp.buf.format()
    vim.lsp.buf.code_action { context = { only = { 'source.organizeImports' }, diagnostics = {}, async = false, }, apply = true, }
end, { desc = 'Organize imports and format' })

vim.lsp.enable('gopls')
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


vim.diagnostic.config({
    virtual_lines = {
        only_current_line = true,
        highlight_whole_line = true,
    },
    virtual_text = false
})

vim.keymap.set('n', '<leader>a', vim.lsp.buf.code_action, { desc = 'Actions' })
vim.keymap.set('n', '<leader>r', vim.lsp.buf.rename, { desc = 'Rename' })
vim.keymap.set('n', '<leader>k', vim.lsp.buf.hover, { desc = 'Hover documentation' })
vim.keymap.set('n', '<leader>d', vim.lsp.buf.definition, { desc = 'Definition' })
vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = 'Type Definition' })


-- Minipick
vim.pack.add({ 'https://github.com/nvim-mini/mini.pick' })
require('mini.pick').setup()
vim.pack.add({ 'https://github.com/nvim-mini/mini.extra' })
require('mini.extra').setup()
vim.keymap.set('n', '<leader>sf', '<CMD>Pick files<CR>', { desc = 'Search files' })
vim.keymap.set('n', '<leader>st', '<CMD>Pick grep live pattern=""<CR>', { desc = 'Search Text' })
--vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = 'Search current word' }) -- TODO:
vim.keymap.set('n', '<leader>sb', '<CMD>Pick buffers<CR>', { desc = 'Search buffers' })
vim.keymap.set('n', '<leader>se', '<CMD>Pick diagnostic<CR>', { desc = 'Search Errors' })
vim.keymap.set('n', '<leader>sh', '<CMD>Pick help<CR>', { desc = 'Search Help' })
vim.keymap.set('n', '<leader>sk', '<CMD>Pick keymaps<CR>', { desc = 'Search Keymaps' })

vim.keymap.set('n', '<leader>su', '<CMD>Pick lsp scope="references"<CR>', { desc = 'Usages' })
vim.keymap.set('n', '<leader>si', '<CMD>Pick lsp scope="implementation"<CR>', { desc = 'Implementations' })
vim.keymap.set('n', '<leader>ss', '<CMD>Pick lsp scope="workspace_symbol_live"<CR>', {desc = 'Search Symbols'})

vim.keymap.set('n', '<leader>sr', '<CMD>Pick resume', { desc = 'Resume search' })


-- Oil
vim.pack.add({ 'https://github.com/stevearc/oil.nvim' })
vim.keymap.set('n', '<leader>o', '<CMD>Oil<CR>', { desc = 'Containing directory' })
require('oil').setup({
    default_file_explorer = true,
    keymaps = {
        ['<leader>p'] = { 'actions.preview', mode = 'n', desc = 'Preview' },
        ['<leader>.'] = { 'actions.toggle_hidden', mode = 'n', desc = 'Show hidden files' },
    },
    preview_win = {
        update_on_cursor_moved = true,
        preview_method = "fast_scratch",
        win_options = {},
    },
})

-- Graphics
vim.pack.add({'https://github.com/jbyuki/venn.nvim'})
local function toggle_graphics_mode()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "b", ":VBox<CR>", {noremap = true})
    else
        vim.cmd[[setlocal ve=]]
        vim.api.nvim_buf_del_keymap(0, "n", "J")
        vim.api.nvim_buf_del_keymap(0, "n", "K")
        vim.api.nvim_buf_del_keymap(0, "n", "L")
        vim.api.nvim_buf_del_keymap(0, "n", "H")
        vim.api.nvim_buf_del_keymap(0, "v", "b")
        vim.b.venn_enabled = nil
    end
end
vim.keymap.set('n', '<leader>g', toggle_graphics_mode, { desc = 'Toggle graphics mode' })

-- which-key
vim.pack.add({ 'https://github.com/folke/which-key.nvim' })
require('which-key').setup({
    spec = {
        { '<leader>s', group = 'Search' },
        { '<leader>w', group = 'Window' }
    }
})

-- Colorschemes
vim.pack.add({ 'https://github.com/vague-theme/vague.nvim' })
vim.cmd.colorscheme('vague')


vim.pack.add({ 'https://github.com/sakshamgupta05/vim-todo-highlight' })
