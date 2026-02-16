vim.opt.termguicolors = true
vim.opt.cursorline = false
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.updatetime = 300
vim.opt.hidden = true
vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.guicursor = "n-v-i-c:block-Cursor"
vim.opt.wrap = true
vim.opt.colorcolumn = "80"
vim.opt.backspace = "indent,eol,start"
vim.cmd("colorscheme habamax")
vim.api.nvim_set_hl(0, "Visual", { bg = "#444444", fg = nil })
vim.g.netrw_banner = 0
vim.opt.ruler = false
vim.opt.laststatus = 0
vim.opt.showmode = true

vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"

vim.diagnostic.config({ virtual_text = false, virtual_lines = false })

vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  desc = 'Hightlight selection on yank',
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { higroup = 'IncSearch', timeout = 40 }
  end,
})

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { scope = "cursor", focusable = false, })
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local row, col = unpack(vim.api.nvim_buf_get_mark(0, '"'))
    if row > 0 and row <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, { row, col })
    end
  end,
})



vim.g.mapleader = " "

local opts = { noremap = true, silent = true }

vim.keymap.set("n", "<A-e>", ":Rex<CR>", opts)
vim.keymap.set("n", "<leader>e", ":Ex<CR>", opts)
vim.keymap.set("n", "<C-f>", ":lua vim.lsp.buf.format()<CR>", opts)

vim.keymap.set("n", "ss", ":split<CR>", opts)
vim.keymap.set("n", "sv", ":vsplit<CR>", opts)

vim.keymap.set("n", "sj", "<C-w>j", opts)
vim.keymap.set("n", "sk", "<C-w>k", opts)
vim.keymap.set("n", "sl", "<C-w>l", opts)
vim.keymap.set("n", "sh", "<C-w>h", opts)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  {
    'nvim-telescope/telescope.nvim',
    version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    config = function()
      local builtin = require('telescope.builtin')
      vim.keymap.set('n', '<leader>ff', builtin.find_files)
      vim.keymap.set('n', '<leader>fg', builtin.live_grep)
      vim.keymap.set('n', '<leader>fb', builtin.buffers)
      vim.keymap.set('n', '<leader>fh', builtin.help_tags)

      vim.keymap.set("n", "gd", builtin.lsp_definitions)
      vim.keymap.set("n", "gi", builtin.lsp_implementations)
      vim.keymap.set("n", "gr", builtin.lsp_references)
      vim.keymap.set("n", "gt", builtin.lsp_type_definitions)
    end
  },
  {
    "ThePrimeagen/harpoon",
    config = function()
      local mark = require("harpoon.mark")
      local ui = require("harpoon.ui")
      vim.keymap.set("n", "<S-n>", function() mark.add_file() end)
      vim.keymap.set("n", "<S-w>", function() ui.toggle_quick_menu() end)
      vim.keymap.set("n", "<tab>", function() ui.nav_next() end)
      vim.keymap.set("n", "<S-tab>", function() ui.nav_prev() end)
    end
  },
  {
    'windwp/nvim-autopairs',
    event = "InsertEnter",
    config = true
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    config = function()
      require("nvim-treesitter.config").setup({
        ensure_installed = { "vim", "lua", "html", "css", "javascript", "typescript", "tsx" },
        highlight = { enable = true },
        indent = { enable = true },
      })
      require("nvim-ts-autotag").setup({
        opts = {
          enable_close = true,
          enable_rename = true,
          enable_close_on_slash = false,
        },
        per_filetype = {
          ["html"] = { enable_close = true },
          ["javascriptreact"] = { enable_close = true },
          ["typescriptreact"] = { enable_close = true },
        }
      })
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      local ls = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      ls.filetype_extend("javascriptreact", { "html", "javascript" })
      ls.filetype_extend("typescriptreact", { "html", "typescript" })
      ls.filetype_extend("svelte", { "html", "javascript", "css" })
      ls.filetype_extend("vue", { "html", "javascript", "css" })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-nvim-lsp",
      "saadparwaiz1/cmp_luasnip",
    },

    config = function()
      local cmp_lsp = require("cmp_nvim_lsp")

      require("mason").setup()
      require("mason-lspconfig").setup({

        ensure_installed = {
          "lua_ls",
          "ts_ls",
          "tailwindcss",
          "html",
          "cssls",
          "bashls",
          "pyright",
        },

        automatic_enable = true
      })

      local capabilities = cmp_lsp.default_capabilities()
      local on_attach = function(client, _)
        client.server_capabilities.semanticTokensProvider = nil
      end

      local servers = { "lua_ls", "pyright", "rust_analyzer", "ts_ls", "tailwindcss", "html", "bashls", "cssls" }

      for _, lsp in ipairs(servers) do
        vim.lsp.config(lsp, {
          capabilities = capabilities,
          on_attach = on_attach,
        })
      end

      local cmp = require("cmp")
      local luasnip = require("luasnip")

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        },
        sources = {
          { name = "nvim_lsp" },
          { name = "luasnip" },
        },
      })
    end,
  },

  {
    "j-hui/fidget.nvim",
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  }

})
