return {
  'mfussenegger/nvim-dap',
  dependencies = {
    {
      'mxsdev/nvim-dap-vscode-js',
      config = function()
        require('dap-vscode-js').setup {
          adapters = { 'pwa-node', 'pwa-chrome' },
        }
      end,
    },
  },
  config = function()
    local dap = require 'dap'
    dap.adapters['pwa-node'] = {
      type = 'server',
      host = 'localhost',
      port = 8123,
      executable = {
        command = 'node',
        args = {
          os.getenv 'HOME' .. '/.local/share/nvim/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js',
          '8123',
        },
      },
    }
  end,
}
