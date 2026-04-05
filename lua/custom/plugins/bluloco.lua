return {
  'uloco/bluloco.nvim',
  priority = 1000,
  requires = { 'rktjmp/lush.nvim' },
  config = function()
    require('bluloco').setup {
      styles = {
        comments = { italic = false },
      },
      transparent = true,
    }
    vim.cmd.colorscheme 'bluloco-dark'

    vim.api.nvim_set_hl(0, 'Normal', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'NormalNC', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'NONE' })
    vim.api.nvim_set_hl(0, 'SignColumn', { bg = 'NONE' })
  end,
}
