-- OPTIONS {{{
vim.opt.number = true         -- Show line numbers
vim.opt.relativenumber = true -- Relative line numbers
vim.opt.tabstop = 4           -- Number of spaces tabs count for
vim.opt.shiftwidth = 4        -- Size of an indent
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.autoindent = true     -- Autoindent new lines
vim.opt.mouse = 'a'           -- Enable mouse support
vim.opt.termguicolors = true  -- Enable true colors
vim.opt.signcolumn = 'yes'    -- Always show sign column
vim.opt.cursorline = false     -- Highlight current line
vim.opt.wrap = false
vim.opt.expandtab = true       -- Use spaces instead of tabs
vim.opt.shiftwidth = 2         -- Indent by 2 spaces
vim.opt.tabstop = 2            -- A tab character equals 2 spaces
vim.opt.softtabstop = 2        -- Insert mode tab behaves like 2 spaces
vim.opt.smartindent = true     -- Enable smart indentation
vim.opt.autoindent = true      -- Copy indent from previous line
vim.opt.cindent = false        -- Disable C-style indent if not needed
vim.opt.shiftround = true      -- Round indent to multiples of shiftwidth
-- vim.opt.foldmethod="marker"    -- Setting marker based folding
vim.opt.foldmethod = "marker"
vim.opt.foldmarker = "{{{,}}}"
-- }}}


