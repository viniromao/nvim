return {
  'barrett-ruth/live-server.nvim',
  build = 'npm install -g live-server',
  config = true,
  keys = {
    { '<leader>ls', '<cmd>LiveServerStart<cr>', desc = 'Start Live Server' },
    { '<leader>lS', '<cmd>LiveServerStop<cr>', desc = 'Stop Live Server' },
  },
}
