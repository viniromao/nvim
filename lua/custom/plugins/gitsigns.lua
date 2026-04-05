return {
  'lewis6991/gitsigns.nvim',
  opts = {
    signs = {
      add = { text = '+' },
      change = { text = '~' },
      delete = { text = '_' },
      topdelete = { text = '‾' },
      changedelete = { text = '~' },
    },
    on_attach = function(bufnr)
      local gitsigns = require 'gitsigns'
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      map('n', '<leader>hb', gitsigns.blame_line, { desc = 'git blame line' })
      map('n', '<leader>tb', gitsigns.toggle_current_line_blame, { desc = 'Toggle git blame line' })
      map('n', '<leader>hB', function() gitsigns.blame() end, { desc = 'git blame full file' })
      map('n', '<leader>hp', gitsigns.preview_hunk, { desc = 'git preview hunk' })
      map('n', '<leader>hd', gitsigns.diffthis, { desc = 'git diff against index' })
    end,
  },
}
