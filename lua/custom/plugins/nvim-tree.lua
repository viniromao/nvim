return {
  'nvim-tree/nvim-tree.lua',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('nvim-tree').setup {
      update_focused_file = {
        enable = true,
        update_cwd = true,
        ignore_list = {},
      },
      respect_buf_cwd = true,
    }
  end,
}
