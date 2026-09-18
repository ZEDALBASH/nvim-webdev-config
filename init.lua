-- ======================= Basic Settings
-- ========================
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.g.mapleader = " "

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
    { "L3MON4D3/LuaSnip", dependencies = {"rafamadriz/friendly-snippets",}, config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end, },
    { "rafamadriz/friendly-snippets" },
    { "saadparwaiz1/cmp_luasnip" }, 
    -- Colors themes 
    { "Mofiqul/vscode.nvim"},
    -- Syntax highlighting
    { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

    -- autotag
    { "windwp/nvim-autopairs" },
    { "mattn/emmet-vim" },
    { "windwp/nvim-ts-autotag"},
    -- quick comment plugin
    { "numToStr/Comment.nvim"},

    -- Fuzzy Finder
    { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

    -- File Explorer & UI
    { "nvim-tree/nvim-tree.lua" },
    { "nvim-tree/nvim-web-devicons" },
    { "folke/tokyonight.nvim" },
    
    -- Formatters
    {"stevearc/conform.nvim"},
})

  -- ========================
  -- Plugins Config
  -- ========================



-- Mason
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "ts_ls", "html", "cssls", "jsonls", "eslint", "clangd"},
})

-- LSP (Neovim 0.11+ API)
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config.ts_ls = { capabilities = capabilities }
vim.lsp.config.html = { capabilities = capabilities }
vim.lsp.config.cssls = { capabilities = capabilities }
vim.lsp.config.jsonls = { capabilities = capabilities }
vim.lsp.config.eslint = { capabilities = capabilities }
vim.lsp.config.clangd = { capabilities = capabilites }
vim.lsp.enable("ts_ls")
vim.lsp.enable("html")
vim.lsp.enable("cssls")
vim.lsp.enable("jsonls")
vim.lsp.enable("eslint")
vim.lsp.enable("clangd")
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
  require("nvim-treesitter").setup({
    ensure_installed = { "lua", "javascript", "typescript", "tsx", "json", "css", "html", "clangd" },
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

  vim.keymap.set("n", "<Leader>t",":NvimTreeToggle<CR>", {noremap = true , silent = true})

  -- ========================
  -- autotags
  -- ========================

  require("nvim-autopairs").setup({
    check_ts = true
  })
  
  require("nvim-ts-autotag").setup({})
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
vim.cmd.colorscheme("tokyonight")

-- =======================
-- conform
-- =======================




require("conform").setup({
	formatters_by_ft = { 
		javascript = { "prettier" },
		javascriptreact = { "prettier" },
		typescript = {"prettier"},
		typescriptreact = {"prettier"}, 
		html = {"prettier"},
		css = {"prettier"},
		json = {"prettier"},
		lua = {"stylua"},
    c = {"clang-format"},
    cpp = {"clang-format"},
	},
	format_on_save = {
	timeout_ms = 500, 
	lsp_format = "fallback",
},})




