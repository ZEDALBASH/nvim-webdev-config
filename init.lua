-- ======================= Basic Settings
-- ========================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
-- ========================
-- Lazy.nvim (Plugin Manager)
-- ========================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
  end
  vim.opt.rtp:prepend(lazypath)

  require("lazy").setup({
    -- LSP & Autocompletion
    { "neovim/nvim-lspconfig" },
    { "williamboman/mason.nvim", config = true },
    { "williamboman/mason-lspconfig.nvim" },
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "L3MON4D3/LuaSnip" },
    { "rafamadriz/friendly-snippets" },
    { "saadparwaiz1/cmp_luasnip" },
    
    -- Colors themes 
    { "Mofiqul/vscode.nvim"},
    -- Syntax highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- Fuzzy Finder
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

    -- File Explorer & UI
    { "nvim-tree/nvim-tree.lua" },
    { "nvim-tree/nvim-web-devicons" },
    { "folke/tokyonight.nvim" },
    
    -- Formatters
    {"mhartington/formatter.nvim"},
  })

  -- ========================
  -- Plugins Config
  -- ========================
  -- Theme
  vim.cmd.colorscheme("vim")
-- Mason
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "ts_ls", "html", "cssls", "jsonls", "eslint" },
})

-- LSP (Neovim 0.11+ API)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config.ts_ls = { capabilities = capabilities }
vim.lsp.config.html = { capabilities = capabilities }
vim.lsp.config.cssls = { capabilities = capabilities }
vim.lsp.config.jsonls = { capabilities = capabilities }
vim.lsp.config.eslint = { capabilities = capabilities }

vim.lsp.enable("ts_ls")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("jsonls")
vim.lsp.enable("eslint")

-- Autocompletion (cmp)
local cmp = require("cmp")
cmp.setup({
  snippet = { expand = function(args) require("luasnip").lsp_expand(args.body) end },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  }),
  sources = { { name = "nvim_lsp" } },
})


  -- ========================
  -- Treesitter
  -- ========================
  require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "javascript", "typescript", "tsx", "json", "css", "html" },
    highlight = { enable = true },
    view = {mapping = {
    list = {
      {key = "o", action = "edit"},
      {key = "v", action = "vsplit"},
      {key = "s", action = "split"},
      {key = "r", action = "rename"},
      {key = "c", action = "copy"},
      {key = "x", action = "cut"},
      {key = "p", action = "paste"},
      {key = "q", action = "close"},
    }}} 
      
  })

  -- ========================
  -- Telescope
  -- ========================
  local builtin = require("telescope.builtin")
  vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
  vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})

  -- ========================
  -- File Explorer
  -- ========================
  require("nvim-tree").setup()
  vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })


-- ========================
-- Theme / Colors
-- =======================

vim.cmd.colorscheme("vscode")
vim.cmd([[highlight Normal guibg=#1a1a1a guifg=#00ff00
highlight NormalNC guibg=#1a1a1a guifg=#00ff00
highlight NvimTreeNormal guibg=#1a1a1a guifg=#00FF00
highlight NvimTreeVertSplit guibg=#1a1a1a guifg=#00FF00
highlight NvimTreeEndOfBuffer guibg=#1a1a1a guifg=#00FF00]])

-- =======================
-- Formatter.nvim
-- =======================   
local prettier = vim.fn.expand("~/.local/share/nvim/mason/bin/prettier")

require("formatter").setup({
  logging = true,  -- turn on logging to see errors
  filetype = {
    javascript = {
      function()
      return {
        exe = prettier,
        args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
                           stdin = true,
      }
      end
    },
    typescript = {
      function()
      return {
        exe = prettier,
        args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
                           stdin = true,
      }
      end
    },
    typescriptreact = {
      function()
      return {
        exe = prettier,
        args = { "--stdin-filepath", vim.api.nvim_buf_get_name(0) },
                           stdin = true,
      }
      end
    },
  }
})


-- Auto-format on save
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*",
  callback = function() vim.cmd("Format") end,
})

