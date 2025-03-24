return {
  'uloco/bluloco.nvim',
  priority = 1000,
  requires = { 'rktjmp/lush.nvim' },
  config = function()
    require('bluloco').setup {
      styles = {
        comments = { italic = false },
      },
    }
    vim.cmd.colorscheme 'bluloco-dark'
  end,
}
