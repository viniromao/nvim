local function open_symbol_picker()
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local entry_display = require('telescope.pickers.entry_display')

  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, 'textDocument/documentSymbol', params, function(err, result)
    if err or not result then return end

    local priority = { Constructor = 1, Method = 2, Function = 3 }
    local items = {}

    local function flatten(symbols, prefix)
      for _, s in ipairs(symbols) do
        local kind = vim.lsp.protocol.SymbolKind[s.kind] or 'Unknown'
        local name = prefix and (prefix .. '.' .. s.name) or s.name
        local range = s.selectionRange or s.range or s.location.range
        table.insert(items, {
          name = name,
          kind = kind,
          lnum = range.start.line + 1,
          col = range.start.character + 1,
          priority = priority[kind] or 100,
        })
        if s.children then flatten(s.children, nil) end
      end
    end

    flatten(result, nil)
    table.sort(items, function(a, b)
      if a.priority ~= b.priority then return a.priority < b.priority end
      return a.lnum < b.lnum
    end)

    local displayer = entry_display.create({
      separator = ' ',
      items = { { width = 40 }, { remaining = true } },
    })

    pickers.new({}, {
      prompt_title = 'Document Symbols',
      initial_mode = 'normal',
      sorting_strategy = 'ascending',
      finder = finders.new_table({
        results = items,
        entry_maker = function(item)
          return {
            value = item,
            display = function(entry)
              return displayer({ entry.value.name, { '[' .. entry.value.kind .. ']', 'TelescopeResultsComment' } })
            end,
            ordinal = item.name,
            lnum = item.lnum,
            col = item.col,
            filename = vim.api.nvim_buf_get_name(0),
          }
        end,
      }),
      sorter = conf.generic_sorter({}),
      previewer = conf.grep_previewer({}),
    }):find()
  end)
end

vim.keymap.set('n', '<leader>e', ':NvimTreeToggle<CR>')
vim.keymap.set('n', '<leader>ff', function()
  require('telescope.builtin').find_files({
    attach_mappings = function(_, map)
      local actions = require('telescope.actions')
      map('i', '<CR>', function(prompt_bufnr)
        actions.select_default(prompt_bufnr)
        vim.defer_fn(open_symbol_picker, 200)
      end)
      return true
    end,
  })
end)
vim.keymap.set('n', '<leader>fw', ':Telescope live_grep<CR>')

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float, { desc = 'Show diagnostic on current line' })
vim.keymap.set('n', 'gd', '<cmd>Telescope lsp_definitions<CR>', { desc = 'Go to definition' })
vim.keymap.set('n', 'gi', '<cmd>Telescope lsp_implementations<CR>', { desc = 'Go to implementation' })
vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<CR>', { desc = 'Go to references (Telescope)' })
vim.keymap.set('n', '<leader>fs', open_symbol_picker, { desc = 'Find document symbols' })
vim.keymap.set('n', '<C-Left>', '<C-o>', { desc = 'Jump back' })
vim.keymap.set('n', '<C-Right>', '<C-i>', { desc = 'Jump forward' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
