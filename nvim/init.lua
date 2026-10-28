-- Global things?
vim.g.polyglot_disabled = { 'markdown' }
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Base settings
vim.opt.tabstop = 4          -- tab is 4 spaces
vim.opt.shiftwidth = 4       -- >> shifts 4
vim.opt.smarttab = true
vim.opt.expandtab = true     -- tabs to spaces
vim.opt.autoindent = true    -- shift from previous line
vim.opt.cinoptions = "g0"    -- for public/private C++
vim.opt.splitright = true    -- new vsplits open in right

vim.opt.wrap = true          -- long lines
vim.opt.linebreak = true
vim.opt.textwidth = 120
vim.opt.mouse = "a"
vim.opt.ruler = true
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.scrolloff = 5
vim.opt.cursorline = true

-- Invisible characters
vim.opt.list = true
vim.opt.listchars = {
  space = '·',      -- regular whitespace
  tab = '» ',       --	tab
  trail = '•',      -- trailing whitespaces      
  nbsp = '␣',       -- non-breaking space
}

vim.opt.termguicolors = true
vim.opt.incsearch = true

-- vim.diagnostic.open_float() and some keybinds
vim.keymap.set('n', 'ge', vim.diagnostic.open_float, { desc = "open error window" })
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, {})
vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, {})

-- terminal
local term_buf = nil
local term_win = nil

local function toggle_terminal()
  -- terminal window is open and valid (closing)
  if term_win and vim.api.nvim_win_is_valid(term_win) then
    vim.api.nvim_win_close(term_win, term_buf)
    term_win = nil
  else
    -- if terminal buffer existed before - open it
    if term_buf and vim.api.nvim_buf_is_valid(term_buf) then
      vim.cmd('botright 12new')
      vim.api.nvim_win_set_buf(0, term_buf)
    else
      -- first time opening terminal
      vim.cmd('botright 12new')
      vim.cmd('terminal')
      term_buf = vim.api.nvim_get_current_buf()
    end
    term_win = vim.api.nvim_get_current_win()
    vim.cmd('startinsert') -- insert mode
  end
end
-- Ctrl + \ toggles terminal
vim.keymap.set({ 'n', 't' }, '<C-\\>', toggle_terminal, { desc = 'Toggle terminal' })
-- Ctrl + t inside terminal toggles normal mode
vim.keymap.set('t', '<C-t>', [[<C-\><C-n>]], { silent = true })

-- Coloscheme
vim.pack.add({
  { src = "https://github.com/bluz71/vim-moonfly-colors", name = "moonfly" },
})

vim.cmd("colorscheme moonfly")
vim.opt.background = "dark"
vim.opt.laststatus = 2

vim.g.airline_theme = "moonfly"
vim.g["airline#extensions#tabline#enabled"] = 1
vim.g.airline_section_z = "%p%%   %l:%c / %L"

-- LSP diagnostic for languages
-- https://github.com/neovim/nvim-lspconfig/tree/master/lsp
vim.lsp.enable({"clangd", "pyright", "gopls", "markdown_oxide"})

vim.diagnostic.config({
  underline = true,
  signs = true,
  virtual_text = true,
  update_in_insert = true,
})

-- autocomplete and braces
vim.pack.add({
  "https://github.com/saghen/blink.lib",
  "https://github.com/saghen/blink.cmp",
  "https://github.com/Saghen/blink.pairs",
})

local cmp = require("blink.cmp")
cmp.build():pwait()
cmp.setup({
  keymap = {
    preset = "default",

    ["<Tab>"] = { "select_next", "fallback" },
    ["<S-Tab>"] = { "select_prev", "fallback" },
  },
  completion = {
    list = {
      selection = {
        preselect = false,
        auto_insert = true,
      },
    },
    menu = {
      auto_show = true,
    },
  },
  signature = {
    enabled = true,
  },
  sources = {
    default = {
      "lsp",
      "path",
      "snippets",
      "buffer",
    },
  },
  fuzzy = {
    implementation = "rust",
  },
})
local blink_pairs = require("blink.pairs")
blink_pairs.build():pwait(60000)
blink_pairs.setup()

-- file explorer (oil.nvim)
vim.pack.add({
  "https://github.com/stevearc/oil.nvim",
})

require("oil").setup({
  view_options = {
    show_hidden = false, -- show hidden files
    is_git_allowed = function(path) -- for hiding gitignored
      return true
    end,
  },
})
-- toggle for <leader>e
vim.keymap.set("n", "<leader>e", function()
  if vim.bo.filetype == "oil" then
    require("oil").close()
  else
    require("oil").open()
  end
end, { desc = "Toggle Oil" })

-- telescope
vim.pack.add({
  { src = 'https://github.com/nvim-lua/plenary.nvim' },
  { src = 'https://github.com/nvim-telescope/telescope.nvim' },
})
-- fzf-native needs a `make` step, so either prebuild or:
vim.pack.add({ { src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim', build = function() vim.fn.system({'make'}) end } })

require('telescope').setup({
  pickers = {
    find_files = {
--      hidden = true, -- search through hidden files
    },
  },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope Find Files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope Live Grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope Buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope Help Tags' })
vim.keymap.set('n', '<leader>fj', builtin.jumplist, { desc = 'Telescope Jumplist' })

-- smooth scroll
vim.pack.add({
  "https://github.com/karb94/neoscroll.nvim"
})

require('neoscroll').setup({
  mappings = {                 -- Keys to be mapped to their corresponding default scrolling animation
    '<C-u>', '<C-d>',
    '<C-b>', '<C-f>',
    '<C-y>', '<C-e>',
    'zt', 'zz', 'zb',
  },
  hide_cursor = true,          -- Hide cursor while scrolling
  stop_eof = true,             -- Stop at <EOF> when scrolling downwards
  respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
  cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
  duration_multiplier = 0.3,   -- Global duration multiplier
  easing = 'linear',           -- Default easing function
  pre_hook = nil,              -- Function to run before the scrolling animation starts
  post_hook = nil,             -- Function to run after the scrolling animation ends
  performance_mode = false,    -- Disable "Performance Mode" on all buffers.
  ignored_events = {           -- Events ignored while scrolling
      'WinScrolled', 'CursorMoved'
  },
})

-- markdown. I think it requires some command for the first time ( :something#something() )
vim.pack.add({"https://github.com/iamcco/markdown-preview.nvim"})
vim.g.mkdp_auto_close = 0 -- don't close if not in .md file in nvim
