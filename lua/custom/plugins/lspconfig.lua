
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
    vim.lsp.config('lua_ls', {})
    vim.lsp.config('jsonls', {})
    vim.lsp.config('lemminx', {})
    vim.lsp.config('kotlin_ls', {})
    vim.lsp.config('gopls', {})
    vim.lsp.enable({ 'lua_ls', 'jsonls', 'lemminx', 'kotlin_ls', 'gopls' })

    require('mason').setup()

    require('mason-lspconfig').setup {
      ensure_installed = {
        'lua_ls',
        'jsonls',
        'jdtls',
        'lemminx',
        'kotlin_ls',
        'gopls',
      },
      automatic_installation = true,
    }

    require("typescript-tools").setup {}
  end,
}