-- PLUGINS {{{
-- Plugin manager {{{
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
-- }}}

local is_linux = function ()
  if vim.fn.has('android') == 1 then
    -- print("Android")
    return false
  elseif vim.loop.os_uname().sysname == "Linux" then
    -- print("Linux")
    return true
end

end
-- plugins {{{
local plugins = {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000 ,
    init = function()
      vim.o.background = "dark" -- or "light" for light mode
      vim.cmd([[colorscheme gruvbox]])
    end,
    config = true,
  },
  {
    "nvimdev/indentmini.nvim",
    event = "VeryLazy",
    config = function()
      require("indentmini").setup({
        char = "▏",
        exclude = { "noice", "neo-tree", "norg" },
      })
      vim.cmd.highlight("IndentLine guifg=gray30")
      vim.cmd.highlight("IndentLineCurrent guifg=gray70")
    end,
  },
  {
		"echasnovski/mini.icons",
		version = "*",
		init = function()
			package.preload["nvim-web-devicons"] = function()
				package.loaded["nvim-web-devicons"] = {}
				require("mini.icons").mock_nvim_web_devicons()
				return package.loaded["nvim-web-devicons"]
			end
		end,
		config = function()
      require('mini.icons').setup()
		end,
	},
  {
    'echasnovski/mini.tabline',
    version = '*',
    enabled = is_linux(),
    config = function()
      require('mini.tabline').setup()
    end,
  },
  {
    "echasnovski/mini.clue",
    version = "*",
    event = "VeryLazy",
    config = function()
      local clue = require("mini.clue")
      clue.setup({
        triggers = {
          -- Leader triggers
          { mode = "n", keys = "<Leader>" },
          { mode = "x", keys = "<Leader>" },

          -- Built-in completion
          { mode = "i", keys = "<C-x>" },

          -- `g` key
          { mode = "n", keys = "g" },
          { mode = "x", keys = "g" },

          -- Marks
          { mode = "n", keys = "'" },
          { mode = "n", keys = "`" },
          { mode = "x", keys = "'" },
          { mode = "x", keys = "`" },

          -- Registers
          { mode = "n", keys = '"' },
          { mode = "x", keys = '"' },
          { mode = "i", keys = "<C-r>" },
          { mode = "c", keys = "<C-r>" },

          -- Window commands
          { mode = "n", keys = "<C-w>" },

          -- `z` key
          { mode = "n", keys = "z" },
          { mode = "x", keys = "z" },
        },

        clues = {
          { mode = "n", keys = "<Leader>b", desc = "+Buffers" },
          { mode = "n", keys = "<Leader>f", desc = "+Find" },
          -- Enhance this by adding descriptions for <Leader> mapping groups
          clue.gen_clues.builtin_completion(),
          clue.gen_clues.g(),
          clue.gen_clues.marks(),
          clue.gen_clues.registers(),
          clue.gen_clues.windows(),
          clue.gen_clues.z(),
        },

        window = {
          delay = 0,
          -- anchor
          -- 'NW' -- top-left
          -- 'NE' -- top-right
          -- 'SW' -- bottom-left
          -- 'SE' -- bottom-right
          config = { anchor = "SE", row = "auto", col = "auto", width = "auto", border = "single" },
          scroll_down = "<C-d>",
          scroll_up = "<C-u>",
        },
      })

    end,
  },
}
-- }}}

-- Plugin: picker {{{
plugins.picker = {
      {
    "echasnovski/mini.pick",
    version = false,
    dependencies = {
      {
        'echasnovski/mini.extra',
        version = '*',
        config = function ()
          require("mini.extra").setup({})
        end
      },
    },
    cmd = "Pick",
    keys = {
      { "<leader>ff", "<cmd>Pick files<CR>", desc = "Find files" },
      { "<leader>fb", "<cmd>Pick buffers<CR>", desc = "Find buffers" },
      { "<leader>fr", "<cmd>Pick resume<CR>", desc = "Resume finding" },
      { "<leader>fh", "<cmd>Pick help<CR>", desc = "Find help" },
      { "<leader>fo", "<cmd>Pick oldfiles<CR>", desc = "Find oldfiles" },
      { "<leader>fd", "<cmd>Pick diagnostic scope='current'<CR>", desc = "Find current diagnostic" },
      { "<leader>fD", "<cmd>Pick diagnostic scope='all'<CR>", desc = "Find all diagnostic" },
      { "<leader>fg", "<cmd>Pick grep_live<CR>", desc = "Grep live whole project" },
      { "<leader>/", "<cmd>Pick buf_lines<CR>", desc = "Grep live in current buffer" },
      { "<leader>fB", "<cmd>Pick buildins<CR>", desc = "Find buildins" },
      { "<leader>Fn", "<cmd>Pick nvim_config<CR>", desc = "Find within neovim config" },
      { "<leader>Fd", "<cmd>Pick dotfiles<CR>", desc = "Find within dotfiles" },
      { "<leader>Fc", "<cmd>Pick config_dir<CR>", desc = "Find within config_dir" },
    },
    config = function ()
      local pick = require("mini.pick")
      local options = {}
      pick.setup(options)

      pick.registry.nvim_config = function(local_opts)
        local opts = {
          source = { cwd = vim.fn.stdpath("config"), name = "Neovim Config" },
          window = { prompt_prefix = " : " },
        }
        local_opts.cwd = nil
        return pick.builtin.files(nil, opts)
      end
      pick.registry.dotfiles = function(local_opts)
        local opts = {
          source = { cwd = vim.fn.expand("~/dotfiles"), name = "Neovim Config" },
          window = { prompt_prefix = " : " },
        }
        local_opts.cwd = nil
        return pick.builtin.files(nil, opts)
      end
      pick.registry.config_dir = function(local_opts)
        local opts = {
          source = { cwd = vim.fn.expand("~/.config"), name = "Neovim Config" },
          window = { prompt_prefix = "󱞞 : " },
        }
        local_opts.cwd = nil
        return pick.builtin.files(nil, opts)
      end

      pick.registry.buildins = function()
        local items = vim.tbl_keys(pick.registry)
        table.sort(items)
        local source = { items = items, name = "Buildins", choose = function() end }
        local chosen_picker_name = pick.start({ source = source })
        if chosen_picker_name == nil then
          return
        end
        return pick.registry[chosen_picker_name]()
      end
    end,
  },
}
-- }}}

-- plugins: lsp, maosn {{{
plugins.maosn = {
  {
    "mason-org/mason.nvim",
    cmd = { "Mason" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "WhoIsSethDaniel/mason-tool-installer.nvim",
    },
    config = function ()
      local mason = require("mason")
      local mason_lspconfig = require("mason-lspconfig")
      local mason_tool_installer = require("mason-tool-installer")
      mason.setup()
      mason_lspconfig.setup({
        ensure_installed = {
          "lua_ls",
        },
      })

      mason_tool_installer.setup({
        ensure_installed = {
          "stylua",
        },
      })
    end
  },
}
-- }}}
-- plugins: formatter, treesitter {{{
plugins.treesitter_and_formatter = {
    {
    "nvim-treesitter/nvim-treesitter",
    name = "treesitter",
    cmd = { "TSInstall", "TSBufEnable", "TSBufDisable", "TSModuleInfo" },
    build = ":TSUpdate",
    event = {
      "BufReadPost",
      "BufNewFile",
    },
    config = function()
      local treesitter = require("nvim-treesitter.configs")
      treesitter.setup({
        ensure_installed = {
          "bash",
          "lua",
          "nix",
          "query",
          "vim",
          "vimdoc",
        },
        highlight = {
          enable = true,
        },
        indent = { enable = true },
        autotag = {
          enable = true,
        },
      })

    end,
  },
}
-- }}}
-- plugins: complition

require("lazy").setup({
  spec = {
    plugins,
    plugins.maosn,
    plugins.picker,
    plugins.treesitter_and_formatter,
  },
  install = { colorscheme = { "habamax" } },
  checker = { enabled = true },
})
-- }}}


