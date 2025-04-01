
return {
  'neovim/nvim-lspconfig',
  dependencies = {
    { 'williamboman/mason.nvim', opts = {} },
    'williamboman/mason-lspconfig.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    { 'j-hui/fidget.nvim', opts = {} },
    'hrsh7th/cmp-nvim-lsp',

    -- 👇 Add this
    {
      "pmizio/typescript-tools.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      opts = {}, -- optional custom config
    },
  },
  config = function()
    local lspconfig = require 'lspconfig'

    -- Setup other LSPs normally
    lspconfig.lua_ls.setup {}
    lspconfig.jsonls.setup {}

    -- Setup mason without tsserver
    require('mason').setup()

    require('mason-lspconfig').setup {
      ensure_installed = {
        'lua_ls',
        'jsonls',
        -- ⛔ REMOVE tsserver
      },
      automatic_installation = true,
    }

    -- 👇 Setup typescript-tools (replaces tsserver)
    require("typescript-tools").setup {}
  end,
}