-- KEYMAPS {{{
vim.g.mapleader = ' '

-- Toggle netrw 
vim.keymap.set('n', '<leader>e', function()
  if vim.bo.filetype == 'netrw' then
    vim.cmd('bd')  -- close netrw buffer if open
  else
    vim.cmd('Lexplore')  -- open netrw on left
  end
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>ol", "<cmd>Lazy<CR>", { desc = "Open lazy manager" })
vim.keymap.set("n", "<leader>om", "<cmd>Mason<CR>", { desc = "Open mason manager" })

-- Buffer navigation
vim.keymap.set('n', '<leader>bn', ':bnext<CR>', { desc = 'Next buffer' })  -- Next buffer
vim.keymap.set('n', '<leader>bp', ':bprevious<CR>', { desc = 'Previous buffer' })
vim.keymap.set('n', '<leader>bd', ':bdelete<CR>', { desc = 'Close buffer' })

-- Window navigation (split management)
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = 'Move to left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = 'Move to bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = 'Move to top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = 'Move to right window' })

-- -- Resize splits
-- vim.keymap.set('n', '<Up>', ':resize +2<CR>', { silent = true })
-- vim.keymap.set('n', '<Down>', ':resize -2<CR>', { silent = true })
-- vim.keymap.set('n', '<Left>', ':vertical resize -2<CR>', { silent = true })
-- vim.keymap.set('n', '<Right>', ':vertical resize +2<CR>', { silent = true })

-- Save with Ctrl+S (works in normal and insert mode)
vim.keymap.set({'i', 'n'}, '<C-s>', '<ESC>:w<CR>', { desc = 'Save file' })

-- Escape insert mode quickly
vim.keymap.set('i', 'jk', '<ESC>', { desc = 'Exit insert mode' })

-- Move lines up/down in visual mode
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line down' })
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line up' })

-- Keep cursor centered during searches/scrolls
vim.keymap.set('n', 'n', 'nzzzv', { desc = 'Next search result (centered)' })
vim.keymap.set('n', 'N', 'Nzzzv', { desc = 'Previous search result (centered)' })
vim.keymap.set('n', '<C-d>', '<C-d>zz', { desc = 'Scroll down (centered)' })
vim.keymap.set('n', '<C-u>', '<C-u>zz', { desc = 'Scroll up (centered)' })

-- -- Toggle line numbers
-- vim.keymap.set('n', '<leader>un', function()
--   vim.opt.number = not vim.opt.number._value
--   vim.opt.relativenumber = not vim.opt.relativenumber._value
-- end, { desc = 'Toggle line numbers' })

-- Toggle spell check
vim.keymap.set('n', '<leader>us', ':set spell!<CR>', { desc = 'Toggle spell check' })

-- Clear search highlights
vim.keymap.set('n', '<leader>cs', ':nohlsearch<CR>', { desc = 'Clear search highlights' })

-- Quick file reload
vim.keymap.set('n', '<leader>r', ':e!<CR>', { desc = 'Reload file' })
-- }}}
